package com.coach.chiselbot.domain.menuInfo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/menus")
public class MenuInfoController {
    @GetMapping
    public String menuInfoPage(Model model) {

        return "menuInfo/menuInfo_list";
    }
}
