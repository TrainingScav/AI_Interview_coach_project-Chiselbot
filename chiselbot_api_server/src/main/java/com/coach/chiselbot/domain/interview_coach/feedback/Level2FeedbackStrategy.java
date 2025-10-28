package com.coach.chiselbot.domain.interview_coach.feedback;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import com.google.gson.Gson;
import org.springframework.stereotype.Component;

@Component
public class Level2FeedbackStrategy extends AbstractFeedbackStrategy{

    @Override
    public FeedbackResponse.SimilarityResult calculateSimilarity(String userAnswer, InterviewQuestion question) {
        Gson gson = new Gson();

        float[] userVec = embed(userAnswer);

        float[] intentVec = gson.fromJson(question.getIntentVector(), float[].class);
        float[] pointVec = gson.fromJson(question.getPointVector(), float[].class);

        double intentSim = cosineSimilarity(userVec, intentVec);
        double pointSim = cosineSimilarity(userVec, pointVec);

        return new FeedbackResponse.SimilarityResult(intentSim, pointSim);
    }
}
