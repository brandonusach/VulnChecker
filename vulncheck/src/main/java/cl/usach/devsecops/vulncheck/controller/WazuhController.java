package cl.usach.devsecops.vulncheck.controller;

import cl.usach.devsecops.vulncheck.config.TunnelConfig;
import cl.usach.devsecops.vulncheck.service.WazuhAuthService;
import cl.usach.devsecops.vulncheck.service.WazuhIndexerService;
import cl.usach.devsecops.vulncheck.service.WazuhManagerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/wazuh")
public class WazuhController {

    private final WazuhManagerService managerService;
    private final WazuhIndexerService indexerService;
    private final WazuhAuthService authService;
    private final TunnelConfig tunnelConfig;

    public WazuhController(WazuhManagerService managerService,
                           WazuhIndexerService indexerService,
                           WazuhAuthService authService,
                           TunnelConfig tunnelConfig) {
        this.managerService = managerService;
        this.indexerService = indexerService;
        this.authService = authService;
        this.tunnelConfig = tunnelConfig;
    }

    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> status() {
        if (!tunnelConfig.isConnected()) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "DESCONECTADO");
            error.put("mensaje", "Tunel SSH no disponible — verificar conexion con Wazuh");
            return ResponseEntity.status(503).body(error);
        }

        try {
            Map<String, Object> info = managerService.getManagerInfo();
            List<Map<String, Object>> agents = managerService.getAgents();

            Map<String, Object> response = new LinkedHashMap<>();
            response.put("estado", "CONECTADO");
            response.put("wazuh_version", info.get("version"));
            response.put("wazuh_ip", managerService.getWazuhIp());
            response.put("total_agentes", agents.size());
            response.put("agentes", agents.stream()
                    .map(a -> {
                        Map<String, Object> agent = new LinkedHashMap<>();
                        agent.put("id", a.get("id"));
                        agent.put("nombre", a.get("name"));
                        agent.put("ip", a.getOrDefault("ip", "N/A"));
                        agent.put("estado", a.get("status"));
                        agent.put("version", a.getOrDefault("version", "N/A"));
                        return agent;
                    })
                    .collect(Collectors.toList()));

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "ERROR");
            error.put("mensaje", e.getMessage());
            return ResponseEntity.status(503).body(error);
        }
    }

    @GetMapping("/auth")
    public ResponseEntity<Map<String, Object>> auth() {
        if (!tunnelConfig.isConnected()) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "DESCONECTADO");
            error.put("mensaje", "Tunel SSH no disponible");
            return ResponseEntity.status(503).body(error);
        }
        try {
            return ResponseEntity.ok(indexerService.authenticate());
        } catch (Exception e) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "ERROR");
            error.put("mensaje", e.getMessage());
            return ResponseEntity.status(503).body(error);
        }
    }

    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> info() {
        if (!tunnelConfig.isConnected()) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "DESCONECTADO");
            error.put("mensaje", "Tunel SSH no disponible — verificar conexion con Wazuh");
            return ResponseEntity.status(503).body(error);
        }
        try {
            return ResponseEntity.ok(indexerService.getClusterInfo());
        } catch (Exception e) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "ERROR");
            error.put("mensaje", e.getMessage());
            return ResponseEntity.status(503).body(error);
        }
    }

    @GetMapping("/vulnerabilities")
    public ResponseEntity<Map<String, Object>> vulnerabilities(
            @RequestParam(required = false) String severity,
            @RequestParam(required = false) String agente,
            @RequestParam(defaultValue = "10") int size) {

        if (!tunnelConfig.isConnected()) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "DESCONECTADO");
            error.put("mensaje", "Tunel SSH no disponible — verificar conexion con Wazuh");
            return ResponseEntity.status(503).body(error);
        }

        try {
            return ResponseEntity.ok(indexerService.getVulnerabilities(severity, agente, size));
        } catch (IllegalArgumentException e) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "ERROR");
            error.put("mensaje", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        } catch (Exception e) {
            Map<String, Object> error = new LinkedHashMap<>();
            error.put("estado", "ERROR");
            error.put("mensaje", e.getMessage());
            return ResponseEntity.status(503).body(error);
        }
    }
}
