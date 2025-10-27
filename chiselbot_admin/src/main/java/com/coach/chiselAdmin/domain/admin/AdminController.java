package com.coach.chiselAdmin.domain.admin;

import com.coach.chiselAdmin._global.common.Define;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    /**
     * 관리자 로그인 화면 연결 API
     */
    @GetMapping("/login-form")
    public String loginForm() {
        return "login";
    }

    /**
     * 관리자 로그인 API
     */
    @PostMapping("/login")
    public String login(AdminRequestDto.Login request, HttpSession session) {
        Admin admin = adminService.login(request);
        session.setAttribute(Define.SESSION_USER,admin);
        return "redirect:/index";
    }

    /**
     * 관리자 로그아웃 API
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        adminService.logout(session);
        return "redirect:/login-form";
    }

    @GetMapping("/index")
    public String index() {
        return "index";
    }

}
