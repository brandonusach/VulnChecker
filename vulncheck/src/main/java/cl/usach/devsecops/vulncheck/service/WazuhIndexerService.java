package cl.usach.devsecops.vulncheck.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class WazuhIndexerService {

    private static final Set<String> SEVERIDADES_VALIDAS = Set.of("Critical", "High", "Medium", "Low");

    @Value("${wazuh.ssh.enabled:true}")
    private boolean sshEnabled;

    @Value("${wazuh.indexer.local-port}")
    private int indexerLocalPort;

    @Value("${wazuh.indexer.remote-host}")
    private String indexerRemoteHost;

    @Value("${wazuh.indexer.remote-port}")
    private int indexerRemotePort;

    @Value("${wazuh.indexer.user}")
    private String indexerUser;

    @Value("${wazuh.indexer.password}")
    private String indexerPassword;

    private final RestTemplate restTemplate;

    public WazuhIndexerService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> authenticate() {
        String base = sshEnabled
                ? "https://127.0.0.1:" + indexerLocalPort
                : "https://" + indexerRemoteHost + ":" + indexerRemotePort;

        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(indexerUser, indexerPassword, java.nio.charset.StandardCharsets.UTF_8);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        Map<String, Object> authInfo = restTemplate.exchange(
                base + "/_plugins/_security/authinfo",
                org.springframework.http.HttpMethod.GET, request,
                (Class<Map<String, Object>>) (Class<?>) Map.class).getBody();

        Instant now = Instant.now();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("autenticado", true);
        result.put("usuario", authInfo.get("user_name"));
        result.put("roles", authInfo.get("roles"));
        result.put("backend_roles", authInfo.get("backend_roles"));
        result.put("tipo_auth", "Basic Auth → JWT Wazuh Indexer");
        result.put("indexer_host", indexerRemoteHost + ":" + indexerRemotePort);
        result.put("timestamp", now.toString());
        return result;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getClusterInfo() {
        String base = sshEnabled
                ? "https://127.0.0.1:" + indexerLocalPort
                : "https://" + indexerRemoteHost + ":" + indexerRemotePort;

        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(indexerUser, indexerPassword, java.nio.charset.StandardCharsets.UTF_8);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        // GET / — cluster info
        Map<String, Object> root = restTemplate.exchange(
                base + "/", org.springframework.http.HttpMethod.GET, request,
                (Class<Map<String, Object>>) (Class<?>) Map.class).getBody();

        // GET /_cluster/health — cluster health
        Map<String, Object> health = restTemplate.exchange(
                base + "/_cluster/health", org.springframework.http.HttpMethod.GET, request,
                (Class<Map<String, Object>>) (Class<?>) Map.class).getBody();

        // Aggregation: count vulnerabilities per agent
        String aggsQuery = """
                {"size":0,"aggs":{"agentes":{"terms":{"field":"agent.id","size":50}}}}""";
        HttpHeaders jsonHeaders = new HttpHeaders();
        jsonHeaders.setContentType(MediaType.APPLICATION_JSON);
        jsonHeaders.setBasicAuth(indexerUser, indexerPassword, java.nio.charset.StandardCharsets.UTF_8);
        HttpEntity<String> aggsReq = new HttpEntity<>(aggsQuery, jsonHeaders);
        Map<String, Object> aggsRaw = restTemplate.postForObject(
                base + "/wazuh-states-vulnerabilities-*/_search", aggsReq,
                (Class<Map<String, Object>>) (Class<?>) Map.class);

        Map<String, Object> version = (Map<String, Object>) root.get("version");
        List<Map<String, Object>> buckets = (List<Map<String, Object>>)
                ((Map<String, Object>) ((Map<String, Object>) aggsRaw.get("aggregations")).get("agentes")).get("buckets");

        List<Map<String, Object>> agentes = buckets.stream().map(b -> {
            Map<String, Object> a = new LinkedHashMap<>();
            a.put("agente_id", b.get("key"));
            a.put("vulnerabilidades", b.get("doc_count"));
            return a;
        }).collect(Collectors.toList());

        Map<String, Object> hitsTotal = (Map<String, Object>)
                ((Map<String, Object>) aggsRaw.get("hits")).get("total");

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("estado", "CONECTADO");
        result.put("cluster_nombre", root.get("cluster_name"));
        result.put("nodo_nombre", root.get("name"));
        result.put("opensearch_version", version != null ? version.get("number") : "N/A");
        result.put("cluster_salud", health != null ? health.get("status") : "N/A");
        result.put("total_vulnerabilidades", hitsTotal.get("value"));
        result.put("agentes", agentes);
        return result;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getVulnerabilities(String severity, String agentId, int size) {
        if (severity != null && !SEVERIDADES_VALIDAS.contains(severity)) {
            throw new IllegalArgumentException(
                    "Severidad invalida: '" + severity + "'. Valores permitidos: Critical, High, Medium, Low");
        }

        String base = sshEnabled
                ? "https://127.0.0.1:" + indexerLocalPort
                : "https://" + indexerRemoteHost + ":" + indexerRemotePort;
        String url = base + "/wazuh-states-vulnerabilities-*/_search";
        String query = buildQuery(severity, agentId, Math.min(size, 100));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth(indexerUser, indexerPassword, java.nio.charset.StandardCharsets.UTF_8);
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
