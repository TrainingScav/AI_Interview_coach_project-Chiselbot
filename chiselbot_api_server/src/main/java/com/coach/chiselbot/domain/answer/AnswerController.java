package com.coach.chiselbot.domain.answer;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot.domain.Inquiry.InquiryService;
import com.coach.chiselbot.domain.answer.dto.AnswerRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/inquiry")
public class AnswerController {

    private final AnswerService answerService;
    private final InquiryService inquiryService;


    // 삭제


    // 상세 조회

    // 목록 조회

    /**
     * 문의 답변 수정 화면 이동 API
     * GET/admin/inquiry/1/update-form
     */

    /**
     * 문의 답변 수정 API
     * POST/admin/inquiry/1/update
     */

    /**
     * 답변 등록 화면 이동 API
     * GET/admin/inquiry/1/answer-form
     */
    @GetMapping("/{inquiryId}/answer-form")
    public String answerForm(@PathVariable(name = "{inquiryId}") Long id, Model model) {
        return "";
    }

    /**
     * 답변 등록 API
     * POST/admin/inquiry/1/answer
     */
    @PostMapping("/{inquiryId}/answer")
    public String createAnswer(@PathVariable(name = "{inquiryId}") Long id,
                               @ModelAttribute AnswerRequestDTO.Create dto,
                               @SessionAttribute(Define.SESSION_USER) String adminEmail) {
        answerService.createAnswer(id, adminEmail, dto);

        return "redirect:/admin/inquiry/" + id + "answer-form";
    }
}
