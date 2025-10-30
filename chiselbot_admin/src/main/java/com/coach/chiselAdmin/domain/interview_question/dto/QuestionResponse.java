package com.coach.chiselAdmin.domain.interview_question.dto;

import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;
import lombok.Getter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

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
            this.adminName = question.getAdminId().getAdminName();
            this.questionText = question.getQuestionText();
            this.answerText = question.getAnswerText();
            this.createdAt = question.getCreatedAt();
            this.modifiedAt = question.getModifiedAt();
        }
    }

    @Getter
    public static class FindAll{
        private final Long questionId;
        private final String categoryName;
        private final String interviewLevel;
        private final String adminName;
        private final String questionText;
        private final String answerText;
        private final String createdAt;
        private final String modifiedAt;

        public FindAll(InterviewQuestion question) {
            this.questionId = question.getQuestionId();
            this.categoryName = question.getCategoryId().getName(); // InterviewCategory 엔티티의 필드명에 맞게 변경
            this.interviewLevel = question.getInterviewLevel().name();
            this.adminName = question.getAdminId().getAdminName();
            this.questionText = question.getQuestionText();
            this.answerText = question.getAnswerText();

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            // view에 띄우기 위해 포맷(yyyy-MM-dd HH:mm)
            this.createdAt = question.getCreatedAt() != null ? question.getCreatedAt().format(formatter) : null;
            this.modifiedAt = question.getModifiedAt() != null ? question.getModifiedAt().format(formatter) : null;
        }

        public static FindAll from(InterviewQuestion question){return new FindAll(question);}

        public static List<FindAll> from(List<InterviewQuestion> questions){
            List<FindAll> dtoList = new ArrayList<>();
            for(InterviewQuestion question : questions){
                dtoList.add(new FindAll(question));
            }
            return dtoList;
        }
    }
}
