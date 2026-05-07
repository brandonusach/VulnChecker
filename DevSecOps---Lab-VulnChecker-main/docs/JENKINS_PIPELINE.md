# Pipeline Jenkins y reportes

## Requisitos

- **Git/SSH:** Para "Pipeline script from SCM" con GitHub por SSH, sigue **[JENKINS_SSH_GITHUB.md](JENKINS_SSH_GITHUB.md)** (generar clave, GitHub, credencial en Jenkins, configurar el job).
- Jenkins con acceso a Docker (socket montado). Si Jenkins corre en Docker, el directorio de trabajo del job debe ser accesible por el daemon (p. ej. montar `jenkins_home` desde el host) para que `docker compose build` y `docker compose up` usen el código correcto.
- **Configuración del job:** debe ser **"Pipeline script from SCM"**: en la definición del Pipeline elige *Pipeline script from SCM*, indica el repositorio Git (donde está este proyecto) y **Script Path: `Jenkinsfile`**. Así Jenkins clona el repo y ejecuta el Jenkinsfile. Si no puedes usar SCM, deja el código en el workspace por otro medio y ejecuta con el parámetro **SKIP_CHECKOUT=true**.
- Plugins recomendados: **Pipeline**, **JUnit**, **Docker Pipeline** (opcional). Los reportes HTML se archivan como artefactos; no hace falta el plugin HTML Publisher. Para SonarQube: **SonarQube Scanner** y **Pipeline: SonarQube**.
- **SonarQube (si no usas SKIP_SONAR):** Servidor accesible en `http://sonarqube:9000` (desde el agente Jenkins). SonarQube 9+ exige autenticación por token: en SonarQube ve a *My Account > Security > Generate Token*, crea un token y en Jenkins añade una credencial **Secret text** con **ID exacto `sonarqube-token`** y el token como valor. Si no tienes SonarQube o el token, usa **SKIP_SONAR=true**.

## Parámetros del job

| Parámetro   | Valores | Descripción |
|-------------|---------|-------------|
| **SKIP_SONAR** | false / true | En `true` se omiten los stages SonarQube Analysis y Quality Gate (útil si SonarQube no está configurado o no está arriba). |
| **SKIP_JUNIT** | false / true | En `true` se omite el stage Unit Tests (JUnit). |
| **SKIP_DEPENDENCY_CHECK** | false / true | En `true` se omite OWASP Dependency Check (la primera ejecución puede tardar 30–60 min por la descarga NVD). |
| **SKIP_ZAP** | false / true | En `true` se omiten el despliegue para DAST y el escaneo OWASP ZAP. |
| **NVD_API_KEY** | (password, opcional) | API key de [NVD](https://nvd.nist.gov/developers/request-an-api-key) para evitar error 429 (rate limit). Sin key la descarga NVD puede fallar o tardar mucho. |

## Dónde se generan los reportes

- **En Jenkins (workspace):** `reports/` dentro del job.
- **En tu máquina (carpeta del proyecto):** al final de cada ejecución se copian a **`./jenkins-reports/latest/`** (misma carpeta donde está el `docker-compose.yml`). Ahí tienes siempre la última ejecución sin entrar al contenedor.

Detalle por herramienta (rutas dentro de `reports/` o `jenkins-reports/latest/`):

| Herramienta           | Ubicación | Publicación en Jenkins |
|-----------------------|-----------|-------------------------|
| Gitleaks              | `reports/gitleaks-report.json` | Artefacto archivado |
| Dependency Check (backend)  | `reports/dependency-check-backend/dependency-check-report.html` | Artefacto archivado |
| Dependency Check (frontend) | `reports/dependency-check-frontend/dependency-check-report.html` | Artefacto archivado |
| Trivy (backend/frontend)   | `reports/trivy/trivy-backend.json`, `trivy-frontend.json` | Artefactos archivados |
| OWASP ZAP             | `reports/zap/zap-report.html`, `zap-report.json` | Artefactos archivados |
| JUnit (tests)         | `vulncheckerbackend/target/surefire-reports/*.xml` | Resultados de tests (JUnit) |
| SonarQube             | En el servidor SonarQube (http://localhost:9000) | Quality Gate en el pipeline |

## Configuraciones que deben coincidir

- **Red Docker:** El compose usa `name: vulnchecker`, por eso las imágenes se llaman `vulnchecker-backend` y `vulnchecker-frontend`. Jenkins está en `devsecops_net` y en `sonarnet` para poder alcanzar SonarQube.
- **Workspace:** Los comandos `docker compose` se ejecutan desde `${WORKSPACE}` para que los contextos de build (p. ej. `./vulncheckerbackend`) se resuelvan bien.
- **DAST:** ZAP usa la red `vulnchecker_devsecops` para alcanzar `http://backend:8080` una vez levantados db, backend y frontend.

## Si la carpeta `jenkins-reports` no se crea o está vacía

La carpeta **`./jenkins-reports`** (y dentro **`latest/`**) está montada en el contenedor Jenkins con el volumen `./jenkins-reports:/jenkins-reports`. Si no ves la carpeta en tu proyecto:

1. **Recrear el contenedor Jenkins** para que monte el volumen (si Jenkins se levantó antes de añadir este volumen, no lo tendrá):
   ```bash
   docker compose up -d jenkins --force-recreate
   ```
2. **Crear la carpeta a mano** en la raíz del proyecto (donde está `docker-compose.yml`), por si el volumen no la crea en tu entorno:
   ```bash
   mkdir jenkins-reports
   ```
   Luego vuelve a levantar Jenkins si hace falta: `docker compose up -d jenkins`.
3. **Ejecutar el pipeline:** En el stage **"Prepare reports dirs"** se ejecuta `mkdir -p /jenkins-reports/latest` dentro del contenedor; con el volumen montado deberías ver `jenkins-reports/latest` en tu proyecto. Los **archivos** (HTML, JSON, etc.) se copian ahí en el **post** del pipeline (al terminar o fallar la ejecución). Si el job se aborta antes del post, `latest` puede existir pero vacía.

Comprueba que estás mirando la carpeta en la **misma ruta** desde la que ejecutas `docker compose` (por ejemplo `Escritorio\DevSecOps\vulnchecker`).

## Si un reporte no aparece

1. **Dependency Check:** La primera ejecución puede tardar mucho (descarga NVD). El HTML se llama `dependency-check-report.html` en el directorio de salida.
2. **ZAP:** Comprueba que el stage "Deploy App (for DAST)" haya terminado y que el backend responda (logs del stage). El backend tarda en arrancar (Maven + Spring); hay ~60 s de espera inicial y hasta 2 min de reintentos.
3. **SonarQube:** Si falla "SonarQube Analysis", configura el servidor SonarQube en Jenkins o ejecuta con **SKIP_SONAR=true**.
4. **JUnit:** Asegúrate de que Maven genera `target/surefire-reports/*.xml` (por defecto con `mvn test`).
