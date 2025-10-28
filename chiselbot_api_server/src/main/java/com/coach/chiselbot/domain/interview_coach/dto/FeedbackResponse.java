package com.coach.chiselbot.domain.interview_coach.dto;

import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

public class FeedbackResponse {

    @Getter
    @AllArgsConstructor
    public static class SimilarityResult{
        // 코사인 유사도 반환 DTO
        private double intentSimilarity; // LEVEL_1의 경우 answerSimilarity 용으로 사용
        private double pointSimilarity;
    }

    @Getter
    @AllArgsConstructor
    @ToString
    @Setter
    public static class FeedbackResult{
        private Long questionId;
        private double similarity;
        private String feedback;
        private String hint;
        private String answer;
    }

    @Getter
    public static class FindById{
        private final Long questionId;
        private final String categoryName;
        private final String interviewLevel;
        private final String adminId;
        private final String questionText;
        private final String answerText;
        private final LocalDateTime createdAt;
        private final LocalDateTime modifiedAt;

        public FindById(InterviewQuestion question) {
            this.questionId = question.getQuestionId();
            this.categoryName = question.getCategoryId().getName(); // InterviewCategory 엔티티의 필드명에 맞게 변경
            this.interviewLevel = question.getInterviewLevel().name();
            this.adminId = question.getAdminId();
            this.questionText = question.getQuestionText();
            this.answerText = question.getAnswerText();
            this.createdAt = question.getCreatedAt();
            this.modifiedAt = question.getModifiedAt();
        }
    }

}
