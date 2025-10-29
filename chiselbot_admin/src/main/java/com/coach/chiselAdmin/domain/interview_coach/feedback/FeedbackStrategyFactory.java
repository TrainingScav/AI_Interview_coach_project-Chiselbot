package com.coach.chiselAdmin.domain.interview_coach.feedback;

import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class FeedbackStrategyFactory {
    private final Level1FeedbackStrategy level_1;
    private final Level2FeedbackStrategy level_2;

    public FeedbackStrategy getStrategy(InterviewLevel level){
        return switch (level){
            case LEVEL_1 -> level_1;
            case LEVEL_2 -> level_2;
            default -> throw new IllegalArgumentException("지원하지 않는 레벨 입니다: " + level);
        };
    }


}
