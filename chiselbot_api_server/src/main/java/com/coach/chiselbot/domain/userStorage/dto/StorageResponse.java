package com.coach.chiselbot.domain.userStorage.dto;


import com.coach.chiselbot.domain.userStorage.UserStorage;
import lombok.Getter;

import java.time.LocalDateTime;

public class StorageResponse {

    @Getter
    public static class FindById {
        private final Long storageId;
        private final Long questionId;
        private final Long userId;
        private final String questionText;
        private final String userAnswer;
        private final String feedback;
        private final String hint;
        private final Double similarity;
        private final String interviewLevel;
        private final String categoryName;
        private final LocalDateTime createdAt;

        public FindById(UserStorage storage) {
            this.storageId = storage.getStorageId();
            this.questionId = storage.getQuestion().getQuestionId();
            this.userId = storage.getUser().getId();
            this.questionText = storage.getQuestion().getQuestionText();
            this.userAnswer = nvl(storage.getUserAnswer());
            this.feedback = nvl(storage.getFeedback());
            this.hint = nvl(storage.getHint());
            this.similarity = storage.getSimilarity();
            this.interviewLevel = storage.getQuestion().getInterviewLevel().name();
            this.categoryName = storage.getQuestion().getCategoryId().getName();
            this.createdAt = storage.getCreatedAt();
        }

        private String nvl(String value) {
            return value != null ? value : "";
        }
    }
}
