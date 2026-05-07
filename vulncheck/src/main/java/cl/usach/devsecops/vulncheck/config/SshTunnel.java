package cl.usach.devsecops.vulncheck.config;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import org.springframework.stereotype.Component;

import java.util.Properties;

@Component
public class SshTunnel {
    private final String HOST_WAZUH = "172.19.0.2"; // verificar si la direccion sigue siendo esta
    private final int API_WAZUH = 9200; // puerto de la api de wazuh
    private final int LOCAL_PORT = 9201; // puerto de la maquina local

    // abre el tunel ssh para conectarse con wazuh
    public Session openTunnel(String sshHost, int sshPort, String sshUser, String sshPassword) throws Exception {

        JSch jsch = new JSch();

        // se crea una sesion con jsch pidiendo el usuario, host (ip) y el puerto, y setea una contraseña
        Session session = jsch.getSession(sshUser, sshHost, sshPort);
        session.setPassword(sshPassword);

        Properties config = new Properties();

        // usar known host mas adelante para verificar identidades
        config.put("StrictHostKeyChecking", "no"); // no se verifica la identidad

        session.setConfig(config); // setea la configuracion (lo de arriba)

        session.connect(10_000); // timeout 10 s

        // forward desde el LOCAL_PORT hacia API_WAZUH
        // dirige el trafico desde el puerto local hacia la api de wazuh
        session.setPortForwardingL(LOCAL_PORT, HOST_WAZUH, API_WAZUH);

        return session;
    }

    // cierra el tunel de conexion con wazuh
    public void closeTunnel(Session session) {
        if (session != null && session.isConnected()) {
            session.disconnect();
        }
    }

    public int getLocalPort() {
        return LOCAL_PORT;
    }
}
