package com.coach.chiselAdmin.domain.interview_coach;

import com.coach.chiselAdmin.domain.interview_category.InterviewCategory;
import com.coach.chiselAdmin.domain.interview_category.InterviewCategoryRepository;
import com.coach.chiselAdmin.domain.interview_coach.dto.FeedbackRequest;
import com.coach.chiselAdmin.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselAdmin.domain.interview_coach.feedback.FeedbackStrategy;
import com.coach.chiselAdmin.domain.interview_coach.feedback.FeedbackStrategyFactory;
import com.coach.chiselAdmin.domain.interview_coach.prompt.PromptFactory;
import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestionRepository;
import com.coach.chiselAdmin.domain.interview_question.dto.QuestionRequest;
import com.coach.chiselAdmin.domain.interview_question.dto.QuestionResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class InterviewCoachService {

    private final FeedbackStrategyFactory feedbackStrategyFactory;
    private final PromptFactory promptFactory;
    private final ChatModel chatModel;
    private final ObjectMapper objectMapper; // json 변환용
    private final InterviewQuestionRepository questionRepository;
    private final InterviewCategoryRepository interviewCategoryRepository;
    private final EmbeddingService embeddingService;

    private final Gson gson = new Gson();

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
        FeedbackResponse.SimilarityResult similarity = feedbackStrategy.calculateSimilarity(feedbackRequest.getUserAnswer(), question);

        similarity = new FeedbackResponse.SimilarityResult(
                Double.parseDouble(String.format("%.2f", similarity.getIntentSimilarity())),
                similarity.getPointSimilarity());

        /**
         * 임시 값 대입
         * */
        //FeedbackResponse.SimilarityResult similarityResult = new FeedbackResponse.SimilarityResult(0.15, 0.0);

        // 2. 프롬프트 생성
        String prompt = promptFactory.createPrompt(question, feedbackRequest.getUserAnswer(), similarity);

        // 디버깅
        System.out.println("===== 프롬프트 생성 확인 =====");
        System.out.println("questionId: " + feedbackRequest.getQuestionId());
        System.out.println("questionText: " + question.getQuestionText());
        System.out.println("answerText: " + question.getAnswerText());
        System.out.println("userAnswer: " + feedbackRequest.getUserAnswer());
        System.out.println("similarity: " + similarity.getIntentSimilarity());
        System.out.println("생성된 프롬프트:\n" + prompt);
        System.out.println("================================");

        // 3. AI 모델 호출 - 응답 받기
        long startTime = System.currentTimeMillis();
        String aiAnswer = chatModel.call(prompt);
        long endTime = System.currentTimeMillis();

        // System.out.println("ai답변:" + aiAnswer);
        System.out.println("ChatGPT 응답 소요 시간: " + (endTime - startTime) + "ms"); // 네트워크 + AI응답속도

        // 4. JSON 문자열 형태 응답 -> DTO 변환
        FeedbackResponse.FeedbackResult result = null;
        try {
            result = objectMapper.readValue(aiAnswer, FeedbackResponse.FeedbackResult.class);
            result.setUserAnswer(feedbackRequest.getUserAnswer());
            result.setQuestionAnswer(question.getAnswerText());
            result.setQuestionId(question.getQuestionId());
            System.out.println("ai답변 파싱 result: " + result.toString());
        }catch (JsonProcessingException e){
            throw new RuntimeException("AI 응답 변환 실패: " + aiAnswer, e);
        }

        return result;
    }

    // Admin - 질문등록 기능
    public QuestionResponse.FindById createQuestion(QuestionRequest.CreateQuestion request){

        InterviewCategory category = interviewCategoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new NoSuchElementException("해당 ID의 카테고리를 찾을 수 없습니다"));
        // admin Entity 생성 시 admin 검증 로직 추가 예정
        InterviewQuestion newQuestion = new InterviewQuestion();

        newQuestion.setCategoryId(category);
        newQuestion.setAdminId(null);
        newQuestion.setQuestionText(request.getQuestionText());
        newQuestion.setInterviewLevel(request.getInterviewLevel());

        // Level 1 문제일 때, answer과 answerVector 저장
        if(request.getInterviewLevel() == InterviewLevel.LEVEL_1){
            newQuestion.setAnswerText(request.getAnswerText());

            if (request.getAnswerText() != null && !request.getAnswerText().isBlank()) {
                // 정답데이터 임베딩 후 gson 를 사용하여 Json 형태로 변환한 후 저장
                // 1. 임베딩
                float[] answerVector = embeddingService.embed(request.getAnswerText());
                // 2. gson 으로 String 형태의 Json 으로 변환
                String answerVectorJson = gson.toJson(answerVector);
                // 3. 저장
                newQuestion.setAnswerVector(answerVectorJson);
                questionRepository.save(newQuestion);
            }
        }
        // Level 2 이상일 때, intent, point와 각각의 Vector 값을 저장
        else{
            newQuestion.setIntentText(request.getIntentText());
            newQuestion.setPointText(request.getPointText());

            if (request.getIntentText() != null && !request.getIntentText().isBlank() &&
                request.getPointText() != null && !request.getPointText().isBlank()) {
                // intentVector 임베딩 후 저장
                float[] intentVector = embeddingService.embed(request.getIntentText());
                String intentVectorJson = gson.toJson(intentVector);
                newQuestion.setIntentVector(intentVectorJson);

                // pointVector 임베딩 후 저장
                float[] pointVector = embeddingService.embed(request.getPointText());
                String pointVectorJson = gson.toJson(pointVector);
                newQuestion.setPointVector(pointVectorJson);
                questionRepository.save(newQuestion);
            }
        }

        // 디버깅
        System.out.println("저장된 Question 객체 : " + newQuestion);
        return new QuestionResponse.FindById(newQuestion);
    }

}
