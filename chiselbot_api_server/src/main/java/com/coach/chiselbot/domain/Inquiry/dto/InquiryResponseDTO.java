package com.coach.chiselbot.domain.Inquiry.dto;

import com.coach.chiselbot.domain.Inquiry.Inquiry;
import com.coach.chiselbot.domain.Inquiry.InquiryStatus;
import lombok.*;

import java.time.LocalDateTime;

public class InquiryResponseDTO {

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInquiryList {
        private Long inquiryId;
        private String title;
        private InquiryStatus status;
        private String author;
        private LocalDateTime createdAt;

        public static UserInquiryList from(Inquiry inquiry) {
            return UserInquiryList.builder()
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
    public static class AdminInquiryList {
        private Long inquiryId;
        private String title;
        private String userName;
        private InquiryStatus status;
        private LocalDateTime createdAt;
        private LocalDateTime answeredAt;

        public static AdminInquiryList from(Inquiry inquiry) {
            return AdminInquiryList.builder()
                    .inquiryId(inquiry.getId())
                    .title(inquiry.getTitle())
                    .userName(inquiry.getUser().getName())
                    .status(inquiry.getStatus())
                    .createdAt(inquiry.getCreatedAt())
                    .answeredAt(inquiry.getAnswer().getCreatedAt())
                    .build();
        }
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInquiryDetail {
        private Long inquiryId;
        private String title;
        private String content;
        private InquiryStatus status;
        private String author;
        private LocalDateTime createdAt;
        // 추가
        private Long userId;
        private String answerContent;
        private LocalDateTime answeredAt;
        private LocalDateTime updatedAt;

        public static UserInquiryDetail from(Inquiry inquiry) {
            return UserInquiryDetail.builder()
                    .inquiryId(inquiry.getId())
                    .title(inquiry.getTitle())
                    .content(inquiry.getContent())
                    .status(inquiry.getStatus())
                    .createdAt(inquiry.getCreatedAt())
                    // 추가
                    .userId(inquiry.getUser() != null ? inquiry.getUser().getId() : null)
                    .answerContent(inquiry.getAnswer().getContent())
                    .answeredAt(inquiry.getAnswer().getCreatedAt())
                    .updatedAt(inquiry.getModifiedAt())
                    .author(inquiry.getUser() != null ? inquiry.getUser().getName() : null)
                    .build();
        }
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AdminInquiryDetail {
        private Long inquiryId;
        private String title;
        private InquiryStatus status;
        private String userName;
        private String answerContent;
        private LocalDateTime createdAt;
        private LocalDateTime answeredAt;
        private LocalDateTime modifiedAt;

        public static AdminInquiryDetail from(Inquiry inquiry) {
            return AdminInquiryDetail.builder()
                    .inquiryId(inquiry.getId())
                    .title(inquiry.getTitle())
                    .status(inquiry.getStatus())
                    .userName(inquiry.getUser().getName())
                    .answerContent(inquiry.getAnswer().getContent())
                    .createdAt(inquiry.getCreatedAt())
                    .answeredAt(inquiry.getAnswer().getModifiedAt())
                    .build();
        }
    }
}
