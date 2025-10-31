package com.coach.chiselbot.domain.userStorage;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.userStorage.dto.StorageRequest;
import com.coach.chiselbot.domain.userStorage.dto.StorageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/storages")
@RequiredArgsConstructor
public class UserStorageRestController {

    private final UserStorageService storageService;

    /**
     * <p>AI 피드백 결과를 사용자의 보관함에 저장합니다.</p>
     *
     * <pre><code class="json">
     * 요청 예시:
     * {
     *   "userId": 1,                     // (테스트용) JWT 인증 시 실제로는 무시됨
     *   "questionId": 5,                 // 저장할 질문 ID
     *   "userAnswer": "TCP는 연결 기반의 프로토콜입니다.",
     *   "similarity": 0.82,              // AI 계산 유사도 (선택)
     *   "feedback": "핵심 개념은 맞지만, 신뢰성 언급이 빠졌습니다.",
     *   "hint": "TCP는 순서 보장과 재전송 기능을 제공합니다."
     * }
     * </code></pre>
     *
     * <pre><code class="json">
     * 응답 예시:
     * {
     *   "success": true,
     *   "data": {
     *     "storageId": 12,
     *     "questionId": 5,
     *     "questionText": "TCP는 무엇인가요?",
     *     "userAnswer": "TCP는 연결 기반의 프로토콜입니다.",
     *     "feedback": "핵심 개념은 맞지만, 신뢰성 언급이 빠졌습니다.",
     *     "hint": "TCP는 순서 보장과 재전송 기능을 제공합니다.",
     *     "similarity": 0.82,
     *     "interviewLevel": "LEVEL_1",
     *     "categoryName": "네트워크",
     *     "createdAt": "2025-10-31T13:20:45"
     *   },
     *   "message": "SUCCESS"
     * }
     * </code></pre>
     *
     * <p><b>규칙:</b></p>
     * <ul>
     *   <li>JWT 토큰의 userEmail로 로그인된 유저를 식별합니다.</li>
     *   <li>같은 질문(questionId)이라도 여러 번 저장 가능합니다.</li>
     *   <li>유저당 최대 10개까지만 저장 가능 (추후 제한 적용 가능).</li>
     * </ul>
     *
     * @param request   보관함 저장 요청 DTO (questionId, userAnswer, feedback, hint 등)
     * @param userEmail JWT에서 추출된 로그인 사용자 이메일
     * @return 저장된 보관함 데이터(StorageResponse.FindById)를 포함한 공통 응답
     */
    @PostMapping("/storage/save")
    public ResponseEntity<?> saveStorage(@RequestBody StorageRequest.SaveRequest request,
                                         @RequestAttribute("userEmail") String userEmail){


        StorageResponse.FindById response = storageService.saveStorage(request, userEmail);

        return ResponseEntity.ok(CommonResponseDto.success(response, Define.SUCCESS));
    }

}
