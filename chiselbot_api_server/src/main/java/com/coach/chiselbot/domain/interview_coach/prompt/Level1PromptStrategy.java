package com.coach.chiselbot.domain.interview_coach.prompt;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.InterviewLevel;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import org.springframework.stereotype.Component;

@Component
public class Level1PromptStrategy implements PromptStrategy{

    @Override
    public String buildPrompt(InterviewQuestion question, String userAnswer, FeedbackResponse.SimilarityResult similarity) {
        return """
            너는 기술 면접 코치이다.
            아래의 문제, 사용자의 답변, 정답, 그리고 유사도 점수를 보고
            JSON 형식으로 간결한 피드백을 작성하라.

            규칙:
            1. 출력은 반드시 JSON 형식으로 해야 한다.
            2. 항상 아래 다섯 개의 필드를 모두 포함하라:
                - "feedback": 사용자의 답변에 대한 한두 문장의 평가
                - "hint": 유사도(similarity)가 0.8 미만일 때만 간단한 힌트를 작성하고, 그 이상일 때는 빈 문자열로 남긴다.
                - "answer": 항상 포함하지만, 내용은 비워둔다. (실제 정답은 시스템이 채워 넣는다.)
                - "questionId": 항상 출력, 입력받은 questionId 값 그대로 출력.
                - "similarity": 항상 출력, 입력받은 유사도 값 그대로 출력.
            3. 피드백은 간결하고 자연스러운 한글 문장으로 작성한다.
            4. 유사도(similarity)가 높을수록 칭찬 위주로, 낮을수록 보완점 위주로 작성한다.
            5. 불필요한 설명, JSON 밖의 문장은 절대 포함하지 마라.

            ---
            문제: %s
            정답: %s
            사용자 답변: %s
            유사도: %.2f
            questionId: %s
            ---
            JSON:
            """.formatted(
                question.getQuestionText(),
                question.getAnswerText(),
                userAnswer,
                similarity.getIntentSimilarity(),
                question.getQuestionId()
        );
    }

    @Override
    public InterviewLevel getLevel() {
        return InterviewLevel.LEVEL_1;
    }
}
