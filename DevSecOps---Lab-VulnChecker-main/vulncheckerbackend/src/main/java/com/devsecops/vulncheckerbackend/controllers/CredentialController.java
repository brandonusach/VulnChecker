package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.entities.CredentialEntity;
import com.devsecops.vulncheckerbackend.services.CredentialService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/credentials")
@CrossOrigin(origins = "*")
public class CredentialController {

    private final CredentialService credentialService;

    public CredentialController(CredentialService credentialService) {
        this.credentialService = credentialService;
    }

    @PostMapping
    public ResponseEntity<CredentialEntity> create(@RequestBody CredentialEntity credential) {
        return ResponseEntity.ok(credentialService.save(credential));
    }

    @GetMapping("/user/{userId}")
    public List<CredentialEntity> getByUser(@PathVariable Long userId) {
        return credentialService.findByUserId(userId);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        credentialService.delete(id);
        return ResponseEntity.noContent().build();
    }
}