package com.coach.chiselAdmin._global.advice;

import com.coach.chiselAdmin.domain.menuInfo.MenuInfo;
import com.coach.chiselAdmin.domain.menuInfo.MenuInfoService;
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
        return menuInfoService.getAllMenus();
    }
}
