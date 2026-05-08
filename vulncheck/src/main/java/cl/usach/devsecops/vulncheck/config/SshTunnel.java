package cl.usach.devsecops.vulncheck.config;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Properties;

@Component
public class SshTunnel {

    @Value("${wazuh.indexer.remote-host}")
    private String indexerRemoteHost;

    @Value("${wazuh.indexer.remote-port}")
    private int indexerRemotePort;

    @Value("${wazuh.indexer.local-port}")
    private int indexerLocalPort;

    @Value("${wazuh.manager.remote-host}")
    private String managerRemoteHost;

    @Value("${wazuh.manager.remote-port}")
    private int managerRemotePort;

    @Value("${wazuh.manager.local-port}")
    private int managerLocalPort;

    public Session openTunnel(String sshHost, int sshPort, String sshUser, String sshPassword) throws Exception {
        JSch jsch = new JSch();

        Session session = jsch.getSession(sshUser, sshHost, sshPort);
        session.setPassword(sshPassword);

        Properties config = new Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);

        session.connect(10_000);

        // Forward al Wazuh Indexer (OpenSearch)
        session.setPortForwardingL(indexerLocalPort, indexerRemoteHost, indexerRemotePort);

        // Forward al Wazuh Manager API
        session.setPortForwardingL(managerLocalPort, managerRemoteHost, managerRemotePort);

        return session;
    }

    public void closeTunnel(Session session) {
        if (session != null && session.isConnected()) {
            session.disconnect();
        }
    }

    public int getIndexerLocalPort() {
        return indexerLocalPort;
    }

    public int getManagerLocalPort() {
        return managerLocalPort;
    }
}
