package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.UserRepository;
import com.devsecops.vulncheckerbackend.services.InfrastructureCredentialService;
import com.devsecops.vulncheckerbackend.support.TestDataFactory;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(InfrastructureCredentialController.class)
@AutoConfigureMockMvc(addFilters = false)
class InfrastructureCredentialControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private InfrastructureCredentialService service;

    @MockitoBean
    private UserRepository userRepository;

    @MockitoBean
    private BCryptPasswordEncoder passwordEncoder;

    @Test
    void create_returnsSavedCredential() throws Exception {
        InfrastructureCredentialEntity credential = TestDataFactory.infrastructureCredential(1L, 2L);
        when(service.save(any(InfrastructureCredentialEntity.class))).thenReturn(credential);

        mockMvc.perform(post("/api/infra-credentials")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"id\":1,\"name\":\"Laboratorio\",\"sshUser\":\"root\",\"sshPassword\":\"ssh-pass\",\"wazuhUser\":\"wazuh-api\",\"wazuhPassword\":\"wazuh-pass\",\"userId\":2}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1));
    }

    @Test
    void update_preservesExistingPasswords_whenRequestPasswordsAreBlank() throws Exception {
        InfrastructureCredentialEntity existing = TestDataFactory.infrastructureCredential(4L, 1L);
        InfrastructureCredentialEntity request = TestDataFactory.infrastructureCredential(null, 1L);
        request.setName("Nuevo nombre");
        request.setSshUser("nuevo-ssh");
        request.setSshPassword("");
        request.setWazuhUser("nuevo-wazuh");
        request.setWazuhPassword("");

        when(service.findById(4L)).thenReturn(Optional.of(existing));
        when(service.save(any(InfrastructureCredentialEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));

        mockMvc.perform(put("/api/infra-credentials/4")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"Nuevo nombre\",\"sshUser\":\"nuevo-ssh\",\"sshPassword\":\"\",\"wazuhUser\":\"nuevo-wazuh\",\"wazuhPassword\":\"\",\"userId\":1}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Nuevo nombre"))
                .andExpect(jsonPath("$.sshUser").value("nuevo-ssh"))
                .andExpect(jsonPath("$.wazuhUser").value("nuevo-wazuh"));

        ArgumentCaptor<InfrastructureCredentialEntity> captor = ArgumentCaptor.forClass(InfrastructureCredentialEntity.class);
        verify(service).save(captor.capture());
        assertEquals("ssh-pass", captor.getValue().getSshPassword());
        assertEquals("wazuh-pass", captor.getValue().getWazuhPassword());
    }

    @Test
    void update_returnsNotFound_whenCredentialDoesNotExist() throws Exception {
        InfrastructureCredentialEntity request = TestDataFactory.infrastructureCredential(null, 1L);
        when(service.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(put("/api/infra-credentials/99")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"Laboratorio\",\"sshUser\":\"root\",\"sshPassword\":\"ssh-pass\",\"wazuhUser\":\"wazuh-api\",\"wazuhPassword\":\"wazuh-pass\",\"userId\":1}"))
                .andExpect(status().isNotFound());
    }

    @Test
    void getByUser_returnsCredentials() throws Exception {
        when(service.getByUserId(2L)).thenReturn(List.of(TestDataFactory.infrastructureCredential(1L, 2L)));

        mockMvc.perform(get("/api/infra-credentials/user/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1));
    }

    @Test
    void delete_returnsNoContent() throws Exception {
        mockMvc.perform(delete("/api/infra-credentials/8"))
                .andExpect(status().isNoContent());

        verify(service).delete(8L);
    }
}
