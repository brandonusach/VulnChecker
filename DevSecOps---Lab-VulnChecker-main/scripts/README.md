# Scripts del proyecto

## Leer reportes Trivy (JSON largos)

Los JSON de Trivy (`trivy-backend.json`, `trivy-frontend.json`) son muy grandes. Puedes leerlos así:

### Opción 1: Script de resumen (recomendado)

Genera un resumen en Markdown (por consola y opcionalmente en archivo):

```bash
# Resumen por consola
node scripts/trivy-summary.js jenkins-reports/latest/trivy/trivy-backend.json

# Resumen de backend y frontend y guardar en archivo
node scripts/trivy-summary.js --out reports/trivy-resumen.md jenkins-reports/latest/trivy/trivy-backend.json jenkins-reports/latest/trivy/trivy-frontend.json
```

Verás tablas por severidad (CRITICAL, HIGH, MEDIUM, LOW) y una tabla de cada vulnerabilidad con CVE, paquete, versión instalada, versión corregida y título.

### Opción 2: Consultas con jq

Si tienes [jq](https://jqlang.github.io/jq/) instalado:

```bash
# Contar vulnerabilidades por severidad (backend)
jq -r '[.Results[].Vulnerabilities[]?.Severity] | group_by(.) | map({severity: .[0], count: length}) | .[] | "\(.severity): \(.count)"' jenkins-reports/latest/trivy/trivy-backend.json

# Listar solo CRITICAL y HIGH
jq -r '.Results[].Vulnerabilities[]? | select(.Severity == "CRITICAL" or .Severity == "HIGH") | "\(.Severity)\t\(.VulnerabilityID)\t\(.PkgName)\t\(.Title // .Description | .[0:60])"' jenkins-reports/latest/trivy/trivy-backend.json

# Solo IDs de CVE
jq -r '.Results[].Vulnerabilities[]? | .VulnerabilityID' jenkins-reports/latest/trivy/trivy-backend.json | sort -u
```

### Opción 3: Reporte en tabla/HTML desde el pipeline

Trivy puede generar salida en tabla o HTML. En el Jenkinsfile ya se guarda JSON; si quieres también un reporte legible automático, se puede añadir una línea que ejecute `trivy image --format table` y redirija a un `.txt`, o usar la plantilla HTML de Trivy y guardar un `.html` en `reports/trivy/`.
