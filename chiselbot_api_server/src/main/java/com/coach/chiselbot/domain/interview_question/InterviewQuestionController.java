package com.coach.chiselbot.domain.interview_question;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot.domain.admin.Admin;
import com.coach.chiselbot.domain.interview_question.dto.QuestionRequest;
import com.coach.chiselbot.domain.interview_question.dto.QuestionResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/questions")
public class InterviewQuestionController {

    private final InterviewQuestionService interviewQuestionService;

    /**
     * <p>Question List 화면으로 이동</p>
     * */
    @GetMapping
    public String getQuestionList(@RequestParam(defaultValue = "0") int page,
                                  Model model){
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
    public String questionDetail(@PathVariable(name = "questionId") Long questionId,
                                 Model model){

        QuestionResponse.FindById question = interviewQuestionService.getQuestionDetail(questionId);

        model.addAttribute("categories", interviewQuestionService.getAllCategories());
        model.addAttribute("question", question);

        return "question/question_detail";
    }

    /**
     * <p>Question 등록</p>
     * */
    @PostMapping("/create")
    public String createQuestion(
            @ModelAttribute("question") QuestionRequest.CreateQuestion request,
            RedirectAttributes rttr,
            HttpSession session) {

        Admin admin = (Admin) session.getAttribute(Define.SESSION_USER);
        request.setAdminId(admin.getId());
        QuestionResponse.FindById createdQuestion = interviewQuestionService.createQuestion(request);

        rttr.addFlashAttribute("message", "질문이 생성 되었습니다");

        return "redirect:/admin/questions";
    }

    /**
     * <p>Question 등록 페이지 이동</p>
     * */
    @GetMapping("/create")
    public String createQuestionPg(Model model){
        model.addAttribute("categories", interviewQuestionService.getAllCategories());
        model.addAttribute("levels", InterviewLevel.values()); // enum 전체
        model.addAttribute("question", new QuestionRequest.CreateQuestion());
        return "question/question_create";
    }

    /**
     * <p>Question 수정</p>
     * */
    @PostMapping("/update")
    public String updateQuestion(RedirectAttributes rttr,
                                 HttpSession session,
                                 @ModelAttribute("question") QuestionRequest.UpdateQuestion request){
        Admin admin = (Admin) session.getAttribute(Define.SESSION_USER);
        request.setAdminId(admin.getId());
        QuestionResponse.FindById updateQuestion = interviewQuestionService.updateQuestion(request);

        rttr.addFlashAttribute("message", "수정이 완료되었습니다");

        return "redirect:/admin/questions";
    }

    /**
     * <p>Question 삭제</p>
     * */

    @PostMapping("/{questionId}/delete")
    public String deleteQuestion(RedirectAttributes rttr,
                                 @PathVariable("questionId") Long questionId){
        interviewQuestionService.deleteQuestion(questionId);
        rttr.addFlashAttribute("message", "삭제가 완료되었습니다");
        return "redirect:/admin/questions";
    }

}
