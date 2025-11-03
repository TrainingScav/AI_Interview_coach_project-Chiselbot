package com.coach.chiselbot.domain.answer.dto;

import com.coach.chiselbot.domain.answer.Answer;
import lombok.Builder;
import lombok.Getter;

public class AnswerResponseDTO {

    @Getter
    @Builder
    public static class UpdateForm {
        private Long answerId;
        private Long inquiryId;
        private String inquiryTitle;
        private String content;

        public static UpdateForm from(Answer answer) {
            return UpdateForm.builder()
                    .answerId(answer.getId())
                    .inquiryId(answer.getInquiry().getId())
                    .inquiryTitle(answer.getInquiry().getTitle())
                    .content(answer.getContent())
                    .build();
        }
    }
}
