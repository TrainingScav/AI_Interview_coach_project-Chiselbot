package com.coach.chiselbot.domain.Inquiry.dto;


import lombok.*;

public class InquiryRequestDTO {

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Create {
        private String title;
        private String content;
        private Long authorId;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Update {
        private String title;
        private String content;
    }

}
