package com.coach.chiselAdmin.domain.interview_coach.feedback;

import com.coach.chiselAdmin.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;

public interface FeedbackStrategy {
    FeedbackResponse.SimilarityResult calculateSimilarity(String userAnswer, InterviewQuestion question);
}
