package com.coach.chiselbot.domain.interview_coach.prompt;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.InterviewLevel;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;

public interface PromptStrategy {
    String buildPrompt(InterviewQuestion question, String userAnswer, FeedbackResponse.SimilarityResult similarity);

    InterviewLevel getLevel();
}
