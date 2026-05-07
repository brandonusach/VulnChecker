package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.CredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.CredentialRepository;
import com.devsecops.vulncheckerbackend.support.TestDataFactory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CredentialServiceTest {

    @Mock
    private CredentialRepository credentialRepository;

    @InjectMocks
    private CredentialService credentialService;

    @Test
    void save_delegatesToRepository() {
        CredentialEntity credential = TestDataFactory.credential(10L, 1L);
        when(credentialRepository.save(credential)).thenReturn(credential);

        CredentialEntity result = credentialService.save(credential);

        assertEquals(credential, result);
        verify(credentialRepository).save(credential);
    }

    @Test
    void findByUserId_returnsRepositoryValues() {
        List<CredentialEntity> credentials = List.of(TestDataFactory.credential(11L, 1L));
        when(credentialRepository.findByCreatedByUserId(1L)).thenReturn(credentials);

        List<CredentialEntity> result = credentialService.findByUserId(1L);

        assertEquals(1, result.size());
        verify(credentialRepository).findByCreatedByUserId(1L);
    }

    @Test
    void delete_callsRepositoryDeleteById() {
        credentialService.delete(99L);
        verify(credentialRepository).deleteById(99L);
    }
}
