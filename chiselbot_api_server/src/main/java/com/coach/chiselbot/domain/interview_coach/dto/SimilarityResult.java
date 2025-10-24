package com.coach.chiselbot.domain.interview_coach.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SimilarityResult {
    // 코사인 유사도 반환 DTO
    private double intentSimilarity; // LEVEL_1의 경우 answerSimilarity 용으로 사용
    private double pointSimilarity;
}
