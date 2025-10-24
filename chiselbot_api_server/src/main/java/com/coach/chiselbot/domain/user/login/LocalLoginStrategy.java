package com.coach.chiselbot.domain.user.login;

import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import com.coach.chiselbot.domain.user.dto.UserRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class LocalLoginStrategy implements LoginStrategy{

    private final UserJpaRepository userJpaRepository;
    private final PasswordEncoder passwordEncoder;


    @Override
    public User login(UserRequestDTO.Login dto) {
        User user = userJpaRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("가입되지 않은 이메일입니다."));

        if(!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("잘못된 비밀번호 입니다");
        }

        return user;
    }

    @Override
    public boolean supports(String type) {
        return "Local".equalsIgnoreCase(type);
    }
}
