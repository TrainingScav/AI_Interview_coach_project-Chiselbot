package com.coach.chiselbot.domain.Inquiry;

import com.coach._global.errors.exception.Exception400;
import com.coach._global.errors.exception.Exception403;
import com.coach._global.errors.exception.Exception404;
import com.coach.chiselbot.domain.Inquiry.dto.InquiryRequestDTO;
import com.coach.chiselbot.domain.Inquiry.dto.InquiryResponseDTO;
import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class InquiryService {

    private final InquiryRepository inquiryRepository;
    private final UserJpaRepository userJpaRepository;


    /**
     * 사용자 문의 삭제 처리
     */
    public void deleteInquiry(Long inquiryId, String userEmail) {
        User user = userJpaRepository.findByEmail(userEmail)
                .orElseThrow(() -> new Exception404("사용자를 찾을 수 업습니다."));

        Inquiry inquiry = inquiryRepository.findById(inquiryId)
                .orElseThrow(() -> new Exception404("해당 문의를 찾을 수 없습니다."));

        if (!inquiry.getUser().equals(user)) {
            throw new Exception403("본인만 문의를 삭제할 수 있습니다.");
        }

        if (inquiry.getStatus() != InquiryStatus.WAITING) {
            throw new Exception400("대기 상태의 문의만 삭제할 수 있습니다.");
        }

        inquiryRepository.delete(inquiry);
    }


    /**
     * 사용자 문의 수정 처리
     */
    public Inquiry updateInquiry(Long inquiryId, InquiryRequestDTO.Update dto, String userEmail) {
        User user = userJpaRepository.findByEmail(userEmail)
                .orElseThrow(() -> new Exception404("사용자를 찾을 수 없습니다."));

        Inquiry inquiry = inquiryRepository.findById(inquiryId)
                .orElseThrow(() -> new Exception404("해당 문의를 찾을 수 없습니다."));

        if (!inquiry.getUser().equals(user)) {
            throw new Exception403("본인만 문의를 수정할 수 있습니다.");
        }

        if (inquiry.getStatus() != InquiryStatus.WAITING) {
            throw new Exception400("대기 상태의 문의만 수정할 수 있습니다.");
        }

        inquiry.setTitle(dto.getTitle());
        inquiry.setContent(dto.getContent());

        return inquiryRepository.save(inquiry);
    }

    /**
     * 사용자 문의 상세 조회 처리
     */
    public InquiryResponseDTO.DetailDTO finById(Long id) {
        Inquiry inquiry = inquiryRepository.findById(id)
                .orElseThrow(() -> new Exception404("해당 문의를 찾을 수 없습니다."));
        return InquiryResponseDTO.DetailDTO.from(inquiry);
    }

    /**
     * 사용자 문의 목록 조회 처리
     */
    public Page<InquiryResponseDTO.ListDTO> findInquiries(Pageable pageable) {
        Page<Inquiry> inquiries = inquiryRepository.findAll(pageable);
        return inquiries.map(InquiryResponseDTO.ListDTO::from);
    }

    /**
     * 사용자 문의 생성 처리
     */
    public Inquiry createInquiry(InquiryRequestDTO.Create dto, String userEmail) {

        User author = userJpaRepository.findByEmail(userEmail)
                .orElseThrow(() -> new Exception404("존재하지 않는 사용자입니다"));

        Inquiry newInquiry = new Inquiry();
        newInquiry.setTitle(dto.getTitle());
        newInquiry.setContent(dto.getContent());
        newInquiry.setStatus(InquiryStatus.WAITING);
        return inquiryRepository.save(newInquiry);
    }
}
