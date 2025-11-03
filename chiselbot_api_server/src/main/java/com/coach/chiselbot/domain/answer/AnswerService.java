package com.coach.chiselbot.domain.answer;

import com.coach.chiselbot._global.errors.exception.Exception400;
import com.coach.chiselbot._global.errors.exception.Exception403;
import com.coach.chiselbot._global.errors.exception.Exception404;
import com.coach.chiselbot.domain.Inquiry.Inquiry;
import com.coach.chiselbot.domain.Inquiry.InquiryRepository;
import com.coach.chiselbot.domain.Inquiry.InquiryStatus;
import com.coach.chiselbot.domain.admin.Admin;
import com.coach.chiselbot.domain.admin.AdminRepository;
import com.coach.chiselbot.domain.answer.dto.AnswerRequestDTO;
import com.coach.chiselbot.domain.answer.dto.AnswerResponseDTO;
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

    /**
     * 수정 폼용 조회 처리 (inquiry 함께 조회)
     */
    public AnswerResponseDTO.UpdateForm getUpdateForm(Long answerId) {
        Answer answer = answerRepository.findByIdWithInquiry(answerId)
                .orElseThrow(() -> new Exception404("답변을 찾을 수 없습니다."));

         return AnswerResponseDTO.UpdateForm.from(answer);
    }

    /**
     * 답변 수정 처리 로직
     */
    public Long updateAnswer(Long answerId, String adminEmail, AnswerRequestDTO.Update dto) {

        Answer answer = answerRepository.findByIdWithInquiry(answerId)
                .orElseThrow(() -> new Exception404("해당 답변을 찾을 수 없습니다."));

        Admin admin = adminRepository.findByEmail(adminEmail)
                .orElseThrow(() -> new Exception404("해당 관리자를 찾을 수 없습니다."));

        if (!answer.getAdmin().equals(admin)) {
            throw new Exception403("본인만 답변을 수정할 수 있습니다.");
        }

        answer.setContent(dto.getContent());
        return answer.getInquiry().getId();
    }

    /**
     * 답변 생성 처리 로직
     */
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
