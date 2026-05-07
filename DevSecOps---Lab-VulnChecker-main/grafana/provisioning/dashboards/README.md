# Dashboards Grafana

- **default/**: carpeta que Grafana carga al arrancar (vacía para evitar errores de provisioning). Para cargar el dashboard de VulnChecker, copia aquí `vulnchecker-backend.json` y reinicia Grafana.
- **vulnchecker-backend.json**: dashboard de métricas (backend + Prometheus). Puedes importarlo a mano en Grafana: **Dashboards** → **New** → **Import** → **Upload JSON file** y selecciona este archivo.
