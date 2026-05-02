package com.devsecops.vulncheckerbackend.dto;

import java.util.List;

public record SnapshotEvolutionFiltersDto(
        List<String> agentIds,
        List<String> metrics,
        List<Integer> columnOptions
) {}
