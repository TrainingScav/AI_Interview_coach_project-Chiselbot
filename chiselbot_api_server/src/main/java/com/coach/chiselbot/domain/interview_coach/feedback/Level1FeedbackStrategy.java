package com.coach.chiselbot.domain.interview_coach.feedback;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import com.google.gson.Gson;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Level1FeedbackStrategy extends AbstractFeedbackStrategy {

    @Autowired
    public Level1FeedbackStrategy(OpenAiEmbeddingModel embeddingModel) {
        super(embeddingModel);
    }

    @Override
    public FeedbackResponse.SimilarityResult calculateSimilarity(String userAnswer, InterviewQuestion question) {
        Gson gson = new Gson();

        float[] userVec = embed(userAnswer);
        // DB에 저장된 vector(String) 값을 float[]로 변환 gson 사용
        float[] answerVec = gson.fromJson(question.getAnswerVector(), float[].class);

        double similarity = cosineSimilarity(userVec, answerVec);

        return new FeedbackResponse.SimilarityResult(similarity, 0.0);
    }


}
