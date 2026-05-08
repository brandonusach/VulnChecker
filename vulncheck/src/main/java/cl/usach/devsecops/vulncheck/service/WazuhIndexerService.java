package cl.usach.devsecops.vulncheck.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class WazuhIndexerService {

    private static final Set<String> SEVERIDADES_VALIDAS = Set.of("Critical", "High", "Medium", "Low");

    @Value("${wazuh.indexer.local-port}")
    private int indexerLocalPort;

    @Value("${wazuh.indexer.user}")
    private String indexerUser;

    @Value("${wazuh.indexer.password}")
    private String indexerPassword;

    private final RestTemplate restTemplate;

    public WazuhIndexerService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getVulnerabilities(String severity, String agentId, int size) {
        if (severity != null && !SEVERIDADES_VALIDAS.contains(severity)) {
            throw new IllegalArgumentException(
                    "Severidad invalida: '" + severity + "'. Valores permitidos: Critical, High, Medium, Low");
        }

        String url = "https://127.0.0.1:" + indexerLocalPort + "/wazuh-states-vulnerabilities-*/_search";
        String query = buildQuery(severity, agentId, Math.min(size, 100));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth(indexerUser, indexerPassword);
        HttpEntity<String> request = new HttpEntity<>(query, headers);

        Map<String, Object> raw = restTemplate.postForObject(url, request,
                (Class<Map<String, Object>>) (Class<?>) Map.class);

        return parseResponse(raw, severity, agentId);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> parseResponse(Map<String, Object> raw, String severity, String agentId) {
        Map<String, Object> hits = (Map<String, Object>) raw.get("hits");
        Map<String, Object> total = (Map<String, Object>) hits.get("total");
        List<Map<String, Object>> hitList = (List<Map<String, Object>>) hits.get("hits");

        List<Map<String, Object>> vulns = hitList.stream()
                .map(h -> {
                    Map<String, Object> source = (Map<String, Object>) h.get("_source");
                    Map<String, Object> vuln = (Map<String, Object>) source.get("vulnerability");
                    Map<String, Object> agent = (Map<String, Object>) source.getOrDefault("agent", Map.of());
                    Map<String, Object> pkg = vuln.containsKey("package")
                            ? (Map<String, Object>) vuln.get("package") : Map.of();

                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("cve", vuln.getOrDefault("id", "N/A"));
                    item.put("severidad", vuln.getOrDefault("severity", "N/A"));
                    item.put("descripcion", vuln.getOrDefault("description", "N/A"));
                    item.put("paquete", pkg.getOrDefault("name", "N/A") + " " + pkg.getOrDefault("version", ""));
                    item.put("agente_id", agent.getOrDefault("id", "N/A"));
                    item.put("agente_nombre", agent.getOrDefault("name", "N/A"));
                    return item;
                })
                .collect(Collectors.toList());

        Map<String, Object> filtros = new LinkedHashMap<>();
        filtros.put("severidad", severity != null ? severity : "todas");
        filtros.put("agente", agentId != null ? agentId : "todos");

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("total", total.get("value"));
        result.put("filtros_aplicados", filtros);
        result.put("vulnerabilidades", vulns);
        return result;
    }

    private String buildQuery(String severity, String agentId, int size) {
        StringBuilder filters = new StringBuilder();

        if (severity != null) {
            filters.append("""
                    {"term": {"vulnerability.severity": "%s"}}""".formatted(severity));
        }
        if (agentId != null) {
            if (!filters.isEmpty()) filters.append(",");
            filters.append("""
                    {"term": {"agent.id": "%s"}}""".formatted(agentId));
        }

        if (!filters.isEmpty()) {
            return """
                    {
                      "size": %d,
                      "query": {"bool": {"filter": [%s]}}
                    }""".formatted(size, filters);
        }

        return """
                {
                  "size": %d,
                  "query": {"match_all": {}}
                }""".formatted(size);
    }
}
