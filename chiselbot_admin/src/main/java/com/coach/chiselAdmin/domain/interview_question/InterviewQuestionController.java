package com.coach.chiselAdmin.domain.interview_question;

import com.coach.chiselAdmin.domain.interview_coach.InterviewCoachService;
import com.coach.chiselAdmin.domain.interview_question.dto.QuestionRequest;
import com.coach.chiselAdmin.domain.interview_question.dto.QuestionResponse;
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

    @GetMapping("/{questionId}")
    public String questionDetail(@PathVariable(name = "questionId") Long questionId){

        return "question/question_detail";
    }

    /**
     * <p>Question 등록</p>
     * */
    @PostMapping("/create")
    public String createQuestion(
            @ModelAttribute("question") QuestionRequest.CreateQuestion request,
            Model model) {

        QuestionResponse.FindById createdQuestion = interviewCoachService.createQuestion(request);

        model.addAttribute("question", createdQuestion);
        model.addAttribute("message", "Question 저장 성공");

        return "question/create-result";
    }

    @GetMapping("/create")
    public String createQuestionPg(){
       return "question_create";
    }
}
