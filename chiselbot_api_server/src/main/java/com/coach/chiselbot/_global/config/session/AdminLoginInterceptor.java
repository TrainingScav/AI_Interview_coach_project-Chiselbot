package com.coach.chiselbot._global.config.session;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot._global.config.jwt.JwtTokenProvider;
import com.coach.chiselbot._global.errors.adminException.AdminException401;
import com.coach.chiselbot._global.errors.exception.Exception401;
import com.coach.chiselbot.domain.admin.Admin;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class AdminLoginInterceptor implements HandlerInterceptor {


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession();
        System.out.println("인터셉터 동작 확인 : " + request.getRequestURL());
        Admin sessionUser = (Admin)session.getAttribute(Define.SESSION_USER);
        if(sessionUser == null) {
            throw new AdminException401("로그인 먼저 해주세요");
            //return false;
        }
        return true;
    }
}
