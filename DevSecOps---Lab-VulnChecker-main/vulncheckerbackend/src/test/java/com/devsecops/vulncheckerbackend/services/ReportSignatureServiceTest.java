package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.ReportSignatureEntity;
import com.devsecops.vulncheckerbackend.repositories.ReportSignatureRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Base64;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ReportSignatureServiceTest {

    @Mock
    private ReportSignatureRepository repository;

    @Test
    void signAndSaveReport_generatesBase64SignatureAndPersists() throws Exception {
        ReportSignatureService service = new ReportSignatureService(repository);
        when(repository.save(any(ReportSignatureEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));

        ReportSignatureEntity result = service.signAndSaveReport("weekly-report", "abc123");

        assertEquals("weekly-report", result.getReportName());
        assertEquals("abc123", result.getSha256Hash());
        assertNotNull(result.getDigitalSignature());
        assertNotNull(result.getSignedAt());
        assertDoesNotThrow(() -> Base64.getDecoder().decode(result.getDigitalSignature()));
        verify(repository).save(any(ReportSignatureEntity.class));
    }
}
