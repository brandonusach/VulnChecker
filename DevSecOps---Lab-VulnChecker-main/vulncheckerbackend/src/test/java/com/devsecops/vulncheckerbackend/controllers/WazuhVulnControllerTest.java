package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.dto.WazuhCredentials;
import com.devsecops.vulncheckerbackend.entities.InfrastructureCredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.InfrastructureCredentialRepository;
import com.devsecops.vulncheckerbackend.repositories.UserRepository;
import com.devsecops.vulncheckerbackend.repositories.VulnerabilityRepository;
import com.devsecops.vulncheckerbackend.services.WazuhService;
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

import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(WazuhVulnController.class)
@AutoConfigureMockMvc(addFilters = false)
class WazuhVulnControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private WazuhService wazuhService;

    @MockitoBean
    private InfrastructureCredentialRepository infraRepo;

    @MockitoBean
    private VulnerabilityRepository vulnerabilityRepository;

    @MockitoBean
    private UserRepository userRepository;

    @MockitoBean
    private BCryptPasswordEncoder passwordEncoder;

    @Test
    void getAllLegacy_returnsDataWithDecodedCredentials() throws Exception {
        when(wazuhService.getAllVulnerabilities(any(WazuhCredentials.class), eq(100), eq(0)))
                .thenReturn(Map.of("ok", true));

        mockMvc.perform(get("/api/vulns/10.0.0.1/root/ssh-pass/all")
                        .header("Authorization", TestDataFactory.basicAuthHeader("wazuh", "api-pass")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.ok").value(true));

        ArgumentCaptor<WazuhCredentials> captor = ArgumentCaptor.forClass(WazuhCredentials.class);
        verify(wazuhService).getAllVulnerabilities(captor.capture(), eq(100), eq(0));
        assertEquals("10.0.0.1", captor.getValue().sshHost());
        assertEquals("root", captor.getValue().sshUser());
        assertEquals("ssh-pass", captor.getValue().sshPassword());
        assertEquals("wazuh", captor.getValue().wazuhUser());
    }

    @Test
    void getTop_usesFixedRouteWithSshPathVariables() throws Exception {
        when(wazuhService.getTopVulnerabilities(any(WazuhCredentials.class), eq(5)))
                .thenReturn(Map.of("total", 5));

        mockMvc.perform(get("/api/vulns/10.0.0.1/root/ssh-pass/top/5")
                        .header("Authorization", TestDataFactory.basicAuthHeader("api", "pass")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.total").value(5));
    }

    @Test
    void getSummary_mapsTimeoutErrorWithFriendlyMessage() throws Exception {
        when(wazuhService.getVulnerabilitiesSummary(any(WazuhCredentials.class)))
                .thenThrow(new RuntimeException("timeout: socket is not established"));

        mockMvc.perform(get("/api/vulns/host/user/password/summary")
                        .header("Authorization", TestDataFactory.basicAuthHeader("api", "pass")))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("No se pudo establecer conexión SSH (Timeout). Verifica que la IP sea correcta y el puerto 22 esté abierto."));
    }

    @Test
    void getCritical_mapsAuthFailError() throws Exception {
        when(wazuhService.getCriticalVulnerabilities(any(WazuhCredentials.class)))
                .thenThrow(new RuntimeException("Auth fail"));

        mockMvc.perform(get("/api/vulns/host/user/password/critical")
                        .header("Authorization", TestDataFactory.basicAuthHeader("api", "pass")))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("Credenciales SSH incorrectas."));
    }

    @Test
    void getLocalCount_returnsRepositoryCount() throws Exception {
        when(vulnerabilityRepository.count()).thenReturn(123L);

        mockMvc.perform(get("/api/vulns/count-local"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.count").value(123));
    }

    @Test
    void consumeAll_returnsProcessingAndInvokesSync() throws Exception {
        InfrastructureCredentialEntity infraCredential = TestDataFactory.infrastructureCredential(1L, 9L);
        when(infraRepo.findById(1L)).thenReturn(Optional.of(infraCredential));

        mockMvc.perform(post("/api/vulns/consume")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", TestDataFactory.basicAuthHeader("api", "pass"))
                        .content("{\"ip\":\"192.168.1.10\",\"infrastructureCredentialId\":1}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("processing"));

        verify(wazuhService).syncAllVulnerabilitiesMasive(any(WazuhCredentials.class));
    }

    @Test
    void remoteCount_returnsRemoteTotal() throws Exception {
        InfrastructureCredentialEntity infraCredential = TestDataFactory.infrastructureCredential(1L, 9L);
        when(infraRepo.findById(1L)).thenReturn(Optional.of(infraCredential));
        when(wazuhService.getRemoteTotalCount(any(WazuhCredentials.class))).thenReturn(456L);

        mockMvc.perform(post("/api/vulns/remote-count")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"ip\":\"192.168.1.11\",\"infrastructureCredentialId\":1}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.total").value(456));
    }
}
