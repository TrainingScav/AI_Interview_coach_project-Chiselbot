package com.coach.chiselbot._global.advice;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot.domain.admin.Admin;
import com.coach.chiselbot.domain.menuInfo.MenuInfo;
import com.coach.chiselbot.domain.menuInfo.MenuInfoService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {
    private final MenuInfoService menuInfoService;

    @ModelAttribute("menus")
    public List<MenuInfo> menus() {
        return menuInfoService.getVisibleTrueAllMenus();
    }

}
