package com.coach.chiselbot.domain.user;

import com.coach._global.config.jwt.JwtTokenProvider;
import com.coach._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.user.dto.UserRequestDTO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/users")
@RestController
@RequiredArgsConstructor
public class UserRestController {

    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

    // 회원가입

    @PostMapping("/signup")
    public ResponseEntity<CommonResponseDto<?>> signup(@Valid @RequestBody UserRequestDTO.SignUp dto) {

        userService.signUp(dto);
        return ResponseEntity.ok(CommonResponseDto.success(null, "회원가입이 완료되었습니다"));
    }

    // 로그인

    @PostMapping("/login/{type}")
    public ResponseEntity<CommonResponseDto<?>> login(@PathVariable String type,
                                                      @Valid @RequestBody UserRequestDTO.Login dto) {
        User user = userService.login(type, dto);

        String token = jwtTokenProvider.createToken(user);
        return ResponseEntity.ok(CommonResponseDto.success(token, "로그인에 성공했습니다"));

    }

    // 회원수정

    @PatchMapping("/update")
    public ResponseEntity<CommonResponseDto<?>> updateMe(
            @RequestAttribute("userEmail") String userEmail,
            @Valid @RequestBody UserRequestDTO.Update dto
    ) {
        userService.update(userEmail, dto);
        return ResponseEntity.ok(CommonResponseDto.success(null, "수정되었습니다."));
    }


    // 로그아웃
    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        return ResponseEntity.ok(CommonResponseDto.success(null,"로그아웃 되었습니다"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<CommonResponseDto<?>> findOne(@PathVariable String userEmail) {
        return ResponseEntity.ok(CommonResponseDto.success(userService.findOne(userEmail), "조회되었습니다."));
    }

}