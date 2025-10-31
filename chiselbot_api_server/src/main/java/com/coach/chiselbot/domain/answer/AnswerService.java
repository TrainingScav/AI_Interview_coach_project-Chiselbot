package com.coach.chiselbot.domain.answer;

import com.coach.chiselbot._global.errors.exception.Exception400;
import com.coach.chiselbot._global.errors.exception.Exception404;
import com.coach.chiselbot.domain.Inquiry.Inquiry;
import com.coach.chiselbot.domain.Inquiry.InquiryRepository;
import com.coach.chiselbot.domain.Inquiry.InquiryStatus;
import com.coach.chiselbot.domain.admin.Admin;
import com.coach.chiselbot.domain.admin.AdminRepository;
import com.coach.chiselbot.domain.answer.dto.AnswerRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class AnswerService {

    private final InquiryRepository inquiryRepository;
    private final AnswerRepository answerRepository;
    private final AdminRepository adminRepository;

    public Answer createAnswer(Long inquiryId, String adminEmail, AnswerRequestDTO.Create dto) {

        Inquiry inquiry = inquiryRepository.findByIdWithAnswer(inquiryId)
                .orElseThrow(() -> new Exception404("문의가 존재하지 않습니다"));

        if (inquiry.getAnswer() != null) {
            throw new Exception400("이미 답변이 등록된 문의입니다.");
        }

        Admin admin = adminRepository.findByEmail(adminEmail)
                .orElseThrow(() -> new Exception404("관리자를 찾을 수 없습니다."));

        Answer answer = Answer.builder()
                .content(dto.getContent())
                .admin(admin)
                .inquiry(inquiry)
                .build();

        inquiry.setStatus(InquiryStatus.ANSWERED);
        inquiry.setAnswer(answer);

        answerRepository.save(answer);

        return answer;
    }


}
