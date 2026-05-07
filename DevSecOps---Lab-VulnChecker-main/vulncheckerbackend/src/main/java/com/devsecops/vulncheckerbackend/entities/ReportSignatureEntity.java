package com.devsecops.vulncheckerbackend.entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "report_signatures")
public class ReportSignatureEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "report_name")
    private String reportName;

    @Column(name = "sha256_hash", nullable = false, length = 64, unique = true)
    private String sha256Hash;

    @Column(name = "digital_signature", nullable = false, columnDefinition="TEXT")
    private String digitalSignature;

    @Column(name = "signed_at")
    private LocalDateTime signedAt;

    public ReportSignatureEntity() {

    }

    // Getters y Setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getReportName() {return reportName; }
    public void setReportName(String reportName) { this.reportName = reportName; }
    public String getSha256Hash() {return sha256Hash; }
    public void setSha256Hash(String sha256Hash) { this.sha256Hash = sha256Hash; }
    public String getDigitalSignature() {return digitalSignature; }
    public void setDigitalSignature(String digitalSignature) {this.digitalSignature = digitalSignature; }
    public LocalDateTime getSignedAt() {return signedAt; }
    public void setSignedAt(LocalDateTime signedAt) {this.signedAt = signedAt; }

}