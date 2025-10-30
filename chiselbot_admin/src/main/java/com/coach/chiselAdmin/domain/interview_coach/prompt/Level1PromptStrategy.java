package com.coach.chiselAdmin.domain.interview_coach.prompt;

import com.coach.chiselAdmin.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;
import org.springframework.stereotype.Component;

@Component
public class Level1PromptStrategy implements PromptStrategy{

    @Override
    public String buildPrompt(InterviewQuestion question, String userAnswer, FeedbackResponse.SimilarityResult similarity) {
        return """
            너는 기술 면접 코치이다.
            아래의 문제, 사용자의 답변, 코사인유사도 점수를 보고
            JSON 형식으로 간결한 피드백을 작성하라.

            규칙:
            1. 출력은 반드시 JSON 형식으로 해야 한다.
            2. 항상 아래 다섯 개의 필드를 모두 포함하라:
                - "feedback": 사용자의 답변에 대한 간결한 한문장 평가
                - "hint": similarity < 0.8 일때만 작성, 엄청 짧은 한문장 힌트문구
                - "userAnswer": 내용은 비워둔다
                - "questionId": 내용은 비워둔다
                - "similarity": 입력받은 유사도 값 그대로 출력.
            3. 유사도(similarity)가 높을수록 칭찬 위주로, 낮을수록 보완점 위주로 작성한다.
            4. 불필요한 설명, JSON 밖의 문장은 절대 포함하지 마라.
            5. "feedback"과 "hint" 문장은 모두 **'~요'로 끝나는 공손한 해요체 말투**로 작성한다.

            ---
            문제: %s
            사용자의 답변: %s
            코사인유사도: %.2f
            ---
            JSON:
            """.formatted(
                question.getQuestionText(),
                userAnswer,
                similarity.getIntentSimilarity()
        );
    }

    @Override
    public InterviewLevel getLevel() {
        return InterviewLevel.LEVEL_1;
    }
}
