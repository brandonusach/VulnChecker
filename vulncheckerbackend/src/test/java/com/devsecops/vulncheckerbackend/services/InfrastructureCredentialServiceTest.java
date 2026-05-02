package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.InfrastructureCredentialRepository;
import com.devsecops.vulncheckerbackend.support.TestDataFactory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class InfrastructureCredentialServiceTest {

    @Mock
    private InfrastructureCredentialRepository repository;

    @InjectMocks
    private InfrastructureCredentialService service;

    @Test
    void save_delegatesToRepository() {
        InfrastructureCredentialEntity credential = TestDataFactory.infrastructureCredential(1L, 1L);
        when(repository.save(credential)).thenReturn(credential);

        InfrastructureCredentialEntity result = service.save(credential);

        assertEquals(credential, result);
        verify(repository).save(credential);
    }

    @Test
    void getByUserId_returnsRepositoryList() {
        List<InfrastructureCredentialEntity> list = List.of(TestDataFactory.infrastructureCredential(1L, 1L));
        when(repository.findByUserId(1L)).thenReturn(list);

        List<InfrastructureCredentialEntity> result = service.getByUserId(1L);

        assertEquals(1, result.size());
        verify(repository).findByUserId(1L);
    }

    @Test
    void delete_callsRepositoryDeleteById() {
        service.delete(5L);
        verify(repository).deleteById(5L);
    }

    @Test
    void getById_returnsEntity_whenPresent() {
        InfrastructureCredentialEntity credential = TestDataFactory.infrastructureCredential(8L, 1L);
        when(repository.findById(8L)).thenReturn(Optional.of(credential));

        InfrastructureCredentialEntity result = service.getById(8L);

        assertEquals(credential, result);
    }

    @Test
    void getById_throwsException_whenMissing() {
        when(repository.findById(9L)).thenReturn(Optional.empty());

        RuntimeException ex = assertThrows(RuntimeException.class, () -> service.getById(9L));

        assertEquals("Credencial no encontrada", ex.getMessage());
    }

    @Test
    void findById_returnsOptional() {
        InfrastructureCredentialEntity credential = TestDataFactory.infrastructureCredential(10L, 2L);
        when(repository.findById(10L)).thenReturn(Optional.of(credential));

        Optional<InfrastructureCredentialEntity> result = service.findById(10L);

        assertTrue(result.isPresent());
        assertEquals(credential, result.get());
    }
}
