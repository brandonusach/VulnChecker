package com.devsecops.vulncheckerbackend.dto;

/** Agrupa las credenciales necesarias para abrir el tunnel SSH y autenticarse en Wazuh. */
public record WazuhCredentials(
        String sshHost,
        String sshUser,
        String sshPassword,
        String wazuhUser,
        String wazuhPassword
) {}