package com.coach.chiselAdmin.domain.interview_coach;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmbeddingService {
    // Question을 저장할 때 intent, point, answer 값을 Embedding 처리 하기 위한 Service

    protected final OpenAiEmbeddingModel embeddingModel;

    public float[] embed(String text) {
        return embeddingModel.embed(text);
    }
}
