package com.coach.chiselAdmin.domain.interview_coach.prompt;


import com.coach.chiselAdmin.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;
import org.springframework.stereotype.Component;

@Component
public class Level2PromptStrategy implements PromptStrategy{
    @Override
    public String buildPrompt(InterviewQuestion question, String userAnswer, FeedbackResponse.SimilarityResult similarity) {
        return "level2 프롬프트";
    }

    @Override
    public InterviewLevel getLevel() {
        return InterviewLevel.LEVEL_2;
    }

}
