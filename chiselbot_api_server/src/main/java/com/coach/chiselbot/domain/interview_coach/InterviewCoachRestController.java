package com.coach.chiselbot.domain.interview_coach;

import com.coach._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.interview_coach.dto.FeedbackRequest;
import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
import com.coach.chiselbot.domain.interview_question.dto.QuestionRequest;
import com.coach.chiselbot.domain.interview_question.dto.QuestionResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/interview/coach")
public class InterviewCoachRestController {

    private final InterviewCoachService interviewCoachService;


    /**
     * <p>사용자의 답변을 입력받아 AI 피드백을 생성.</p>
     *
     * 요청 예시:
     * <pre><code class="json">
     * {
     *   "questionId": 1,
     *   "userAnswer": "TCP는 연결 기반의 통신 프로토콜입니다."
     * }
     *
     * 응답 예시:
     * {
     *   "success": true,
     *   "data": {
     *     "feedback": "핵심은 잘 짚었지만 TCP의 신뢰성 보장 부분을 보충하세요.",
     *     "hint": "TCP는 데이터 전송 순서를 보장한다는 점을 떠올려보세요.", -- 힌트는 유사도값 0.8이하만 출력 됨
     *     "userAnswer": "" -- 사용자가 입력한 정답
     *     "questionAnswer": "" -- db에 저장된 질문의 답(LEVEL 1만 해당)
     *     "questionId":  -- 출력용 X, 보관함 저장용
     *     "similarity" :  -- 필요할수도있어서 넣음 아직은 출력용 X
     *   }
     * }
     * </code></pre>
     * @param request 사용자의 답변 요청 DTO (questionId, userAnswer)
     * @return AI 피드백 결과를 담은 ResponseEntity(응답 예시대로)
     */
    @PostMapping
    public ResponseEntity<?> getFeedback(@RequestBody FeedbackRequest.AnswerRequest request){
        FeedbackResponse.FeedbackResult result = interviewCoachService.getFeedback(request);

        return ResponseEntity.ok(CommonResponseDto.success(result));
    }

    /**
     * 면접 질문을 새로 등록하는 API.
     *
     * <p>관리자(Admin)가 InterviewQuestion을 생성할 때 사용합니다.</p>
     *
     * <pre><code class="json">
     * 요청 예시(필수 요청 항목):
     * {
     *   "categoryId": 2,
     *   "interviewLevel": "LEVEL_1",
     *   "questionText": "TCP는 무엇인가요?",
     *   "adminId": 1
     * }
     *
     * - LEVEL_1인 경우: answerText 및 answerVector가 함께 저장됩니다.
     * - LEVEL_2 이상인 경우: intentText, pointText 및 각각의 벡터 값이 저장됩니다.
     * </code></pre>
     *
     * <pre><code class="json">
     * 응답 예시:
     * {
     *   "success": true,
     *   "data": {
     *     "questionId": 10,
     *     "categoryId": 2,
     *     "questionText": "TCP는 무엇인가요?",
     *     "answerText": "TCP는 연결 지향적이며 신뢰성 있는 데이터 전송을 제공하는 프로토콜입니다.",
     *     "interviewLevel": "LEVEL_1",
     *     "intentText": null,
     *     "pointText": null
     *   },
     *   "message": "Question 저장 성공"
     * }
     * </code></pre>
     * @param request 새로 등록할 질문 데이터 DTO (categoryId, interviewLevel, questionText, answerText 등)
     * @return 생성된 InterviewQuestion 정보를 담은 ResponseEntity(JSON 형식)
     */
    @PostMapping("/createQuestion")
    public ResponseEntity<?> createQuestion(@RequestBody QuestionRequest.CreateQuestion request){
        QuestionResponse.FindById createdQuestion = interviewCoachService.createQuestion(request);

        return ResponseEntity.ok(CommonResponseDto.success(createdQuestion, "Question 저장 성공"));
    }
}
