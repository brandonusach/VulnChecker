package com.devsecops.vulncheckerbackend.controllers;

import com.devsecops.vulncheckerbackend.entities.CredentialEntity;
import com.devsecops.vulncheckerbackend.repositories.UserRepository;
import com.devsecops.vulncheckerbackend.services.CredentialService;
import com.devsecops.vulncheckerbackend.support.TestDataFactory;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(CredentialController.class)
@AutoConfigureMockMvc(addFilters = false)
class CredentialControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private CredentialService credentialService;

    @MockitoBean
    private UserRepository userRepository;

    @MockitoBean
    private BCryptPasswordEncoder passwordEncoder;

    @Test
    void create_returnsSavedCredential() throws Exception {
        CredentialEntity credential = TestDataFactory.credential(1L, 7L);
        when(credentialService.save(any(CredentialEntity.class))).thenReturn(credential);

        mockMvc.perform(post("/api/credentials")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"id\":1,\"createdByUserId\":7,\"usernameCredentials\":\"wazuh-user\",\"passwordCredentials\":\"wazuh-pass\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.createdByUserId").value(7));
    }

    @Test
    void getByUser_returnsUserCredentials() throws Exception {
        when(credentialService.findByUserId(7L)).thenReturn(List.of(TestDataFactory.credential(1L, 7L)));

        mockMvc.perform(get("/api/credentials/user/7"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1));
    }

    @Test
    void delete_returnsNoContent() throws Exception {
        mockMvc.perform(delete("/api/credentials/9"))
                .andExpect(status().isNoContent());

        verify(credentialService).delete(9L);
    }
}
