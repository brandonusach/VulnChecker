package cl.usach.devsecops.vulncheck.config;

import com.jcraft.jsch.Session;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TunnelConfig {

    @Value("${wazuh.ssh.enabled:true}")
    private boolean sshEnabled;

    @Value("${wazuh.ssh.host}")
    private String sshHost;

    @Value("${wazuh.ssh.port}")
    private int sshPort;

    @Value("${wazuh.ssh.user}")
    private String sshUser;

    @Value("${wazuh.ssh.password}")
    private String sshPassword;

    private final SshTunnel sshTunnel;
    private Session session;
    private boolean connected = false;

    public TunnelConfig(SshTunnel sshTunnel) {
        this.sshTunnel = sshTunnel;
    }

    @PostConstruct
    public void init() {
        if (!sshEnabled) {
            connected = true;
            System.out.println("Modo directo (SSH desactivado) — conectando a Wazuh sin tunel");
            return;
        }
        try {
            session = sshTunnel.openTunnel(sshHost, sshPort, sshUser, sshPassword);
            connected = true;
            System.out.println("Tunel SSH establecido — Indexer: localhost:" + sshTunnel.getIndexerLocalPort()
                    + " | Manager API: localhost:" + sshTunnel.getManagerLocalPort());
        } catch (Exception e) {
            System.err.println("No se pudo establecer el tunel SSH: " + e.getMessage());
            System.err.println("La aplicacion iniciara sin conexion a Wazuh.");
        }
    }

    @PreDestroy
    public void destroy() {
        if (sshEnabled) {
            sshTunnel.closeTunnel(session);
            System.out.println("Tunel SSH cerrado.");
        }
    }

    public boolean isConnected() {
        if (!sshEnabled) return connected;
        return connected && session != null && session.isConnected();
    }
}
