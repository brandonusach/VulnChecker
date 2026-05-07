# 🛡️ VulnChecker - Gestión de Vulnerabilidades

Sistema integral para la visualización y gestión de vulnerabilidades. Arquitectura desacoplada con Docker para paridad entre desarrollo y producción.

---

## 🏗️ Stack Tecnológico

| Componente   | Tecnología                    |
|-------------|-------------------------------|
| Frontend    | React 19 + Vite 8 + Lucide    |
| Backend     | Java 21 + Spring Boot 4.x     |
| Base de datos | PostgreSQL 16 (Alpine)     |
| Orquestación | Docker + Docker Compose     |
| DevSecOps   | Jenkins, SonarQube, OWASP ZAP, Dependency Check, Grafana, Prometheus |

---

## 🛠️ Modos de Ejecución

### 1️⃣ Modo Desarrollo (Hot Reload ⚡)

Para programar con cambios en caliente.

- **Frontend:** puerto **5173** (Vite)
- **Backend:** puerto **8080** (Spring DevTools)

```bash
docker compose up --build
```

### 2️⃣ Modo Producción 🏗️

Frontend con Nginx, backend con JAR. Sin hot reload.

- **Frontend:** puerto **80**
- **Backend:** puerto **8080**

```bash
docker compose -f docker-compose_prod.yml up --build -d
```

### 3️⃣ Stack completo (App + DevSecOps)

Incluye app, Jenkins, Grafana, Prometheus y SonarQube.

```bash
docker compose up -d
```

| Servicio   | Puerto | URL                     |
|-----------|--------|-------------------------|
| App frontend | 5173 | http://localhost:5173   |
| App backend  | 8080 | http://localhost:8080   |
| Jenkins   | 8081 | http://localhost:8081   |
| Grafana   | 3000 | http://localhost:3000   |
| Prometheus | 9090 | http://localhost:9090   |
| SonarQube | 9000 | http://localhost:9000   |
| OWASP ZAP (API) | 8090 | http://localhost:8090   |
| OWASP Dependency Check | — | Contenedor CLI (`docker exec vuln-dependency-check ...`) |

---

## 🚀 Guía de Inicio Rápido

### Prerrequisitos

- Docker y Docker Compose
- Git

### Variables de entorno

Copia `.env.example` a `.env` en la raíz y ajusta valores (no subas `.env` al repo):

```bash
cp .env.example .env
```

Mínimo: `DB_USERNAME`, `DB_PASSWORD`. Opcional: `GRAFANA_ADMIN_USER`, `GRAFANA_ADMIN_PASSWORD`, `SONAR_DB_PASSWORD`. En producción usa contraseñas fuertes y distintas.

### Acceso

Con el entorno levantado (modo desarrollo o stack completo):

- **App:** http://localhost:5173  
- **API:** http://localhost:8080/api  

### Credenciales de prueba (seed)

| Campo        | Valor          |
|-------------|----------------|
| Usuario     | `admin.seguridad` (dominio @usach.cl se añade automáticamente) |
| Contraseña  | `admin123`     |

---

## 📂 Dockerfiles

Cada servicio tiene dos variantes:

- **`Dockerfile.dev`** — JDK/Node, volúmenes montados, compilación en tiempo real.
- **`Dockerfile`** — Multi-stage: JRE + Nginx, imágenes ligeras para producción.

---

## 🔒 DevSecOps (CI/CD y seguridad)

El pipeline de Jenkins cubre el ciclo DevSecOps con herramientas **100 % gratuitas y open source** (sin licencias ni suscripciones de pago):

| Fase        | Herramienta / práctica |
|------------|-------------------------|
| Secretos   | **Gitleaks** (detección en repo) |
| Build      | Maven, npm |
| Test       | JUnit |
| SAST       | **SonarQube** (Community Edition) |
| SCA        | **OWASP Dependency Check** (backend y frontend) |
| Imágenes   | **Trivy** (vulnerabilidades en imágenes Docker) |
| DAST       | **OWASP ZAP** (escaneo dinámico contra la app) |
| Operate    | **Grafana** + **Prometheus** |

Cobertura del ciclo: **[docs/DEVSECOPS_CICLO.md](docs/DEVSECOPS_CICLO.md)**. Configuración del pipeline y reportes: **[docs/JENKINS_PIPELINE.md](docs/JENKINS_PIPELINE.md)**.

---

## 🔐 Seguridad

- **Redes:** BD de la app en red interna (`app_internal`) sin internet; solo el backend la alcanza. SonarQube y su BD en red aparte; `sonar-db` sin puertos publicados.
- **Contenedores:** `no-new-privileges`, todos los puertos en `127.0.0.1`, tmpfs en `/tmp` donde aplica.
- **App:** Cabeceras de seguridad (X-Frame-Options, CSP, etc.) en backend y frontend (Nginx); backend en producción corre como usuario no root.
- **Credenciales:** `.env` (ver `.env.example`); en producción usar contraseñas fuertes.

Detalle y opciones para TLS/producción: **[docs/SEGURIDAD_RED_CONTENEDORES.md](docs/SEGURIDAD_RED_CONTENEDORES.md)**.

---

## 📋 Comandos útiles

| Acción                  | Comando |
|-------------------------|--------|
| Logs del backend        | `docker logs -f vuln-backend` |
| Reiniciar y borrar DB   | `docker compose down -v` |
| Consola PostgreSQL      | `docker exec -it vuln-db psql -U admin -d vulncheck` |
