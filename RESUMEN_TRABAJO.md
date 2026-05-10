# Resumen completo — VulnChecker Entrega 1

## Resultado final

La aplicación conecta directamente al servidor Wazuh del lab (`158.170.12.112:9200`) sin necesidad de túnel SSH, retorna datos reales de vulnerabilidades y es accesible desde cualquier PC en la red del lab.

---

## Problemas encontrados y resueltos

### 1. SSH no era necesario
**Situación:** El proyecto estaba diseñado para conectarse via túnel SSH al Indexer.
**Descubrimiento:** El puerto 9200 del servidor es accesible directamente desde la red del lab.
**Solución:** `wazuh.ssh.enabled=false` en `application.properties`. Con esto, `TunnelConfig` marca `connected=true` sin abrir SSH y la URL apunta directo a `158.170.12.112:9200`.

### 2. Error 401 por encoding de contraseña
**Problema:** La contraseña `usuariocontraseña` contiene `ñ`. Java codifica las credenciales HTTP en ISO-8859-1 por defecto, lo que hace que `ñ` llegue distinto al servidor.
**Solución:** Pasar el charset explícitamente:
```java
headers.setBasicAuth(indexerUser, indexerPassword, StandardCharsets.UTF_8);
```
Y en `application.properties` escribir `ñ` como `ñ` (Unicode escape).

### 3. Manager API no disponible
**Situación:** El puerto 55000 (Wazuh Manager API) no está activo en el servidor del lab.
**Consecuencia:** Los endpoints `/api/wazuh/status` y `/api/wazuh/auth` retornan 503.
**Decisión:** No es solucionable desde el cliente. Se documentó como limitación del entorno.

### 4. Java 21 requerido
**Problema:** El proyecto requiere Java 21 pero el sistema tiene Java 17.
**Solución:** Usar el JBR de IntelliJ IDEA:
```powershell
$env:JAVA_HOME = "C:\Program Files\JetBrains\IntelliJ IDEA 2025.2.4\jbr"
```

---

## Archivos modificados

### `application.properties`
Credenciales y configuración del lab:
```properties
wazuh.ssh.enabled=false
wazuh.indexer.remote-host=158.170.12.112
wazuh.indexer.remote-port=9200
wazuh.indexer.user=usuario1
wazuh.indexer.password=usuariocontraseña
```

### `WazuhIndexerService.java`
- Agregado soporte para conexión directa (sin SSH) según el flag `ssh.enabled`
- Corregido encoding UTF-8 en Basic Auth
- Agregado método `getClusterInfo()` para el nuevo endpoint `/api/wazuh/info`

### `WazuhController.java`
- Agregado endpoint `GET /api/wazuh/info`

---

## Endpoints disponibles

| Endpoint | Descripción |
|---|---|
| `GET /api/wazuh/info` | Versión OpenSearch, cluster, agentes con conteo de vulnerabilidades |
| `GET /api/wazuh/vulnerabilities` | Lista de vulnerabilidades con filtros opcionales |

Parámetros de `/vulnerabilities`:
- `?severity=Critical` / `High` / `Medium` / `Low`
- `?agente=013`
- `?size=25` (default 10, máx 100)

---

## Datos reales obtenidos del lab

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

## Acceso desde otras PCs del lab

La app es accesible desde cualquier PC en la red `158.170.12.x` (firewall abierto en puerto 8743):

```
http://158.170.12.118:8743/api/wazuh/info
http://158.170.12.118:8743/api/wazuh/vulnerabilities?severity=Critical&size=10
```

---

## Estado de requisitos Entrega 1

| Requisito | Estado | Observación |
|---|---|---|
| Autenticación con API de Wazuh | ✅ | Basic Auth al Indexer |
| Consumo de endpoint vulnerability detector | ✅ | Datos reales del lab |
| Persistencia local (PostgreSQL/Redis) | ⏳ | Pendiente |
| Middleware API funcional | ✅ | Funciona y es accesible en la red |
