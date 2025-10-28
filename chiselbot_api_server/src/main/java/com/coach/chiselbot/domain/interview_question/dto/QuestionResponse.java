package com.coach.chiselbot.domain.interview_question.dto;

import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import lombok.Getter;

import java.time.LocalDateTime;

public class QuestionResponse {

    @Getter
    public static class FindById{
        private final Long questionId;
        private final String categoryName;
        private final String interviewLevel;
        private final String adminName;
        private final String questionText;
        private final String answerText;
        private final LocalDateTime createdAt;
        private final LocalDateTime modifiedAt;

        public FindById(InterviewQuestion question) {
            this.questionId = question.getQuestionId();
            this.categoryName = question.getCategoryId().getName(); // InterviewCategory 엔티티의 필드명에 맞게 변경
            this.interviewLevel = question.getInterviewLevel().name();
            this.adminName = question.getAdminId(); // admin 생기면 Name 으로 변경
            this.questionText = question.getQuestionText();
            this.answerText = question.getAnswerText();
            this.createdAt = question.getCreatedAt();
            this.modifiedAt = question.getModifiedAt();
        }
    }
}
