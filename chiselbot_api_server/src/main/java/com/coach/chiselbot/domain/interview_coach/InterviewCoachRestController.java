package com.coach.chiselbot.domain.interview_coach;

import com.coach._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.interview_coach.dto.FeedbackRequest;
import com.coach.chiselbot.domain.interview_coach.dto.FeedbackResponse;
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
     * 사용자의 답변을 입력받아 AI 피드백을 생성.
     *
     * 요청 예시:
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
     *
     * @param request 사용자의 답변 요청 DTO (questionId, userAnswer)
     * @return AI 피드백 결과를 담은 ResponseEntity(응답 예시대로)
     */
    @PostMapping
    public ResponseEntity<?> getFeedback(@RequestBody FeedbackRequest.AnswerRequest request){
        FeedbackResponse.FeedbackResult result = interviewCoachService.getFeedback(request);

        return ResponseEntity.ok(CommonResponseDto.success(result));
    }

//    @PostMapping("/createQuestion")
//    public ResponseEntity<?> createQuestion(@RequestBody FeedbackRequest.CreateQuestion question){
//
//    }
}
