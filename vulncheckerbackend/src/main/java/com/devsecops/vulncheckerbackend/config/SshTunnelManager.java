package com.devsecops.vulncheckerbackend.config;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import org.springframework.stereotype.Component;

import java.util.Properties;

@Component
public class SshTunnelManager {

    private static final String WAZUH_HOST     = "127.0.0.1";   // host local dentro del servidor SSH
    private static final int    WAZUH_API_PORT = 9200;       // puerto por defecto de Wazuh API
    private static final int    LOCAL_PORT     = 9201;        // puerto local del tunnel

    /**
     * Abre un SSH tunnel hacia el servidor donde corre Wazuh.
     * Devuelve la sesión activa — el caller DEBE cerrarla cuando termine.
     *
     * @param sshHost     IP/hostname del servidor SSH
     * @param sshPort     Puerto SSH (normalmente 22)
     * @param sshUser     Usuario SSH
     * @param sshPassword Contraseña SSH
     */
    public Session openTunnel(String sshHost, int sshPort, String sshUser, String sshPassword) throws Exception {
        JSch jsch = new JSch();

        Session session = jsch.getSession(sshUser, sshHost, sshPort);
        session.setPassword(sshPassword);

        Properties config = new Properties();
        config.put("StrictHostKeyChecking", "no");   // en producción usa known_hosts
        session.setConfig(config);

        session.connect(10_000); // timeout 10 s

        // forward: localhost:LOCAL_PORT → WAZUH_HOST:WAZUH_API_PORT  (dentro del servidor SSH)
        session.setPortForwardingL(LOCAL_PORT, WAZUH_HOST, WAZUH_API_PORT);

        return session;
    }

    /** Cierra la sesión SSH (y el tunnel) de forma segura. */
    public void closeTunnel(Session session) {
        if (session != null && session.isConnected()) {
            session.disconnect();
        }
    }

    public int getLocalPort() {
        return LOCAL_PORT;
    }
}