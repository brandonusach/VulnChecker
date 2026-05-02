package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.ReportSignatureEntity;
import com.devsecops.vulncheckerbackend.repositories.ReportSignatureRepository;
import org.springframework.stereotype.Service;

import java.security.*;
import java.util.Base64;
import java.time.LocalDateTime;

@Service
public class ReportSignatureService {

    private final ReportSignatureRepository reportSignatureRepository;
    private final PrivateKey privateKey;
    private final PublicKey publicKey;

    public ReportSignatureService(ReportSignatureRepository reportSignatureRepository) throws NoSuchAlgorithmException {
        this.reportSignatureRepository = reportSignatureRepository;
        
        // Generación de par de claves RSA
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair pair = keyGen.generateKeyPair();
        this.privateKey = pair.getPrivate();
        this.publicKey = pair.getPublic();
    }

    public ReportSignatureEntity signAndSaveReport(String reportName, String sha256Hash) throws Exception {
        // Configurar el motor de firma
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initSign(privateKey);
        
        // Firmar el hash recibido
        signature.update(sha256Hash.getBytes());
        byte[] signedBytes = signature.sign();
        String digitalSignatureBase64 = Base64.getEncoder().encodeToString(signedBytes);

        // Crear la entidad para la base de datos
        ReportSignatureEntity reportSignatureEntity = new ReportSignatureEntity();
        reportSignatureEntity.setReportName(reportName);
        reportSignatureEntity.setSha256Hash(sha256Hash);
        reportSignatureEntity.setDigitalSignature(digitalSignatureBase64);
        reportSignatureEntity.setSignedAt(LocalDateTime.now());

        
        return reportSignatureRepository.save(reportSignatureEntity); 
    }
}