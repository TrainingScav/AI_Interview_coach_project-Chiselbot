package com.coach.chiselbot.domain.interview_question.dto;

import com.coach.chiselbot.domain.interview_question.InterviewLevel;
import lombok.Getter;
import lombok.Setter;

public class QuestionRequest {

    @Getter
    @Setter
    public static class CreateQuestion {
        private Long categoryId;
        private Long adminId;
        private InterviewLevel interviewLevel;
        private String questionText;
        private String intentText;
        private String pointText;
        private String intentVector;
        private String pointVector;
        private String answerText;
        private String answerVector;
    }

    @Getter
    @Setter
    public static class UpdateQuestion{
        private Long questionId;
        private Long categoryId;
        private Long adminId;
        private InterviewLevel interviewLevel;
        private String questionText;
        private String intentText;
        private String pointText;
        private String answerText;
    }
}
