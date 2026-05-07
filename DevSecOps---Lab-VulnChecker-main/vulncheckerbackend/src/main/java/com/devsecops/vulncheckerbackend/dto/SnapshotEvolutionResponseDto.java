package com.devsecops.vulncheckerbackend.dto;

import java.util.List;

public record SnapshotEvolutionResponseDto(
        List<SnapshotEvolutionColumnDto> columns,
        List<SnapshotEvolutionRowDto> content,
        long totalElements,
        int totalPages,
        int page,
        int size,
        String metric
) {}
