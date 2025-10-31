package com.coach.chiselbot.domain.answer.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

public class AnswerRequestDTO {

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Create {
        private String content;
    }

}
