package cl.usach.devsecops.vulncheck.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
public class WazuhManagerService {

    @Value("${wazuh.manager.local-port}")
    private int managerLocalPort;

    @Value("${wazuh.indexer.remote-host}")
    private String wazuhIp;

    private final RestTemplate restTemplate;
    private final WazuhAuthService authService;

    public WazuhManagerService(RestTemplate restTemplate, WazuhAuthService authService) {
        this.restTemplate = restTemplate;
        this.authService = authService;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getManagerInfo() {
        String url = "https://127.0.0.1:" + managerLocalPort + "/manager/info";

        ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                url, HttpMethod.GET, bearerRequest(), getMapType());

        // Wazuh retorna: { data: { affected_items: [{ version, type, ... }] } }
        Map<String, Object> data = (Map<String, Object>) response.getBody().get("data");
        List<Map<String, Object>> items = (List<Map<String, Object>>) data.get("affected_items");
        return items.get(0);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getAgents() {
        String url = "https://127.0.0.1:" + managerLocalPort + "/agents?limit=500";

        ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                url, HttpMethod.GET, bearerRequest(), getMapType());

        Map<String, Object> data = (Map<String, Object>) response.getBody().get("data");
        return (List<Map<String, Object>>) data.get("affected_items");
    }

    public String getWazuhIp() {
        return wazuhIp;
    }

    private HttpEntity<Void> bearerRequest() {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(authService.getToken());
        return new HttpEntity<>(headers);
    }

    @SuppressWarnings("unchecked")
    private Class<Map<String, Object>> getMapType() {
        return (Class<Map<String, Object>>) (Class<?>) Map.class;
    }
}
