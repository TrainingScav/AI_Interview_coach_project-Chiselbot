package com.coach.chiselAdmin.domain.interview_question.dto;


import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import lombok.Getter;
import lombok.Setter;

public class QuestionRequest {

    @Getter
    @Setter
    public static class CreateQuestion{
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
}
