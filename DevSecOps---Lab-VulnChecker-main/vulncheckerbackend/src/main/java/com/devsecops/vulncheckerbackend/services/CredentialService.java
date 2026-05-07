package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.CredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.CredentialRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CredentialService {

    private final CredentialRepository credentialRepository;

    public CredentialService(CredentialRepository credentialRepository) {
        this.credentialRepository = credentialRepository;
    }

    public CredentialEntity save(CredentialEntity credential) {
        return credentialRepository.save(credential);
    }

    public List<CredentialEntity> findByUserId(Long userId) {
        return credentialRepository.findByCreatedByUserId(userId);
    }

    public void delete(Long id) {
        credentialRepository.deleteById(id);
    }
}