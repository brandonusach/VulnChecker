package cl.usach.devsecops.vulncheck.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class WazuhAuthService {

    @Value("${wazuh.manager.local-port}")
    private int managerLocalPort;

    @Value("${wazuh.manager.user}")
    private String managerUser;

    @Value("${wazuh.manager.password}")
    private String managerPassword;

    private final RestTemplate restTemplate;
    private String cachedToken;
    private Instant tokenObtainedAt;
    private Instant tokenExpiry = Instant.MIN;

    public WazuhAuthService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String getToken() {
        if (cachedToken == null || Instant.now().isAfter(tokenExpiry)) {
            cachedToken = fetchToken();
            tokenObtainedAt = Instant.now();
            tokenExpiry = tokenObtainedAt.plusSeconds(890);
        }
        return cachedToken;
    }

    public Map<String, Object> getTokenInfo() {
        String token = getToken();
        long segundosRestantes = Instant.now().until(tokenExpiry, ChronoUnit.SECONDS);

        Map<String, Object> info = new LinkedHashMap<>();
        info.put("usuario", managerUser);
        info.put("token_preview", token.substring(0, 20) + "..." + token.substring(token.length() - 10));
        info.put("token_completo", token);
        info.put("obtenido_at", tokenObtainedAt.toString());
        info.put("expira_en_segundos", segundosRestantes);
        info.put("expira_at", tokenExpiry.toString());
        return info;
    }

    @SuppressWarnings("unchecked")
    private String fetchToken() {
        String url = "https://127.0.0.1:" + managerLocalPort + "/security/user/authenticate";

        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(managerUser, managerPassword);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        ResponseEntity<Map<String, Object>> response = restTemplate.postForEntity(url, request,
                (Class<Map<String, Object>>) (Class<?>) Map.class);
        Map<String, Object> data = (Map<String, Object>) response.getBody().get("data");
        return (String) data.get("token");
    }
}
