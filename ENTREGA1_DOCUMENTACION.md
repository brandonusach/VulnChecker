# VulnChecker — Documentación Entrega 1

## ¿Qué es este proyecto?

**VulnChecker** es un middleware que actúa como puente entre el servidor Wazuh (herramienta de seguridad) y una futura aplicación frontend. Su trabajo es conectarse a Wazuh, autenticarse, consultar vulnerabilidades y exponerlas como una API REST.

---

## Arquitectura general

```
[Tu máquina - localhost:8080]
         |
         |  Túnel SSH (puerto 2222)
         |
[Servidor Wazuh]
    |              |
    |              |
[Manager API]  [Indexer OpenSearch]
 puerto 55000    puerto 9200
 (JWT auth)      (Basic Auth)
```

El middleware corre en tu máquina. Se conecta al servidor del lab vía SSH y abre dos "canales" por ese túnel:
- Uno hacia el **Manager API** de Wazuh → para obtener versión y agentes
- Uno hacia el **Indexer** (OpenSearch) → para consultar vulnerabilidades

---

## ¿Qué es un Túnel SSH y por qué se usa?

Normalmente la API de Wazuh (puerto 55000) no es accesible desde internet por seguridad. Solo está disponible dentro de la red interna del servidor.

El túnel SSH permite **redirigir un puerto local de tu máquina hacia un puerto remoto**, pasando por una conexión SSH cifrada.

```
Tu máquina                    Servidor Wazuh
localhost:55001  --SSH-->  127.0.0.1:55000  (Manager API)
localhost:9201   --SSH-->  172.19.0.2:9200  (Indexer)
```

Cuando el código llama a `https://127.0.0.1:55001/manager/info`, en realidad está llegando a la API de Wazuh dentro del servidor, sin exposición directa al exterior.

### Código relevante: `SshTunnel.java`

```
openTunnel() → conecta SSH → abre 2 forwards de puertos → retorna sesión activa
closeTunnel() → cierra la sesión cuando la app se detiene
```

---

## ¿Qué es JWT y cómo funciona con Wazuh?

**JWT (JSON Web Token)** es un estándar para autenticación sin guardar sesiones en el servidor. Funciona así:

### Paso 1 — Login (obtener el token)
```
POST /security/user/authenticate
Authorization: Basic base64(usuario:contraseña)

Respuesta:
{
  "data": {
    "token": "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ3..."
  }
}
```

### Paso 2 — Usar el token en cada request
```
GET /manager/info
Authorization: Bearer eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9...

Respuesta:
{
  "data": {
    "version": "4.9.0",
    "hostname": "wazuh-manager",
    ...
  }
}
```

### ¿Qué tiene dentro el token JWT?
Un JWT tiene 3 partes separadas por puntos (`.`):

```
eyJhbGciOiJFUzUxMiJ9   .   eyJ1c2VyIjoid2F6dWgifQ   .   <firma>
     HEADER                        PAYLOAD                  SIGNATURE
  (algoritmo)                (datos: usuario, expiración)   (verificación)
```

Se puede decodificar en [jwt.io](https://jwt.io) para ver el contenido.

### ¿Por qué Wazuh usa JWT y no solo usuario/contraseña?

- **Eficiencia**: con Basic Auth habría que verificar usuario/contraseña en cada request. Con JWT, solo se verifica la firma matemática del token (más rápido).
- **Expiración**: el token expira automáticamente a los 900 segundos (15 min). Después hay que pedir uno nuevo.
- **Sin estado**: el servidor no guarda sesiones, el token es autocontenido.

### Caché del token en el proyecto

`WazuhAuthService.java` guarda el token en memoria y solo pide uno nuevo cuando está por expirar (cada 890 segundos), evitando hacer login en cada request:

```
getToken() → ¿token válido? → SÍ → retorna el que tiene guardado
                            → NO → llama a Wazuh → guarda nuevo token → retorna
```

---

## ¿Qué es el Indexer y por qué usa Basic Auth en vez de JWT?

Wazuh tiene **dos componentes** separados:

| Componente | Puerto | Autenticación | Para qué |
|------------|--------|---------------|----------|
| Manager API | 55000 | JWT | Gestión: agentes, reglas, versión |
| Indexer (OpenSearch) | 9200 | Basic Auth | Búsqueda de datos: vulnerabilidades, alertas |

El Indexer es básicamente una base de datos OpenSearch. Usa Basic Auth porque es más simple para queries de lectura masiva, y tiene su propio sistema de seguridad.

---

## Flujo completo al llamar `/api/wazuh/status`

```
1. Cliente llama GET http://localhost:8080/api/wazuh/status

2. WazuhController verifica si el túnel SSH está activo
   └─ Si no → responde 503 "DESCONECTADO"

3. WazuhController llama a WazuhManagerService.getManagerInfo()
   └─ WazuhManagerService pide token a WazuhAuthService.getToken()
       └─ Si el token está en caché y vigente → lo usa
       └─ Si no → POST https://127.0.0.1:55001/security/user/authenticate
                  → guarda token nuevo en memoria
   └─ GET https://127.0.0.1:55001/manager/info con Bearer token
   └─ Retorna {version: "4.9.0", hostname: "...", ...}

4. WazuhController llama a WazuhManagerService.getAgents()
   └─ Reutiliza el mismo token del caché
   └─ GET https://127.0.0.1:55001/agents con Bearer token
   └─ Retorna lista de agentes [{id, name, ip, status, version}, ...]

5. WazuhController construye la respuesta final:
   {
     "estado": "CONECTADO",
     "wazuh_version": "4.9.0",
     "wazuh_ip": "172.19.0.2",
     "total_agentes": 4,
     "agentes": [...]
   }
```

---

## Flujo completo al llamar `/api/wazuh/vulnerabilities?severity=Critical`

```
1. Cliente llama GET http://localhost:8080/api/wazuh/vulnerabilities?severity=Critical

2. WazuhController verifica túnel activo

3. WazuhController llama WazuhIndexerService.getVulnerabilities("Critical", null, 10)

4. WazuhIndexerService valida que "Critical" sea un valor permitido
   └─ Valores permitidos: Critical, High, Medium, Low

5. WazuhIndexerService construye query OpenSearch:
   {
     "size": 10,
     "query": {
       "bool": {
         "filter": [
           {"term": {"vulnerability.severity": "Critical"}}
         ]
       }
     }
   }

6. POST https://127.0.0.1:9201/wazuh-states-vulnerabilities-*/_search
   Authorization: Basic admin:SecretPassword
   (este es el Indexer, usa Basic Auth, no JWT)

7. WazuhIndexerService parsea la respuesta y la simplifica:
   {
     "total": 42,
     "filtros_aplicados": {"severidad": "Critical", "agente": "todos"},
     "vulnerabilidades": [
       {
         "cve": "CVE-2021-44228",
         "severidad": "Critical",
         "descripcion": "Log4Shell vulnerability...",
         "paquete": "log4j 2.14.1",
         "agente_id": "001",
         "agente_nombre": "ubuntu-server"
       },
       ...
     ]
   }
```

---

## Componentes del proyecto

### `VulncheckApplication.java`
Punto de entrada. Solo arranca Spring Boot. No tiene lógica de negocio.

### `config/SshTunnel.java`
Abre la conexión SSH y registra dos port-forwards:
- `localhost:9201` → `172.19.0.2:9200` (Indexer)
- `localhost:55001` → `127.0.0.1:55000` (Manager API)

Lee su configuración de `application.properties` con `@Value`.

### `config/TunnelConfig.java`
Gestiona el ciclo de vida del túnel:
- `@PostConstruct` → abre el túnel cuando la app arranca
- `@PreDestroy` → cierra el túnel cuando la app se detiene
- Si el túnel falla, la app arranca igual pero en estado DESCONECTADO

### `config/RestTemplateConf.java`
Configura el cliente HTTP para aceptar certificados SSL autofirmados. Wazuh usa HTTPS con un certificado propio (no de una CA oficial), por lo que sin esta configuración Spring rechazaría la conexión.

### `service/WazuhAuthService.java`
- Llama a `POST /security/user/authenticate` con Basic Auth
- Guarda el token JWT en memoria con su tiempo de expiración
- `getToken()` retorna siempre un token válido (renueva solo cuando expira)

### `service/WazuhManagerService.java`
- `getManagerInfo()` → `GET /manager/info` → versión de Wazuh
- `getAgents()` → `GET /agents` → lista de agentes registrados
- Usa siempre JWT (via WazuhAuthService)

### `service/WazuhIndexerService.java`
- `getVulnerabilities(severity, agentId, size)` → consulta OpenSearch
- Construye queries dinámicas según los filtros recibidos
- Valida los valores de severidad para evitar queries inválidas
- Usa Basic Auth (no JWT) porque el Indexer es OpenSearch

### `controller/WazuhController.java`
Expone dos endpoints REST:

```
GET /api/wazuh/status
   → Estado de conexión, versión de Wazuh, lista de agentes

GET /api/wazuh/vulnerabilities
   Parámetros opcionales:
   - severity: Critical | High | Medium | Low
   - agente:   ID del agente (ej: 001)
   - size:     cantidad de resultados (default 10, máx 100)
```

---

## Pipeline CI/CD (`Jenkinsfile`)

```
┌─────────┐    ┌──────┐    ┌───────────────────┐    ┌─────────────┐
│  Build  │ -> │ Test │ -> │ SonarQube Analysis │ -> │Quality Gate │
└─────────┘    └──────┘    └───────────────────┘    └─────────────┘
mvn compile    mvn test     mvn sonar:sonar          pasa/falla
```

### ¿Qué es SonarQube?
Herramienta que analiza el código fuente en busca de:
- **Bugs**: errores potenciales en el código
- **Code smells**: código que funciona pero está mal escrito
- **Vulnerabilidades de seguridad**: uso de funciones inseguras
- **Deuda técnica**: cuánto tiempo tomaría arreglar todos los problemas

El **Quality Gate** es un umbral configurable. Si el código supera cierto nivel de deuda técnica o tiene bugs críticos, el pipeline falla y no se despliega.

---

## Estructura final del proyecto

```
vulncheck/
├── Jenkinsfile                          → Pipeline de 4 stages
├── sonar-project.properties            → Config de SonarQube
├── pom.xml                             → Dependencias Maven + plugin Sonar
└── src/main/
    ├── resources/
    │   └── application.properties      → IPs, puertos, credenciales
    └── java/cl/usach/devsecops/vulncheck/
        ├── VulncheckApplication.java
        ├── config/
        │   ├── SshTunnel.java
        │   ├── TunnelConfig.java
        │   └── RestTemplateConf.java
        ├── service/
        │   ├── WazuhAuthService.java
        │   ├── WazuhManagerService.java
        │   └── WazuhIndexerService.java
        └── controller/
            └── WazuhController.java
```

---

## Lo que cumple de la Entrega 1

| Requisito del profe | Cómo se cumple |
|---------------------|----------------|
| Middleware como demonio/servicio | Spring Boot corre como proceso de fondo |
| Comunicación con Wazuh | Túnel SSH + JWT + llamadas a Manager API |
| "Hola soy Wazuh versión X en IP Y" | `GET /api/wazuh/status` |
| Ver agentes del lab | Campo `agentes` en la respuesta de `/status` |
| Filtros (1-2 mínimo) | `?severity=` y `?agente=` en `/vulnerabilities` |
| Pipeline con SonarQube | `Jenkinsfile` con 4 stages y Quality Gate |

---

## Lo que viene en Entrega 2

- Conectar el frontend (React/Vue) al middleware
- Mostrar vulnerabilidades en pantalla con gráficos
- Filtros visuales (dropdowns, búsqueda)
- Más endpoints según lo que pida el profe
- Análisis dinámico con herramientas DAST (OWASP ZAP, etc.)
