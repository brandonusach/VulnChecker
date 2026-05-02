package com.devsecops.vulncheckerbackend.entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "credentials")
public class CredentialEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "created_by_user_id", nullable = false)
    private Long createdByUserId; // El ID del usuario que la registró

    @Column(nullable = false)
    private String usernameCredentials;

    @Column(nullable = false)
    private String passwordCredentials;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public CredentialEntity() {
        // Constructor vacío requerido por JPA
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getCreatedByUserId() { return createdByUserId; }
    public void setCreatedByUserId(Long createdByUserId) { this.createdByUserId = createdByUserId; }

    public String getUsernameCredentials() { return usernameCredentials; }
    public void setUsernameCredentials(String usernameCredentials) { this.usernameCredentials = usernameCredentials; }

    public String getPasswordCredentials() { return passwordCredentials; }
    public void setPasswordCredentials(String passwordCredentials) { this.passwordCredentials = passwordCredentials; }

    public LocalDateTime getCreatedAt() { return createdAt; }
}