package com.coach.chiselAdmin.domain.admin.login;

import com.coach.chiselAdmin.domain.admin.Admin;
import com.coach.chiselAdmin.domain.admin.dto.AdminRequest;

public interface LoginStrategy {
    // 모든 로그인 전략은 login 메서드를 구현해야 한다.
    Admin login(AdminRequest.Login request);
    // 모든 로그인 전략은 자신이 어떤 타입인지 알려 줘야 한다.
    boolean supports(String type);
}
