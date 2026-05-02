package com.devsecops.vulncheckerbackend.repositories;

import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InfrastructureCredentialRepository extends JpaRepository<InfrastructureCredentialEntity, Long> {
    List<InfrastructureCredentialEntity> findByUserId(Long userId);
}