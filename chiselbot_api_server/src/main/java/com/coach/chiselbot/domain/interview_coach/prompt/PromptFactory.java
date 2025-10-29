package com.coach.chiselbot.domain.interview_coach.prompt;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class PromptFactory {

    // PromptStrategy 구현한 객체 자동 수집 @component 붙어있는 것들만
    private final List<PromptStrategy> promptStrategies;

    public String createPrompt(InterviewQuestion question,
                                            String userAnswer,
                                            FeedbackResponse.SimilarityResult similarity){

        PromptStrategy matchedStrategy = null;

        for(PromptStrategy strategy : promptStrategies){
            if(strategy.getLevel() == question.getInterviewLevel()){
                matchedStrategy = strategy;

                break;
            }
        }
        if(matchedStrategy == null){
            throw new IllegalArgumentException("존재하지 않는 Level입니다:" + question.getInterviewLevel());
        }

        log.info("선택된 프롬프트 전략: {}", matchedStrategy.getClass().getSimpleName());
        return matchedStrategy.buildPrompt(question, userAnswer, similarity);
    }

}
