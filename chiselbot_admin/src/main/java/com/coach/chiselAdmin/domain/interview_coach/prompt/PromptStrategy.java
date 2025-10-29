package com.coach.chiselAdmin.domain.interview_coach.prompt;


import com.coach.chiselAdmin.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;

public interface PromptStrategy {
    String buildPrompt(InterviewQuestion question, String userAnswer, FeedbackResponse.SimilarityResult similarity);
    InterviewLevel getLevel();
}
