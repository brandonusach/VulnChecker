package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.entities.ReportSignatureEntity;
import com.devsecops.vulncheckerbackend.repositories.UserRepository;
import com.devsecops.vulncheckerbackend.services.ReportSignatureService;
import com.devsecops.vulncheckerbackend.support.TestDataFactory;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ReportSignatureController.class)
@AutoConfigureMockMvc(addFilters = false)
class ReportSignatureControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ReportSignatureService reportSignatureService;

    @MockitoBean
    private UserRepository userRepository;

    @MockitoBean
    private BCryptPasswordEncoder passwordEncoder;

    @Test
    void signReportHash_returnsSuccessPayload() throws Exception {
        ReportSignatureEntity signed = TestDataFactory.reportSignature("hash", "signature-base64");
        when(reportSignatureService.signAndSaveReport(anyString(), anyString())).thenReturn(signed);

        mockMvc.perform(post("/api/reports/sign")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"reportName\":\"reporte\",\"sha256Hash\":\"hash\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("success"))
                .andExpect(jsonPath("$.signature").value("signature-base64"));
    }

    @Test
    void signReportHash_returnsInternalError_whenServiceFails() throws Exception {
        when(reportSignatureService.signAndSaveReport(anyString(), anyString())).thenThrow(new RuntimeException("firma fallida"));

        mockMvc.perform(post("/api/reports/sign")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"reportName\":\"reporte\",\"sha256Hash\":\"hash\"}"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.status").value("error"))
                .andExpect(jsonPath("$.message").value(org.hamcrest.Matchers.containsString("firma fallida")));
    }
}
