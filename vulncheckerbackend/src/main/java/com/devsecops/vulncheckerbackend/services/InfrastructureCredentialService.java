package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.InfrastructureCredentialRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InfrastructureCredentialService {

    private final InfrastructureCredentialRepository repository;

    public InfrastructureCredentialService(InfrastructureCredentialRepository repository) {
        this.repository = repository;
    }

    public InfrastructureCredentialEntity save(InfrastructureCredentialEntity credential) {
        return repository.save(credential);
    }

    public List<InfrastructureCredentialEntity> getByUserId(Long userId) {
        return repository.findByUserId(userId);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }

    public InfrastructureCredentialEntity getById(Long id) {
        return repository.findById(id).orElseThrow(() -> new RuntimeException("Credencial no encontrada"));
    }

    // Método para el Controller (permite usar .map() o .isPresent())
    public Optional<InfrastructureCredentialEntity> findById(Long id) {
        return repository.findById(id);
    }
}