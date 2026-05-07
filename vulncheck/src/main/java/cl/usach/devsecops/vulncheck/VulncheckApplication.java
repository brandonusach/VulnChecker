package cl.usach.devsecops.vulncheck;

import cl.usach.devsecops.vulncheck.config.SshTunnel;
import com.jcraft.jsch.Session;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
public class VulncheckApplication {

	public static void main(String[] args) {
        // 1. Guardamos el contexto de Spring al iniciar la aplicación
        ApplicationContext context = SpringApplication.run(VulncheckApplication.class, args);

        SshTunnel tunel_prueba = new SshTunnel();
        try {
            Session sesion_prueba = tunel_prueba.openTunnel("127.0.0.1", 2222, "root", "password123");
            if (sesion_prueba.isConnected()) {
                System.out.println("Túnel abierto en el puerto local: " + tunel_prueba.getLocalPort());
                Thread.sleep(1000);

                RestTemplate restTemplate = context.getBean(RestTemplate.class);

                String url = "https://127.0.0.1:9201/wazuh-states-vulnerabilities-*/_search";
                String query = """
                        {
                          "size": 10,
                          "query": {
                            "terms": {
                              "vulnerability.severity": ["Medium", "Low"]
                            }
                          }
                        }
                        """;
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_JSON);
                headers.setBasicAuth("admin", "SecretPassword");

                HttpEntity<String> request = new HttpEntity<>(query, headers);

                System.out.println("Consultando vulnerabilidades...");
                String response = restTemplate.postForObject(url, request, String.class);
                System.out.println("Respuesta de Wazuh:\n" + response);

            }
            // 4. Cerramos el túnel
            tunel_prueba.closeTunnel(sesion_prueba);
            System.out.println("Túnel cerrado correctamente.");

        } catch(Exception e) {
            System.err.println("Ocurrió un error en la ejecución:");
            e.printStackTrace();
        }
    }

}
