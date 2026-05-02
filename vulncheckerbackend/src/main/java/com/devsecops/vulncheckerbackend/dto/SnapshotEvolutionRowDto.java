package com.devsecops.vulncheckerbackend.dto;

import java.util.Map;

public record SnapshotEvolutionRowDto(
        String agentId,
        String agentName,
        int latestValue,
        Map<String, Integer> values
) {}
