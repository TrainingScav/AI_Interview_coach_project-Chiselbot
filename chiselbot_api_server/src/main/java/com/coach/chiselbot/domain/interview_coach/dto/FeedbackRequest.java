package com.coach.chiselbot.domain.interview_coach.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;


public class FeedbackRequest {

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class AnswerRequest {
        private Long questionId;
        private String userAnswer;
    }
}
