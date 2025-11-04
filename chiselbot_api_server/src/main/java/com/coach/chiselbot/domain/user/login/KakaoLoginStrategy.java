package com.coach.chiselbot.domain.user.login;

import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import com.coach.chiselbot.domain.user.dto.UserRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class KakaoLoginStrategy implements LoginStrategy {

    private final UserJpaRepository userJpaRepository;

    @Override
    public User login(UserRequestDTO.Login dto) {
        return null;
    }

    @Override
    public boolean supports(String type) {
        return "kakao".equalsIgnoreCase(type);
    }
}
