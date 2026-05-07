package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.repositories.VulnerabilityRepository;
import com.devsecops.vulncheckerbackend.dto.VulnerabilityRequest;
import com.devsecops.vulncheckerbackend.dto.WazuhCredentials;
import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.InfrastructureCredentialRepository;
import com.devsecops.vulncheckerbackend.services.WazuhService;

import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;

import java.util.Base64;
import java.util.Map;

@RestController
@RequestMapping("/api/vulns")
public class WazuhVulnController {

    private final WazuhService wazuhService;
    private final InfrastructureCredentialRepository infraRepo;
	private final VulnerabilityRepository vulnerabilityRepository;
    private static final Logger log = LoggerFactory.getLogger(WazuhVulnController.class);

    public WazuhVulnController(WazuhService wazuhService, 
                               InfrastructureCredentialRepository infraRepo,
                               VulnerabilityRepository vulnerabilityRepository) {
        this.wazuhService = wazuhService;
        this.infraRepo = infraRepo;
        this.vulnerabilityRepository = vulnerabilityRepository;
    }

    // ─── Helper ──────────────────────────────────────────────────────────────

    private WazuhCredentials creds(String sshHost, String sshUser, String sshPassword,
                                   String authHeader) {
        // Extrae user:pass del header "Basic base64..."
        String decoded = new String(Base64.getDecoder().decode(
                authHeader.replace("Basic ", "").trim()
        ));
        String[] parts = decoded.split(":", 2);
        return new WazuhCredentials(sshHost, sshUser, sshPassword, parts[0], parts[1]);
    }

    // ─── 1. Todas (paginadas) ─────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/all")
    public ResponseEntity<Map<String, Object>> getAllLegacy(
            @PathVariable String sshHost, @PathVariable String sshUser, @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth) throws Exception {
        return ResponseEntity.ok(wazuhService.getAllVulnerabilities(creds(sshHost, sshUser, sshPassword, auth), 100, 0));
    }

	@GetMapping("/count-local")
	public ResponseEntity<Map<String, Long>> getLocalCount() {
		long count = vulnerabilityRepository.count();
		log.info("Consulta de conteo local: {}", count);
		return ResponseEntity.ok(Map.of("count", count));
	}
    
	// ─── 2. Top N ─────────────────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/top/{limit}")
    public ResponseEntity<Map<String, Object>> getTop(
            @PathVariable String sshHost,
            @PathVariable String sshUser,
            @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth,
            @PathVariable int limit) throws Exception {

        return ResponseEntity.ok(
                wazuhService.getTopVulnerabilities(creds(sshHost, sshUser, sshPassword, auth), limit)
        );
    }

    // ─── 3. Críticas ──────────────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/critical")
    public ResponseEntity<Map<String, Object>> getCritical(
            @PathVariable String sshHost,
            @PathVariable String sshUser,
            @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth) throws Exception {

        return ResponseEntity.ok(
                wazuhService.getCriticalVulnerabilities(creds(sshHost, sshUser, sshPassword, auth))
        );
    }

    // ─── 4. Por severidad ─────────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/severity/{severity}")
    public ResponseEntity<Map<String, Object>> getBySeverity(
            @PathVariable String sshHost,
            @PathVariable String sshUser,
            @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth,
            @PathVariable String severity,
            @RequestParam(defaultValue = "100") int limit) throws Exception {

        return ResponseEntity.ok(
                wazuhService.getVulnerabilitiesBySeverity(creds(sshHost, sshUser, sshPassword, auth), severity, limit)
        );
    }

    // ─── 5. Por CVE ───────────────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/cve/{cve}")
    public ResponseEntity<Map<String, Object>> getByCve(
            @PathVariable String sshHost,
            @PathVariable String sshUser,
            @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth,
            @PathVariable String cve) throws Exception {

        return ResponseEntity.ok(
                wazuhService.getVulnerabilitiesByCve(creds(sshHost, sshUser, sshPassword, auth), cve)
        );
    }

    // ─── 6. Por agente ────────────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/agent/{agentId}")
    public ResponseEntity<Map<String, Object>> getByAgent(
            @PathVariable String sshHost,
            @PathVariable String sshUser,
            @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth,
            @PathVariable String agentId,
            @RequestParam(defaultValue = "100") int limit) throws Exception {

        return ResponseEntity.ok(
                wazuhService.getVulnerabilitiesByAgent(creds(sshHost, sshUser, sshPassword, auth), agentId, limit)
        );
    }

    // ─── 7. Resumen ───────────────────────────────────────────────────────────
    @GetMapping("/{sshHost}/{sshUser}/{sshPassword}/summary")
    public ResponseEntity<Map<String, Object>> getSummary(
            @PathVariable String sshHost,
            @PathVariable String sshUser,
            @PathVariable String sshPassword,
            @RequestHeader("Authorization") String auth) throws Exception {

        return ResponseEntity.ok(
                wazuhService.getVulnerabilitiesSummary(creds(sshHost, sshUser, sshPassword, auth))
        );
    }

	// ─── 8. Sincronización masiva (POST) ─────────────────────────────────────
    @PostMapping("/consume")
	public ResponseEntity<Map<String, Object>> consumeAll(
			@RequestBody VulnerabilityRequest request,
			@RequestHeader("Authorization") String auth) {

		InfrastructureCredentialEntity credEntity = infraRepo.findById(request.getInfrastructureCredentialId())
				.orElseThrow(() -> new RuntimeException("Credencial no encontrada"));

		WazuhCredentials credentials = new WazuhCredentials(
				request.getIp(),
				credEntity.getSshUser(),
				credEntity.getSshPassword(),
				credEntity.getWazuhUser(),
				credEntity.getWazuhPassword()
		);

		// Ejecución asíncrona delegada al servicio
		wazuhService.syncAllVulnerabilitiesMasive(credentials);

		return ResponseEntity.ok(Map.of(
			"status", "processing",
			"message", "Sincronización de gran volumen iniciada. Esto puede tardar varios minutos."
		));
	}
	
	@PostMapping("/remote-count")
	public ResponseEntity<Map<String, Long>> getRemoteCount(@RequestBody VulnerabilityRequest request) throws Exception {
		InfrastructureCredentialEntity credEntity = infraRepo.findById(request.getInfrastructureCredentialId())
				.orElseThrow(() -> new RuntimeException("Credencial no encontrada"));

		WazuhCredentials credentials = new WazuhCredentials(
				request.getIp(), credEntity.getSshUser(), credEntity.getSshPassword(),
				credEntity.getWazuhUser(), credEntity.getWazuhPassword()
		);

		long total = wazuhService.getRemoteTotalCount(credentials);
		return ResponseEntity.ok(Map.of("total", total));
	}

	// ─── Manejo de errores ────────────────────────────────────────────────────
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleError(Exception e) {
        String customMessage = e.getMessage();
        
        if (e.getMessage() != null && e.getMessage().contains("timeout: socket is not established")) {
            customMessage = "No se pudo establecer conexión SSH (Timeout). Verifica que la IP sea correcta y el puerto 22 esté abierto.";
        } else if (e.getMessage() != null && e.getMessage().contains("Auth fail")) {
            customMessage = "Credenciales SSH incorrectas.";
        }

        return ResponseEntity.status(500).body(Map.of(
                "error", e.getClass().getSimpleName(),
                "message", customMessage != null ? customMessage : "Error desconocido en el servidor"
        ));
    }
}
