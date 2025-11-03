package com.coach.chiselbot.domain;

import com.coach.chiselbot.domain.dashboard.CategoryQuestionCount;
import com.coach.chiselbot.domain.dashboard.DashBoardService;
import com.coach.chiselbot.domain.dashboard.dto.DashBoardResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final DashBoardService dashBoardService;

    @GetMapping("/")
    public String mainPage(Model model) {
        DashBoardResponse.DashBoardStat dashBoardStat = dashBoardService.getDashBoardStat();
        List<CategoryQuestionCount> donutChartStat = dashBoardService.getCategoryQuestion();

        model.addAttribute("dashboardStat", dashBoardStat);
        model.addAttribute("donutChartStat", donutChartStat);
        model.addAttribute("questionCountAll", dashBoardService.getQuestionCount());
        return "index";
    }

//    @GetMapping("/login")
//    public String loginPage() {
//        return "auth/login";
//    }
}
