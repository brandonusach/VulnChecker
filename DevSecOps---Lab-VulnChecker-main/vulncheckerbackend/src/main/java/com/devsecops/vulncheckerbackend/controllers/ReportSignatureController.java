package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.dto.ReportSignatureRequest;
import com.devsecops.vulncheckerbackend.entities.ReportSignatureEntity;
import com.devsecops.vulncheckerbackend.services.ReportSignatureService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/reports")
@CrossOrigin(origins = "*")
public class ReportSignatureController {

    private final ReportSignatureService reportSignatureService;

    public ReportSignatureController(ReportSignatureService reportSignatureService) {
        this.reportSignatureService = reportSignatureService;
    }

    @PostMapping("/sign")
    public ResponseEntity<Map<String, String>> signReportHash(@RequestBody ReportSignatureRequest reportSignatureRequest) {
        try {
            // El controlador delega la tarea al servicio
            ReportSignatureEntity savedEntity = reportSignatureService.signAndSaveReport(
                reportSignatureRequest.getReportName(), 
                reportSignatureRequest.getSha256Hash()
            );

            // Preparamos una respuesta JSON limpia
            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Reporte firmado y protegido.");
            response.put("signature", savedEntity.getDigitalSignature());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "Fallo al generar la firma criptográfica: " + e.getMessage());
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
}