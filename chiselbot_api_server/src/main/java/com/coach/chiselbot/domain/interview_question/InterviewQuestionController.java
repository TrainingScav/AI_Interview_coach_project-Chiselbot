package com.coach.chiselbot.domain.interview_question;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot.domain.admin.Admin;
import com.coach.chiselbot.domain.interview_coach.InterviewCoachService;
import com.coach.chiselbot.domain.interview_question.dto.QuestionRequest;
import com.coach.chiselbot.domain.interview_question.dto.QuestionResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/questions")
public class InterviewQuestionController {

    private final InterviewQuestionService interviewQuestionService;
    private final InterviewCoachService interviewCoachService;

    /**
     * <p>Question List 화면으로 이동</p>
     */
    @GetMapping
    public String getQuestionList(@RequestParam(defaultValue = "0") int page,
                                  Model model) {
        Page<QuestionResponse.FindAll> questionPage = interviewQuestionService.getQuestionList(page);
        List<QuestionResponse.FindAll> questionList = questionPage.getContent();

        // Mustache 에서 사용 할 값 넘겨주는 Model
        model.addAttribute("questions", questionList); // 등록되어있는 질문 리스트
        model.addAttribute("currentPage", questionPage.getNumber()); // 현재 페이지
        model.addAttribute("totalPages", questionPage.getTotalPages()); // 전체 페이지 수
        model.addAttribute("hasNext", questionPage.hasNext()); // 다음 페이지 존재 여부
        model.addAttribute("hasPrevious", questionPage.hasPrevious()); // 이전페이지 존재 여부
        model.addAttribute("nextPage", questionPage.hasNext() ? questionPage.getNumber() + 1 : questionPage.getNumber()); // 다음페이지 번호
        model.addAttribute("prevPage", questionPage.hasPrevious() ? questionPage.getNumber() - 1 : questionPage.getNumber()); // 이전페이지 번호
        model.addAttribute("totalElements", questionPage.getTotalElements()); // 전체 질문 수
        model.addAttribute("pageSize", questionPage.getSize()); // 한페이지당 표시 개수 : 10

        return "question/question_list";
    }

    @GetMapping("detail/{questionId}")
    public String questionDetail(@PathVariable(name = "questionId") Long questionId) {

        return "question/question_detail";
    }

    /**
     * <p>Question 등록</p>
     */
    @PostMapping("/create")
    public String createQuestion(
            @ModelAttribute("question") QuestionRequest.CreateQuestion request,
            Model model,
            HttpSession session) {

        Admin admin = (Admin) session.getAttribute(Define.SESSION_USER);
        System.out.println("세션 유저: " + session.getAttribute(Define.SESSION_USER));
        request.setAdminId(admin.getId());
        QuestionResponse.FindById createdQuestion = interviewCoachService.createQuestion(request);

        model.addAttribute("question", createdQuestion);
        model.addAttribute("message", "Question 저장 성공");

        return "redirect:/admin/questions";
    }

    @GetMapping("/create")
    public String createQuestionPg(Model model) {
        model.addAttribute("categories", interviewQuestionService.getAllCategories());
        model.addAttribute("levels", InterviewLevel.values()); // enum 전체
        model.addAttribute("question", new QuestionRequest.CreateQuestion());
        return "question/question_create";
    }
}
