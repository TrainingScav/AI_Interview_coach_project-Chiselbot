package com.coach.chiselbot.domain.Inquiry;

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

    private final InquiryJpaRepository inquiryJpaRepository;
    private final UserJpaRepository userJpaRepository;


    /**
     * 사용자 1:1 문의 상세 조회 처리
     */
    public InquiryResponseDTO.DetailDTO finById (Long id) {
        Inquiry inquiry = inquiryJpaRepository.findById(id)
                .orElseThrow(() -> new Exception404("해당 문의를 찾을 수 없습니다."));
        return InquiryResponseDTO.DetailDTO.from(inquiry);
    }

    /**
     * 사용자 1:1 문의 목록 조회 처리
     */
    public Page<InquiryResponseDTO.ListDTO> findInquiries(Pageable pageable) {
        Page<Inquiry> inquiries = inquiryJpaRepository.findAll(pageable);
        return inquiries.map(InquiryResponseDTO.ListDTO::from);
    }

    /**
     * 사용자 1:1 문의 생성 처리
     */
    public Inquiry createInquiry(InquiryRequestDTO.Create dto) {

        User author = userJpaRepository.findById(dto.getAuthorId())
                .orElseThrow(() -> new Exception404("존재하지 않는 사용자입니다"));

        Inquiry newInquiry = new Inquiry();
        newInquiry.setTitle(dto.getTitle());
        newInquiry.setContent(dto.getContent());
        newInquiry.setUser(author);
        newInquiry.setStatus(InquiryStatus.WAITING);
        return inquiryJpaRepository.save(newInquiry);
    }
}
