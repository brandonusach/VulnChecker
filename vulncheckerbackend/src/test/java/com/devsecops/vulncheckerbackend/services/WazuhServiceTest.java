package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.config.SshTunnelManager;
import com.devsecops.vulncheckerbackend.dto.WazuhCredentials;
import com.devsecops.vulncheckerbackend.repositories.VulnerabilityRepository;
import com.devsecops.vulncheckerbackend.repositories.VulnerabilitySnapshotRepository;
import com.jcraft.jsch.Session;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.ArgumentMatchers;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;
import java.util.concurrent.Executor;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class WazuhServiceTest {

    @Mock
    private SshTunnelManager tunnelManager;

    @Mock
    private RestTemplate restTemplate;

    @Mock
    private VulnerabilityRepository vulnerabilityRepository;

    @Mock
    private VulnerabilitySnapshotRepository snapshotRepository;

    @Mock
    private Session session;

    private WazuhService service;

    private static final WazuhCredentials CREDS = new WazuhCredentials(
            "10.0.0.1", "root", "ssh-pass", "api-user", "api-pass"
    );

    @BeforeEach
    void setUp() {
        Executor directExecutor = Runnable::run;
        service = new WazuhService(tunnelManager, restTemplate, vulnerabilityRepository, snapshotRepository, directExecutor);
    }

    @Test
    void getAllVulnerabilities_queriesWazuhWithoutPersistingSnapshots() throws Exception {
        when(tunnelManager.openTunnel("10.0.0.1", 22, "root", "ssh-pass")).thenReturn(session);
        when(tunnelManager.getLocalPort()).thenReturn(9201);
        when(restTemplate.exchange(
                anyString(),
                eq(HttpMethod.POST),
                any(HttpEntity.class),
                ArgumentMatchers.<ParameterizedTypeReference<Map<String, Object>>>any()
        )).thenReturn(ResponseEntity.ok(searchResponse(List.of(singleHit("CVE-2026-1000", "High", "001", "openssl", List.of(1700000001L, "abc"))))));

        Map<String, Object> result = service.getAllVulnerabilities(CREDS, 6000, 10);

        assertNotNull(result);
        verifyNoInteractions(vulnerabilityRepository);
        verifyNoInteractions(snapshotRepository);
        verify(tunnelManager).closeTunnel(session);

        ArgumentCaptor<HttpEntity<String>> requestCaptor = ArgumentCaptor.forClass(HttpEntity.class);
        verify(restTemplate).exchange(
                anyString(),
                eq(HttpMethod.POST),
                requestCaptor.capture(),
                ArgumentMatchers.<ParameterizedTypeReference<Map<String, Object>>>any()
        );
        String queryBody = requestCaptor.getValue().getBody();
        assertNotNull(queryBody);
        assertTrue(queryBody.contains("\"from\": 10"));
        assertTrue(queryBody.contains("\"size\": 5000"));
    }

    @Test
    void getAllVulnerabilities_closesTunnelWhenSearchFails() throws Exception {
        when(tunnelManager.openTunnel(anyString(), eq(22), anyString(), anyString())).thenReturn(session);
        when(tunnelManager.getLocalPort()).thenReturn(9201);
        when(restTemplate.exchange(
                anyString(),
                eq(HttpMethod.POST),
                any(HttpEntity.class),
                ArgumentMatchers.<ParameterizedTypeReference<Map<String, Object>>>any()
        )).thenThrow(new RuntimeException("network error"));

        assertThrows(RuntimeException.class, () -> service.getAllVulnerabilities(CREDS, 100, 0));
        verify(tunnelManager).closeTunnel(session);
    }

    @Test
    void getRemoteTotalCount_parsesCountAndClosesTunnel() throws Exception {
        when(tunnelManager.openTunnel("10.0.0.1", 22, "root", "ssh-pass")).thenReturn(session);
        when(tunnelManager.getLocalPort()).thenReturn(9201);
        when(restTemplate.exchange(
                anyString(),
                eq(HttpMethod.GET),
                any(HttpEntity.class),
                ArgumentMatchers.<ParameterizedTypeReference<Map<String, Object>>>any()
        )).thenReturn(ResponseEntity.ok(Map.of("count", "42")));

        long count = service.getRemoteTotalCount(CREDS);

        assertEquals(42L, count);
        verify(tunnelManager).closeTunnel(session);
    }

    @Test
    void syncAllVulnerabilitiesMasive_processesBatchAndStopsOnEmptyPage() throws Exception {
        when(tunnelManager.openTunnel("10.0.0.1", 22, "root", "ssh-pass")).thenReturn(session);
        when(tunnelManager.getLocalPort()).thenReturn(9201);
        when(vulnerabilityRepository.existsByCveAndAgentIdAndPackageName("CVE-2026-2000", "001", "openssl")).thenReturn(false);

        Map<String, Object> firstPage = searchResponse(List.of(singleHit("CVE-2026-2000", "Critical", "001", "openssl", List.of(1700000002L, "def"))));
        Map<String, Object> emptyPage = searchResponse(List.of());

        when(restTemplate.exchange(
                anyString(),
                eq(HttpMethod.POST),
                any(HttpEntity.class),
                ArgumentMatchers.<ParameterizedTypeReference<Map<String, Object>>>any()
        )).thenReturn(ResponseEntity.ok(firstPage), ResponseEntity.ok(emptyPage));

        service.syncAllVulnerabilitiesMasive(CREDS);

        verify(vulnerabilityRepository).saveAll(argThat(items -> {
            int size = 0;
            for (Object item : items) {
                size++;
            }
            return size == 1;
        }));
        verify(snapshotRepository).save(any());
        verify(tunnelManager).closeTunnel(session);
        verify(restTemplate, times(2)).exchange(
                anyString(),
                eq(HttpMethod.POST),
                any(HttpEntity.class),
                ArgumentMatchers.<ParameterizedTypeReference<Map<String, Object>>>any()
        );
    }

    private static Map<String, Object> searchResponse(List<Map<String, Object>> hits) {
        return Map.of("hits", Map.of("hits", hits));
    }

    private static Map<String, Object> singleHit(String cve, String severity, String agentId, String pkg, List<Object> sortValues) {
        return Map.of(
                "_source", Map.of(
                        "vulnerability", Map.of(
                                "id", cve,
                                "severity", severity,
                                "score", Map.of("base", 8.4),
                                "detected_at", "2026-01-10T10:00:00Z",
                                "description", "Desc",
                                "title", "Title"
                        ),
                        "agent", Map.of(
                                "id", agentId,
                                "name", "agent-" + agentId
                        ),
                        "package", Map.of(
                                "name", pkg,
                                "version", "1.0.0"
                        )
                ),
                "sort", sortValues
        );
    }
}
