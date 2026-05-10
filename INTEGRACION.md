# Entrega 1 — Capa de Integración VulnChecker

## Objetivo

Conectar la aplicación Spring Boot al servidor Wazuh del laboratorio (`158.170.12.112`) y consumir datos reales de vulnerabilidades.

---

## Entorno

| Componente | Valor |
|---|---|
| PC alumno | `158.170.12.118` |
| Servidor Wazuh (lab) | `158.170.12.112` |
| Wazuh Indexer (OpenSearch) | `158.170.12.112:9200` |
| Wazuh Manager API | `158.170.12.112:55000` (caído en el lab) |
| Wazuh Dashboard | `https://158.170.12.112` |
| Aplicación Spring Boot | `http://158.170.12.118:8080` |

---

## Qué se hizo

### 1. Configuración de conexión directa (sin SSH)

Se determinó que el puerto 9200 del Indexer es accesible directamente desde la red del lab, por lo que el túnel SSH **no es necesario**.

En `application.properties`:
```properties
wazuh.ssh.enabled=false
wazuh.indexer.remote-host=158.170.12.112
wazuh.indexer.remote-port=9200
wazuh.indexer.user=usuario1
wazuh.indexer.password=usuariocontraseña
```

El caracter `ñ` se codifica como `ñ` para evitar problemas de encoding en el archivo `.properties`.

### 2. Fix de encoding UTF-8 en autenticación HTTP

Java por defecto codifica las credenciales en ISO-8859-1. Esto causaba error 401 porque la contraseña contiene `ñ`. Se corrigió pasando el charset explícitamente:

```java
headers.setBasicAuth(indexerUser, indexerPassword, StandardCharsets.UTF_8);
```

### 3. RestTemplate con SSL desactivado

El Indexer usa HTTPS con certificado autofirmado. Se configuró un `RestTemplate` que acepta cualquier certificado para el entorno de lab.

### 4. Servicio WazuhIndexerService

Implementa tres operaciones contra el Indexer:

- **`getVulnerabilities(severity, agentId, size)`** — consulta vulnerabilidades con filtros opcionales por severidad y agente
- **`getClusterInfo()`** — obtiene versión de OpenSearch, salud del cluster, total de vulnerabilidades y conteo por agente

### 5. Endpoints disponibles

| Endpoint | Descripción |
|---|---|
| `GET /api/wazuh/info` | Versión, cluster, agentes y total de vulnerabilidades |
| `GET /api/wazuh/vulnerabilities` | Lista de vulnerabilidades con filtros opcionales |

#### Parámetros de `/api/wazuh/vulnerabilities`

| Parámetro | Valores | Ejemplo |
|---|---|---|
| `severity` | `Critical`, `High`, `Medium`, `Low` | `?severity=Critical` |
| `agente` | ID del agente | `?agente=013` |
| `size` | número (máx 100) | `?size=20` |

### 6. Apertura de firewall para acceso externo

```powershell
netsh advfirewall firewall add rule name="VulnChecker" dir=in action=allow protocol=TCP localport=8080
```

Permite que el docente u otros equipos en la red `158.170.12.x` accedan a la aplicación.

---

## Resultados obtenidos

Datos reales del Wazuh del lab verificados en `http://localhost:8743/api/wazuh/info`:

```json
{
  "estado": "CONECTADO",
  "cluster_nombre": "wazuh-cluster",
  "nodo_nombre": "node-1",
  "opensearch_version": "7.10.2",
  "cluster_salud": "yellow",
  "total_vulnerabilidades": 10000,
  "agentes": [
    { "agente_id": "013", "vulnerabilidades": 9545 },
    { "agente_id": "017", "vulnerabilidades": 4262 },
    { "agente_id": "016", "vulnerabilidades": 3836 },
    { "agente_id": "018", "vulnerabilidades": 1879 },
    { "agente_id": "011", "vulnerabilidades": 3 },
    { "agente_id": "009", "vulnerabilidades": 2 },
    { "agente_id": "010", "vulnerabilidades": 2 },
    { "agente_id": "012", "vulnerabilidades": 2 },
    { "agente_id": "006", "vulnerabilidades": 1 }
  ]
}
```

---

## URLs de demostración

Con la app corriendo, accesibles desde cualquier PC en la red del lab:

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

## Observaciones

- El **Wazuh Manager API** (puerto 55000) no está activo en el servidor del lab. Los endpoints `/api/wazuh/status` y `/api/wazuh/auth` (que dependen de él) retornan 503. Esto es una limitación del entorno, no de la implementación.
- La autenticación implementada es **Basic Auth** contra el Indexer. El JWT del Manager API no es obtenible mientras el servicio esté caído.
- El SSH **no es necesario** porque el puerto 9200 está directamente accesible desde la red del lab (`158.170.12.x`).

---

## Requisitos de la Entrega 1 vs Estado actual

| Requisito | Estado | Observación |
|---|---|---|
| Autenticación con API de Wazuh | ✅ | Basic Auth al Indexer funcionando |
| Consumo de endpoint vulnerability detector | ✅ | Datos reales de 9 agentes |
| Persistencia local (PostgreSQL/Redis) | ⏳ | Pendiente para completar la entrega |
| Middleware API funcional | ✅ | Endpoints respondiendo con datos reales |
