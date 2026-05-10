# VulnChecker — Documentación Entrega 1

## ¿Qué es este proyecto?

**VulnChecker** es un middleware que actúa como puente entre el servidor Wazuh del laboratorio y quien quiera consultar vulnerabilidades. Se conecta directamente al Wazuh del lab, consulta datos reales y los expone como una API REST.

---

## Arquitectura real (lab)

```
[PC alumno 158.170.12.118:8743]
              |
              |  HTTPS directo (sin SSH)
              |
[Wazuh Indexer 158.170.12.112:9200]
         OpenSearch con datos reales
         9 agentes, ~19.000 vulnerabilidades
```

El Indexer (OpenSearch) en el puerto 9200 es accesible directamente desde la red del lab. No se requiere túnel SSH porque ambas máquinas están en el mismo segmento de red (`158.170.12.x`).

> **¿Cuándo sería necesario el SSH?**
> Si el puerto 9200 estuviera bloqueado por firewall, o si se accediera desde fuera de la red del lab (internet, VPN, etc.).

---

## ¿Qué es el Wazuh Indexer y por qué usa Basic Auth?

Wazuh internamente almacena todos sus datos (vulnerabilidades, alertas, logs) en **OpenSearch**, una base de datos de búsqueda. Ese componente se llama **Wazuh Indexer** y corre en el puerto `9200`.

| Componente | Puerto | Autenticación | Para qué |
|---|---|---|---|
| Wazuh Indexer (OpenSearch) | 9200 | Basic Auth | Vulnerabilidades, alertas, logs |
| Wazuh Manager API | 55000 | JWT | Gestión: agentes, reglas, versión |

El Indexer usa Basic Auth porque es más simple para queries de lectura masiva. En el lab, el Manager API (55000) no está activo.

---

## ¿Qué es el encoding UTF-8 y por qué importa?

La contraseña del lab contiene `ñ`. Java por defecto codifica las credenciales HTTP en ISO-8859-1, que representa `ñ` de forma diferente a UTF-8. Esto causaba error **401 Unauthorized**.

Solución aplicada en `WazuhIndexerService.java`:
```java
headers.setBasicAuth(indexerUser, indexerPassword, StandardCharsets.UTF_8);
```

Y en `application.properties` el carácter `ñ` se escribe como `ñ` para evitar problemas de lectura del archivo:
```properties
wazuh.indexer.password=usuariocontraseña
```

---

## Flujo completo al llamar `/api/wazuh/info`

```
1. Cliente llama GET http://158.170.12.118:8743/api/wazuh/info

2. WazuhController verifica que el flag de conexión esté activo
   (con ssh.enabled=false, TunnelConfig marca connected=true automáticamente)

3. WazuhController llama a WazuhIndexerService.getClusterInfo()

4. WazuhIndexerService hace 3 llamadas al Indexer:
   a) GET https://158.170.12.112:9200/
      → nombre del cluster, nodo, versión de OpenSearch
   b) GET https://158.170.12.112:9200/_cluster/health
      → estado del cluster (green/yellow/red)
   c) POST https://158.170.12.112:9200/wazuh-states-vulnerabilities-*/_search
      → agrupación por agent.id con conteo de vulnerabilidades

5. WazuhController responde:
   {
     "estado": "CONECTADO",
     "cluster_nombre": "wazuh-cluster",
     "nodo_nombre": "node-1",
     "opensearch_version": "7.10.2",
     "cluster_salud": "yellow",
     "total_vulnerabilidades": 10000,
     "agentes": [
       { "agente_id": "013", "vulnerabilidades": 9545 },
       ...
     ]
   }
```

---

## Flujo completo al llamar `/api/wazuh/vulnerabilities?severity=Critical`

```
1. Cliente llama GET http://158.170.12.118:8743/api/wazuh/vulnerabilities?severity=Critical

2. WazuhIndexerService valida que "Critical" sea un valor permitido
   Valores válidos: Critical, High, Medium, Low

3. WazuhIndexerService construye query OpenSearch:
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

4. POST https://158.170.12.112:9200/wazuh-states-vulnerabilities-*/_search
   Authorization: Basic usuario1:<contraseña en UTF-8>

5. WazuhIndexerService parsea y simplifica la respuesta:
   {
     "total": 842,
     "filtros_aplicados": { "severidad": "Critical", "agente": "todos" },
     "vulnerabilidades": [
       {
         "cve": "CVE-2021-44228",
         "severidad": "Critical",
         "descripcion": "...",
         "paquete": "log4j 2.14.1",
         "agente_id": "013",
         "agente_nombre": "..."
       },
       ...
     ]
   }
```

---

## Componentes del proyecto

### `VulncheckApplication.java`
Punto de entrada. Solo arranca Spring Boot.

### `config/SshTunnel.java`
Código de túnel SSH (no se usa en el lab con `ssh.enabled=false`). Presente para cuando sea necesario acceder desde fuera de la red.

### `config/TunnelConfig.java`
Gestiona el estado de conexión:
- Si `ssh.enabled=false` → marca `connected=true` directamente sin abrir SSH
- Si `ssh.enabled=true` → abre el túnel SSH y marca `connected=true` si tiene éxito
- Expone `isConnected()` para que el controller sepa si puede responder

### `config/RestTemplateConf.java`
Configura el cliente HTTP para aceptar certificados SSL autofirmados. Wazuh usa HTTPS con certificado propio.

### `service/WazuhIndexerService.java`
- `getClusterInfo()` → versión, salud del cluster, agentes y conteo de vulnerabilidades
- `getVulnerabilities(severity, agentId, size)` → busca en `wazuh-states-vulnerabilities-*`
- Construye queries dinámicas según los filtros recibidos
- Valida severidad contra whitelist: `Critical`, `High`, `Medium`, `Low`
- Usa Basic Auth con UTF-8 explícito

### `controller/WazuhController.java`
Expone los endpoints REST:

| Endpoint | Estado | Descripción |
|---|---|---|
| `GET /api/wazuh/info` | ✅ Funciona | Versión, cluster, agentes, total vulnerabilidades |
| `GET /api/wazuh/vulnerabilities` | ✅ Funciona | Vulnerabilidades con filtros opcionales |
| `GET /api/wazuh/status` | ❌ No disponible | Requiere Manager API (puerto 55000, caído en el lab) |

Parámetros de `/vulnerabilities`:
- `?severity=Critical` / `High` / `Medium` / `Low`
- `?agente=013`
- `?size=25` (default 10, máx 100)

---

## URLs de demostración

Con la app corriendo, accesibles desde cualquier PC en la red `158.170.12.x`:

```
http://158.170.12.118:8743/api/wazuh/info
http://158.170.12.118:8743/api/wazuh/vulnerabilities?severity=Critical&size=10
http://158.170.12.118:8743/api/wazuh/vulnerabilities?severity=High&size=20
http://158.170.12.118:8743/api/wazuh/vulnerabilities?agente=013&size=10
```

---

## Cómo levantar la aplicación

```powershell
$env:JAVA_HOME = "C:\Program Files\JetBrains\IntelliJ IDEA 2025.2.4\jbr"
& "C:\Users\brand\.m2\wrapper\dists\apache-maven-3.9.12-bin\5nmfsn99br87k5d4ajlekdq10k\apache-maven-3.9.12\bin\mvn.cmd" `
  -f "C:\Users\brand\Desktop\test\VulnChecker\vulncheck\pom.xml" `
  spring-boot:run
```

---

## Requisitos de la Entrega 1 vs estado actual

| Requisito | Estado | Observación |
|---|---|---|
| Autenticación con API de Wazuh | ✅ | Basic Auth al Indexer con UTF-8 |
| Consumo de endpoint vulnerability detector | ✅ | Datos reales de 9 agentes del lab |
| Persistencia local (PostgreSQL/Redis) | ⏳ | Pendiente |
| Middleware API funcional | ✅ | Endpoints respondiendo con datos reales |

---

## Observaciones

- El **Wazuh Manager API** (puerto 55000) no está activo en el servidor del lab. Los endpoints que dependen de él retornan 503. Esto es una limitación del entorno, no de la implementación.
- El **SSH no es necesario** en el lab porque el puerto 9200 está directamente accesible desde la red `158.170.12.x`.
- Los datos son **reales**: 9 agentes registrados con miles de vulnerabilidades cada uno.
