package com.devsecops.vulncheckerbackend.dto;

public class ReportSignatureRequest {
    private String reportName;
    private String sha256Hash;

    // Getters y Setters
    public String getReportName() { return reportName; }
    public void setReportName(String reportName) { this.reportName = reportName; }
    
    public String getSha256Hash() { return sha256Hash; }
    public void setSha256Hash(String sha256Hash) { this.sha256Hash = sha256Hash; }
}