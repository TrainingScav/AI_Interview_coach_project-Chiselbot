package com.coach.chiselbot.domain.interview_coach.feedback;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;

public interface FeedbackStrategy {
    FeedbackResponse.SimilarityResult calculateSimilarity(String userAnswer, InterviewQuestion question);
}
