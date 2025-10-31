package com.coach.chiselbot.domain.Inquiry.dto;

import com.coach.chiselbot.domain.Inquiry.Inquiry;
import com.coach.chiselbot.domain.Inquiry.InquiryStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

public class InquiryResponseDTO {

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ListDTO {
        private Long inquiryId;
        private String title;
        private InquiryStatus status;
        private String author;
        private Timestamp createdAt;

        public static ListDTO from(Inquiry inquiry) {
            return ListDTO.builder()
                    .inquiryId(inquiry.getId())
                    .title(inquiry.getTitle())
                    .status(inquiry.getStatus())
                    .author(inquiry.getUser().getName())
                    .createdAt(inquiry.getCreatedAt())
                    .build();
        }
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DetailDTO {
        private Long inquiryId;
        private String title;
        private String content;
        private InquiryStatus status;
        private String author;
        private String adminName;
        private Timestamp createdAt;
        // 추가
        private Long userId;
        private Long adminId;
        private String answerContent;
        private Timestamp answeredAt;
        private Timestamp updatedAt;

        public static DetailDTO from(Inquiry inquiry) {
            return DetailDTO.builder()
                    .inquiryId(inquiry.getId())
                    .title(inquiry.getTitle())
                    .content(inquiry.getContent())
                    .status(inquiry.getStatus())
                    .createdAt(inquiry.getCreatedAt())
                    // 추가
                    .userId(inquiry.getUser() != null ? inquiry.getUser().getId() : null)
                    .adminId(inquiry.getAdmin() != null ? inquiry.getAdmin().getId() : null)
                    .answerContent(inquiry.getAnswerContent())
                    .answeredAt(inquiry.getAnsweredAt())
                    .updatedAt(inquiry.getUpdatedAt())
                    .author(inquiry.getUser() != null ? inquiry.getUser().getName() : null)
                    .adminName(inquiry.getAdmin() != null ? inquiry.getAdmin().getName() : null)
                    .build();
        }
    }
}
