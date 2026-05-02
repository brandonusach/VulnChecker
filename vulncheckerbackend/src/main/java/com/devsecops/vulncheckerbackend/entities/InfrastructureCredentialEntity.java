package com.devsecops.vulncheckerbackend.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "infrastructure_credentials")
public class InfrastructureCredentialEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name; // Ej: "Laboratorio Ethical Hacking"

    // Credenciales SSH
    @Column(name = "ssh_user")
    private String sshUser;

    @Column(name = "ssh_password")
    private String sshPassword;

    // Credenciales Wazuh API
    @Column(name = "wazuh_user")
    private String wazuhUser;

    @Column(name = "wazuh_password")
    private String wazuhPassword;

    @Column(name = "user_id", nullable = false)
    private Long userId; 

    public InfrastructureCredentialEntity() {
        // Constructor vacío requerido por JPA
    }
    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSshUser() { return sshUser; }
    public void setSshUser(String sshUser) { this.sshUser = sshUser; }
    public String getSshPassword() { return sshPassword; }
    public void setSshPassword(String sshPassword) { this.sshPassword = sshPassword; }
    public String getWazuhUser() { return wazuhUser; }
    public void setWazuhUser(String wazuhUser) { this.wazuhUser = wazuhUser; }
    public String getWazuhPassword() { return wazuhPassword; }
    public void setWazuhPassword(String wazuhPassword) { this.wazuhPassword = wazuhPassword; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
}