package com.coach.chiselbot.domain.interview_coach;

import com.coach.chiselbot.domain.interview_coach.dto.FeedbackRequest;
import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_coach.feedback.FeedbackStrategy;
import com.coach.chiselbot.domain.interview_coach.feedback.FeedbackStrategyFactory;
import com.coach.chiselbot.domain.interview_coach.prompt.PromptFactory;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import com.coach.chiselbot.domain.interview_question.InterviewQuestionRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class InterviewCoachService {

    private final FeedbackStrategyFactory feedbackStrategyFactory;
    private final PromptFactory promptFactory;
    private final ChatModel chatModel;
    private final ObjectMapper objectMapper; // json 변환용
    private final InterviewQuestionRepository questionRepository;

    public FeedbackResponse.FeedbackResult getFeedback(FeedbackRequest.AnswerRequest feedbackRequest){

        InterviewQuestion question = questionRepository.findById(feedbackRequest.getQuestionId())
                .orElseThrow(() -> new NoSuchFieldError("해당 질문을 찾을 수 없습니다"));


        // 디버깅
        System.out.println("조회된 질문: " + question);
        System.out.println("문제 텍스트: " + question.getQuestionText());
        System.out.println("정답 텍스트: " + question.getAnswerText());

        // 1. 유사도 계산
        FeedbackStrategy feedbackStrategy =
                feedbackStrategyFactory.getStrategy(question.getInterviewLevel());
        /**
         * 질문등록 기능 완료 시 유사도 계산식 복구
         * */
        //FeedbackResponse.SimilarityResult similarity = feedbackStrategy.calculateSimilarity(feedbackRequest.getUserAnswer(), question);

        /**
         * 임시 값 대입
         * */
        FeedbackResponse.SimilarityResult similarityResult = new FeedbackResponse.SimilarityResult(0.93, 0.0);

        // 2. 프롬프트 생성
        String prompt = promptFactory.createPrompt(question, feedbackRequest.getUserAnswer(), similarityResult);

        // 디버깅
        System.out.println("===== 프롬프트 생성 확인 =====");
        System.out.println("questionId: " + feedbackRequest.getQuestionId());
        System.out.println("questionText: " + question.getQuestionText());
        System.out.println("answerText: " + question.getAnswerText());
        System.out.println("userAnswer: " + feedbackRequest.getUserAnswer());
        System.out.println("similarity: " + similarityResult.getIntentSimilarity());
        System.out.println("생성된 프롬프트:\n" + prompt);
        System.out.println("================================");

        // 3. AI 모델 호출 - 응답 받기
        String aiAnswer = chatModel.call(prompt);
        System.out.println("ai답변:" + aiAnswer);

        // 4. JSON 문자열 형태 응답 -> DTO 변환
        FeedbackResponse.FeedbackResult result = null;
        try {
            result = objectMapper.readValue(aiAnswer, FeedbackResponse.FeedbackResult.class);
            result.setAnswer(feedbackRequest.getUserAnswer());
            System.out.println("ai답변 파싱 result: " + result.toString());
        }catch (JsonProcessingException e){
            throw new RuntimeException("AI 응답 변환 실패: " + aiAnswer, e);
        }

        return result;
    }

}
