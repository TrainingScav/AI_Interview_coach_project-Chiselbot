package com.coach.chiselbot.domain;

import com.coach.chiselbot.domain.menuInfo.MenuInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final MenuInfoService menuInfoService;

    @GetMapping("/")
    public String mainPage() {
        return "index";
    }

//    @GetMapping("/login")
//    public String loginPage() {
//        return "auth/login";
//    }
}
