package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import com.devsecops.vulncheckerbackend.services.InfrastructureCredentialService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/infra-credentials")
public class InfrastructureCredentialController {

    private final InfrastructureCredentialService service;

    public InfrastructureCredentialController(InfrastructureCredentialService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<InfrastructureCredentialEntity> create(@RequestBody InfrastructureCredentialEntity credential) {
        return ResponseEntity.ok(service.save(credential));
    }

    @PutMapping("/{id}")
    public ResponseEntity<InfrastructureCredentialEntity> update(
            @PathVariable Long id, 
            @RequestBody InfrastructureCredentialEntity credentialDetails) {
        
        return service.findById(id)
                .map(existingCredential -> {
                    existingCredential.setName(credentialDetails.getName());
                    existingCredential.setSshUser(credentialDetails.getSshUser());
                    // Solo actualizar contraseña si se envió una nueva
                    if (credentialDetails.getSshPassword() != null && !credentialDetails.getSshPassword().isEmpty()) {
                        existingCredential.setSshPassword(credentialDetails.getSshPassword());
                    }
                    existingCredential.setWazuhUser(credentialDetails.getWazuhUser());
                    if (credentialDetails.getWazuhPassword() != null && !credentialDetails.getWazuhPassword().isEmpty()) {
                        existingCredential.setWazuhPassword(credentialDetails.getWazuhPassword());
                    }
                    
                    return ResponseEntity.ok(service.save(existingCredential));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<InfrastructureCredentialEntity>> getByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(service.getByUserId(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}