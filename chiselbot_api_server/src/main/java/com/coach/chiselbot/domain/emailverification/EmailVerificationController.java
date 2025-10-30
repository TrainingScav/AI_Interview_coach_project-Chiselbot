package com.coach.chiselbot.domain.emailverification;

import com.coach.chiselbot._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class EmailVerificationController {

    private final EmailVerificationService service;
    private final UserJpaRepository userJpaRepository;


    @PostMapping("/email/send")
    public ResponseEntity<CommonResponseDto<?>> send(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(CommonResponseDto.error("이메일을 입력하세요."));
        }
        String normalized = email.trim().toLowerCase();
        if (userJpaRepository.existsByEmail(normalized)) {

            return ResponseEntity.status(409).body(CommonResponseDto.error("이미 가입된 이메일입니다."));
        }
        service.sendCode(normalized);
        return ResponseEntity.ok(CommonResponseDto.success(null, "인증 코드가 전송되었습니다."));
    }

    @PostMapping("/email/verify")
    public ResponseEntity<CommonResponseDto<?>> verify(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String code = body.get("code");
        if (email == null || code == null) {
            return ResponseEntity.badRequest().body(CommonResponseDto.error("이메일/코드를 입력하세요."));
        }
        boolean ok = service.verifyCode(email, code);
        if (!ok) {
            return ResponseEntity.badRequest().body(CommonResponseDto.error("인증에 실패했습니다."));
        }
        return ResponseEntity.ok(CommonResponseDto.success(null, "인증되었습니다."));
    }
}
