package com.coach.chiselAdmin.domain;

import com.coach.chiselAdmin.domain.menuInfo.MenuInfo;
import com.coach.chiselAdmin.domain.menuInfo.MenuInfoService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final MenuInfoService menuInfoService;

    @GetMapping("/")
    public String mainPage(Model model) {
        return "index";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "auth/login";
    }
}
