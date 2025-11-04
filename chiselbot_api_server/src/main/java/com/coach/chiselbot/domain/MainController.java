package com.coach.chiselbot.domain;

import com.coach.chiselbot.domain.dashboard.CategoryQuestionCount;
import com.coach.chiselbot.domain.dashboard.DashBoardService;
import com.coach.chiselbot.domain.dashboard.MonthlyInquiryStats;
import com.coach.chiselbot.domain.dashboard.dto.DashBoardResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final DashBoardService dashBoardService;

    @GetMapping("/")
    public String mainPage(Model model) {
        int currentYear = LocalDate.now().getYear();
        DashBoardResponse.DashBoardStat dashBoardStat = dashBoardService.getDashBoardStat();
        List<CategoryQuestionCount> donutChartStat = dashBoardService.getCategoryQuestion();

        model.addAttribute("dashboardStat", dashBoardStat);
        model.addAttribute("donutChartStat", donutChartStat);
        model.addAttribute("questionCountAll", dashBoardService.getQuestionCount());
        model.addAttribute("year", currentYear);
        return "index";
    }

    @GetMapping("/admin/inquiry-stats/year")
    @ResponseBody
    public List<MonthlyInquiryStats> getStatsByYear(@RequestParam(name = "year") int year) {
        return dashBoardService.getMonthlyStatsByYear(year);
    }

//    @GetMapping("/login")
//    public String loginPage() {
//        return "auth/login";
//    }
}
