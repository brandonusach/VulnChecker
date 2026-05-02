# Cobertura del ciclo DevSecOps

Mapa de las fases típicas del ciclo DevSecOps y lo que cubre este proyecto.

**Sin costos:** todas las herramientas del pipeline y las alternativas sugeridas son **gratuitas y open source** (sin licencias comerciales ni suscripciones).

---

## Herramientas usadas (todas gratuitas)

| Herramienta | Uso | Licencia / modelo |
|-------------|-----|-------------------|
| Jenkins | CI/CD | Open source (MIT) |
| SonarQube | SAST, calidad de código | Community Edition, gratuita |
| OWASP ZAP | DAST | Open source (Apache 2.0) |
| OWASP Dependency Check | SCA (dependencias) | Open source (Apache 2.0) |
| Gitleaks | Detección de secretos | Open source (MIT) |
| Trivy | Escaneo de imágenes Docker | Open source (Apache 2.0) |
| Grafana | Dashboards y métricas | Open source (AGPL) |
| Prometheus | Métricas | Open source (Apache 2.0) |
| PostgreSQL | Bases de datos (app, Sonar) | Open source (PostgreSQL License) |

---

## Fases del ciclo DevSecOps

| Fase | Objetivo | En este proyecto | Herramienta |
|------|----------|------------------|-------------|
| **1. Plan / Diseño** | Modelado de amenazas, requisitos de seguridad | No automatizado en pipeline | Práctica manual (threat modeling, secure design) |
| **2. Desarrollar (Shift Left)** | Código seguro desde el commit | Parcial | SonarQube (reglas de seguridad); **Gitleaks** (secretos en repo) |
| **3. Build** | Build reproducible, sin secretos | ✅ | Maven / npm, build en contenedor |
| **4. Test** | Tests funcionales y de seguridad | ✅ | JUnit, **OWASP Dependency Check** (SCA), **SonarQube** (SAST), **DAST (ZAP)** |
| **5. Artefactos** | Imágenes y binarios seguros | ✅ | **Trivy** (escaneo de imágenes Docker) |
| **6. Release / Deploy** | Despliegue controlado y aprobado | Parcial | Pipeline despliega solo para DAST; no hay staging/prod automático con gates |
| **7. Operate / Monitor** | Visibilidad y respuesta | ✅ | **Grafana** + **Prometheus** (métricas), Actuator |

---

## Lo que está cubierto

- **SAST (estático):** SonarQube en el backend (código, bugs, vulnerabilidades, code smells).
- **SCA (dependencias):** OWASP Dependency Check en backend (Maven) y frontend (npm).
- **DAST (dinámico):** OWASP ZAP contra la app desplegada (backend).
- **Escaneo de secretos:** Gitleaks sobre el repositorio (claves, tokens, credenciales).
- **Escaneo de imágenes:** Trivy sobre las imágenes Docker del backend y frontend.
- **Tests:** JUnit, publicación de resultados.
- **Calidad:** Quality Gate de SonarQube (opcional).
- **Observabilidad:** Prometheus + Grafana, Actuator con métricas.

---

## Lo que falta (opcional o manual)

| Elemento | Descripción | Cómo añadirlo (herramientas gratuitas) |
|----------|-------------|----------------------------------------|
| **Threat modeling** | Diseño seguro al inicio | OWASP Threat Dragon (open source) o proceso manual |
| **SAST en frontend** | Análisis estático del código JS/TS | SonarQube para frontend, Semgrep (open source) o `npm audit` en el pipeline |
| **SBOM** | Software Bill of Materials (CycloneDX/SPDX) | Trivy o Dependency Check pueden generar SBOM (incluidos en el stack actual) |
| **Security gates estrictos** | Fallar build en críticos/altos | Configurar `failOnCVSS` en Dependency Check y `--exit-code 1` en Trivy/ZAP según política |
| **Deploy a staging/prod** | CD con aprobación y despliegue real | Añadir stage de deploy (K8s, servidor, etc.) con aprobación; sin herramientas de pago |
| **RASP / WAF** | Protección en tiempo de ejecución | ModSecurity (open source), WAF open source o de tu proveedor cloud |
| **Escaneo de IaC** | Si usas Terraform/K8s | Checkov, tfsec, KICS (todos open source; no aplicable si solo usas Docker Compose) |

---

## Resumen

El pipeline cubre **build, test, SAST, SCA, escaneo de secretos, escaneo de imágenes, DAST y observabilidad**. Quedan fuera del pipeline automatizado: **planificación/diseño seguro**, **SBOM explícito** (salvo lo que ya dan Trivy/Dependency Check), **deploy a entornos reales** y **RASP/WAF**. Puedes ir añadiendo gates más estrictos y etapas de despliegue según tu política de seguridad.
