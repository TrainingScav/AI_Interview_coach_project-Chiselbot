package com.coach.chiselbot.domain.answer;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot.domain.Inquiry.InquiryService;
import com.coach.chiselbot.domain.Inquiry.dto.InquiryResponseDTO;
import com.coach.chiselbot.domain.answer.dto.AnswerRequestDTO;
import com.coach.chiselbot.domain.answer.dto.AnswerResponseDTO;
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

    /**
     * 문의 답변 수정 화면 이동 API
     * GET/admin/inquiry/1/update-form
     */
    @GetMapping("/{answerId}/update-form")
    public String updateForm(@PathVariable(name = "answerId") Long id,
                             Model model) {
        AnswerResponseDTO.UpdateForm dto = answerService.getUpdateForm(id);
        model.addAttribute("answer",dto);
        return "auth/inquiry-answer-update";
    }

    /**
     * 문의 답변 수정 API
     * POST/admin/inquiry/1/update
     */
    @PostMapping("/{answerId}/update")
    public String updateAnswer(
            @PathVariable(name = "answerId") Long id,
            @ModelAttribute AnswerRequestDTO.Update dto,
            @SessionAttribute(Define.SESSION_USER) String adminEmail) {
        Long inquiryId = answerService.updateAnswer(id, adminEmail, dto);
        return "redirect:/admin/inquiries/" + inquiryId;
    }

    /**
     * 답변 등록 화면 이동 API
     * GET/admin/inquiry/1/answer-form
     */
    @GetMapping("/{inquiryId}/answer-form")
    public String answerForm(@PathVariable(name = "inquiryId") Long id, Model model) {

        InquiryResponseDTO.AdminInquiryDetail dto = inquiryService.getAdminInquiryDetail(id);
        model.addAttribute("inquiry",dto);
        return "auth/inquiry-answer";
    }

    /**
     * 답변 등록 API
     * POST/admin/inquiry/1/answer
     */
    @PostMapping("/{inquiryId}/answer")
    public String createAnswer(@PathVariable(name = "inquiryId") Long id,
                               @ModelAttribute AnswerRequestDTO.Create dto,
                               @SessionAttribute(Define.SESSION_USER) String adminEmail) {
        answerService.createAnswer(id, adminEmail, dto);
        return "redirect:/admin/inquiries/" + id;
    }
}
