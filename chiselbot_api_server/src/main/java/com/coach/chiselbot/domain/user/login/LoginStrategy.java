package com.coach.chiselbot.domain.user.login;

import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.service.dto.UserRequestDTO;

public interface LoginStrategy {
    User login(UserRequestDTO.Login dto);

    boolean supports(String type);
}
