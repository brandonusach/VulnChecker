package com.devsecops.vulncheckerbackend.repositories;

import com.devsecops.vulncheckerbackend.entities.ReportSignatureEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;

@Repository
public interface ReportSignatureRepository extends JpaRepository<ReportSignatureEntity, Long> {
    Optional<ReportSignatureEntity> findBySha256Hash(String sha256Hash);

    boolean existsBySha256Hash(String sha256Hash);
}