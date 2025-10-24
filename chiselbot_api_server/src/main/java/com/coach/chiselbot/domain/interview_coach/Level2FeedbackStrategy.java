package com.coach.chiselbot.domain.interview_coach;

import com.coach.chiselbot.domain.interview_coach.dto.SimilarityResult;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import com.google.gson.Gson;

public class Level2FeedbackStrategy extends AbstractFeedbackStrategy{

    @Override
    public SimilarityResult calculateSimilarity(String userAnswer, InterviewQuestion question) {
        Gson gson = new Gson();

        float[] userVec = embed(userAnswer);

        float[] intentVec = gson.fromJson(question.getIntentVector(), float[].class);
        float[] pointVec = gson.fromJson(question.getPointVector(), float[].class);

        double intentSim = cosineSimilarity(userVec, intentVec);
        double pointSim = cosineSimilarity(userVec, pointVec);

        return new SimilarityResult(intentSim, pointSim);
    }
}
