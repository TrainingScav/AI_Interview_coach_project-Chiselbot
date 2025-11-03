package com.coach.chiselbot.domain.Inquiry.controller;

import com.coach.chiselbot.domain.Inquiry.InquiryService;
import com.coach.chiselbot.domain.Inquiry.dto.InquiryResponseDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/inquiries")
@RequiredArgsConstructor
public class AdminInquiryController {

    private final InquiryService inquiryService;

    /**
     * 문의 상세 조회 API
     * POST/admin/inquiries/1
     */
    @PostMapping("/{inquiryId}")
    public String adminInquiryDetail(@PathVariable(name = "inquiryId") Long id,
                                     Model model) {
        InquiryResponseDTO.AdminInquiryDetail inquiryDetail = inquiryService.getAdminInquiryDetail(id);
        model.addAttribute("inquiry",inquiryDetail);
        return "";
    }

    /**
     * 문의 전체 목록 조회 API
     * GET/admin/inquiries
     */
    @GetMapping
    public String adminInquiries(Model model) {
        List<InquiryResponseDTO.AdminInquiryList> inquiries = inquiryService.adminInquiryList();
        model.addAttribute("inquiries",inquiries);
        return "auth/inquiry";
    }

}
