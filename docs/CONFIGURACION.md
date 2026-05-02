# Guía de configuraciones – VulnChecker DevSecOps

Este documento recopila **todas las configuraciones** necesarias para poner en marcha el proyecto: variables de entorno, Jenkins (job, credenciales, SonarQube), Docker y primeros accesos.

---

## 1. Variables de entorno (`.env`)

**Ubicación:** raíz del proyecto (donde está `docker-compose.yml`).

**Pasos:**

1. Copiar el ejemplo:
   ```bash
   cp .env.example .env
   ```
2. Editar `.env` y ajustar valores. **No subir `.env` al repositorio.**

### Variables mínimas

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `DB_USERNAME` | Usuario de PostgreSQL (app) | `admin` |
| `DB_PASSWORD` | Contraseña de PostgreSQL (app) | Contraseña fuerte |

### Variables opcionales

| Variable | Descripción | Por defecto |
|----------|-------------|-------------|
| `GRAFANA_ADMIN_USER` | Usuario admin de Grafana | `admin` |
| `GRAFANA_ADMIN_PASSWORD` | Contraseña admin de Grafana | `admin` |
| `SONAR_DB_PASSWORD` | Contraseña de la BD de SonarQube | `sonar` |
| `NVD_API_KEY` | API key de NVD (evita 429 en Dependency Check) | — |
| `GF_COOKIE_SECURE` | Grafana tras HTTPS | `false` |
| `GF_HSTS` | HSTS en Grafana | `false` |

**NVD_API_KEY:** Obtener en [nvd.nist.gov/developers/request-an-api-key](https://nvd.nist.gov/developers/request-an-api-key). Si se define en `.env`, el pipeline la usa cuando no se pasa por parámetro en el job.

En producción usa contraseñas fuertes y distintas para cada sistema.

---

## 2. Configuración del job en Jenkins

### Definición del Pipeline

- **Manage Jenkins** → **Jobs** → tu job (o crear uno) → **Configure**.
- En **Pipeline**:
  - **Definition:** **Pipeline script from SCM**.
  - **SCM:** Git.
  - **Repository URL:** URL del repositorio (HTTPS o SSH).
  - **Credentials:** Las que uses para clonar (usuario/contraseña o clave SSH).
  - **Branch:** p. ej. `*/main` o `*/master`.
  - **Script Path:** `Jenkinsfile`.

Si no usas "Pipeline script from SCM", tendrás que tener el código en el workspace por otro medio y usar el parámetro **SKIP_CHECKOUT=true** al ejecutar.

### Parámetros del job (Build with Parameters)

| Parámetro | Valores | Cuándo usar |
|-----------|---------|-------------|
| **SKIP_SONAR** | false / true | `true` si SonarQube no está configurado o no está levantado. |
| **SKIP_QUALITY_GATE** | false / true | `true` para no ejecutar el stage Quality Gate. Si es `false`, se espera max 5 min; si no termina, el pipeline sigue y el análisis sigue en SonarQube (background task). |
| **SONAR_SERVER_NAME** | texto (default: SonarQube) | Nombre exacto de la instalación en Jenkins (System → SonarQube servers). Si falla "does not match", pon aquí el nombre que ves. |
| **SKIP_CHECKOUT** | false / true | `true` solo si el job no es "from SCM" y el workspace ya tiene el repo. |
| **SKIP_JUNIT** | false / true | `true` para omitir tests unitarios. |
| **SKIP_DEPENDENCY_CHECK** | false / true | `true` para omitir OWASP Dependency Check (ahorra tiempo la primera vez). |
| **SKIP_ZAP** | false / true | `true` para omitir DAST (ZAP) y el despliegue de la app para el escaneo. |
| **NVD_API_KEY** | (password, opcional) | API key de NVD; alternativa a la credencial o a `.env`. |

---

## 3. Credenciales en Jenkins

**Manage Jenkins** → **Credentials** → **System** → **Global credentials** (o el dominio que use tu job) → **Add Credentials**.

### 3.1 Token de SonarQube (obligatorio si usas SonarQube)

| Campo | Valor |
|-------|--------|
| **Kind** | Secret text |
| **Scope** | Global (o el que use el job) |
| **Secret** | Token generado en SonarQube (My Account → Security → Generate Token) |
| **ID** | `sonarqube-token` **(exacto)** |
| **Description** | Opcional, p. ej. "Token SonarQube" |

Si el ID no es exactamente `sonarqube-token`, el pipeline no encontrará el token.

### 3.2 API key de NVD (recomendado para Dependency Check)

**Opción A – Secret file (recomendada si la key no llega al contenedor):**

En algunos entornos Jenkins la variable de tipo "Secret text" no se pasa bien al proceso `docker`. Usa **Secret file**:

| Campo | Valor |
|-------|--------|
| **Kind** | **Secret file** |
| **Scope** | Global (o el que use el job) |
| **File** | Archivo que contenga **solo** la API key (una línea, sin espacios). Crear p. ej. `nvd-key.txt` con el contenido de [nvd.nist.gov/developers/request-an-api-key](https://nvd.nist.gov/developers/request-an-api-key). |
| **ID** | `nvd-api-key-file` **(exacto)** |
| **Description** | Opcional, p. ej. "NVD API Key (file)" |

**Opción B – Secret text:**

| Campo | Valor |
|-------|--------|
| **Kind** | Secret text |
| **Scope** | Global (o el que use el job) |
| **Secret** | API key de [NVD](https://nvd.nist.gov/developers/request-an-api-key) |
| **ID** | `nvd-api-key` **(exacto, minúsculas)** |
| **Description** | Opcional, p. ej. "NVD API Key" |

El pipeline prueba primero la credencial **file** (`nvd-api-key-file`) y, si no existe, la **text** (`nvd-api-key`). Sin ninguna de las dos (ni `NVD_API_KEY` en `.env` ni en el parámetro del job), OWASP Dependency Check puede tardar mucho o recibir 429 (rate limit).

### 3.3 Credenciales para Git (si el job clona por SSH o HTTPS con usuario/contraseña)

- **SSH:** Kind = **SSH Username with private key**; configurar la clave según [JENKINS_SSH_GITHUB.md](JENKINS_SSH_GITHUB.md).
- **HTTPS:** Kind = **Username with password**; usuario y contraseña (o token) del repositorio.

---

## 4. Servidor SonarQube en Jenkins

Necesario para que **waitForQualityGate** encuentre el análisis (y para `withSonarQubeEnv`).

**Manage Jenkins** → **System** → bajar a **SonarQube servers** → **Add SonarQube**:

| Campo | Valor |
|-------|--------|
| **Name** | Cualquier nombre (ej. `SonarQube`). Debe coincidir con el parámetro **SONAR_SERVER_NAME** del job (por defecto `SonarQube`). Si falla "does not match any configured installation", pon en el job el mismo nombre que ves aquí. |
| **Server URL** | URL de SonarQube. Si corre en Docker en la misma red: `http://sonarqube:9000` |
| **Server authentication token** | Opcional si ya usas la credencial `sonarqube-token` en el pipeline; se puede dejar en blanco y usar solo la credencial. |

Si en "Name" pones otro valor (p. ej. "Mi Sonar"), en el `Jenkinsfile` debes cambiar:

```groovy
withSonarQubeEnv('SonarQube')  // → withSonarQubeEnv('Mi Sonar')
```

---

## 5. Plugins de Jenkins recomendados

**Manage Jenkins** → **Plugins** → **Available**:

| Plugin | Uso |
|--------|-----|
| **Pipeline** | Pipeline as Code. |
| **JUnit** | Publicar resultados de tests. |
| **Docker Pipeline** | Opcional, si usas steps Docker en el pipeline. |
| **SonarQube Scanner for Jenkins** | `waitForQualityGate` y `withSonarQubeEnv`. Sin él, el stage "Quality Gate" falla. |
| **Pipeline: SonarQube** | Integración SonarQube en pipelines. |

Tras instalar, reiniciar Jenkins si se indica.

---

## 6. Docker y Docker Compose

### Requisitos

- Docker y Docker Compose instalados.
- Si Jenkins corre en Docker, el socket de Docker debe estar montado en el contenedor (p. ej. `-v /var/run/docker.sock:/var/run/docker.sock`) y el workspace del job debe ser accesible por el daemon (p. ej. volumen de `jenkins_home` desde el host).

### Levantar el stack

Desde la raíz del proyecto (donde está `docker-compose.yml` y `.env`):

```bash
docker compose up -d
```

Para levantar solo servicios concretos (p. ej. BD, backend, frontend, Jenkins, SonarQube):

```bash
docker compose up -d db backend frontend jenkins sonarqube sonar-db
```

### Volumen de reportes de Jenkins

El pipeline copia reportes a `./jenkins-reports/latest`. Eso requiere que el contenedor Jenkins tenga montado:

- `./jenkins-reports:/jenkins-reports`

Si la carpeta no aparece o está vacía, recrear el contenedor Jenkins:

```bash
docker compose up -d jenkins --force-recreate
```

O crear la carpeta a mano y volver a levantar Jenkins:

```bash
mkdir -p jenkins-reports
docker compose up -d jenkins
```

### Redes

- Jenkins está en `devsecops_net` y en `sonarnet` para alcanzar SonarQube y la app.
- La app (backend/frontend) y ZAP usan la red `vulnchecker_devsecops` (nombre interno `vulnchecker_devsecops`).

---

## 7. Primer acceso a SonarQube

1. Abrir **http://localhost:9000** (o la URL donde esté publicado SonarQube).
2. Primer inicio: login por defecto `admin` / `admin`; SonarQube pedirá cambiar la contraseña.
3. Después de iniciar sesión: **My Account** → **Security** → **Generate Token** → crear un token (p. ej. "jenkins") y **copiarlo**.
4. Ese token es el que se guarda en la credencial **sonarqube-token** en Jenkins (ver sección 3.1).

---

## 8. Primer acceso a Jenkins

1. Abrir **http://localhost:8081** (puerto definido en `docker-compose.yml`).
2. Contraseña inicial del usuario `admin`: ver logs del contenedor:
   ```bash
   docker logs vuln-jenkins
   ```
   Buscar la línea con "Unlock" y la contraseña.
3. Completar el asistente de configuración inicial e instalar los plugins recomendados (sección 5).

---

## 9. Primer acceso a Grafana

1. Abrir **http://localhost:3000**.
2. Usuario y contraseña por defecto (si no se cambiaron en `.env`): `admin` / `admin` (o los definidos en `GRAFANA_ADMIN_USER` y `GRAFANA_ADMIN_PASSWORD`).
3. Prometheus suele estar ya configurado como datasource (provisioning en `grafana/provisioning`).

---

## 10. Puertos y URLs de referencia

| Servicio | Puerto (host) | URL (desde el host) |
|---------|----------------|---------------------|
| App frontend | 5173 | http://localhost:5173 |
| App backend | 8080 | http://localhost:8080 |
| Jenkins | 8081 | http://localhost:8081 |
| Grafana | 3000 | http://localhost:3000 |
| Prometheus | 9090 | http://localhost:9090 |
| SonarQube | 9000 | http://localhost:9000 |
| OWASP ZAP (API) | 8090 | http://localhost:8090 |

Todos los puertos están publicados en `127.0.0.1` (solo acceso desde la máquina local).

---

## 11. Resumen rápido de comprobación

Antes de ejecutar el pipeline, verificar:

- [ ] `.env` creado y con al menos `DB_USERNAME` y `DB_PASSWORD`.
- [ ] Job configurado como **Pipeline script from SCM** con **Script Path: `Jenkinsfile`**.
- [ ] Credencial **sonarqube-token** (Secret text) en Jenkins si no usas SKIP_SONAR.
- [ ] En **SonarQube servers**, un servidor con **Name** igual al parámetro **SONAR_SERVER_NAME** del job (por defecto `SonarQube`) y URL correcta (p. ej. `http://sonarqube:9000`).
- [ ] Credencial **nvd-api-key** (Secret text) en Jenkins recomendada para Dependency Check.
- [ ] Plugin **SonarQube Scanner for Jenkins** instalado si no usas SKIP_SONAR.
- [ ] Docker y Docker Compose funcionando; Jenkins con acceso al daemon Docker.
- [ ] SonarQube levantado y token generado (si usas SonarQube).
- [ ] Carpeta `jenkins-reports` existente o volumen montado en Jenkins para ver reportes en `./jenkins-reports/latest`.

Más detalle del pipeline y reportes: **[JENKINS_PIPELINE.md](JENKINS_PIPELINE.md)**.
