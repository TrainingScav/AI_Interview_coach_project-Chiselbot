package com.coach.chiselbot.domain.interview_coach;

import com.coach.chiselbot.domain.interview_coach.dto.SimilarityResult;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;

public interface FeedbackStrategy {
    SimilarityResult calculateSimilarity(String userAnswer, InterviewQuestion question);
}
