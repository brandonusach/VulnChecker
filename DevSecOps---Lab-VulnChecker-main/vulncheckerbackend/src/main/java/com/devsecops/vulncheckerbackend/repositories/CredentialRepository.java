package com.devsecops.vulncheckerbackend.repositories;

import com.devsecops.vulncheckerbackend.entities.CredentialEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CredentialRepository extends JpaRepository<CredentialEntity, Long> {
    // Buscar todas las credenciales creadas por un usuario específico
    List<CredentialEntity> findByCreatedByUserId(Long userId);
}