package com.coach.chiselbot.domain.Inquiry;

import com.coach.chiselbot._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.Inquiry.dto.InquiryRequestDTO;
import com.coach.chiselbot.domain.Inquiry.dto.InquiryResponseDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/inquiries")
public class InquiryController {

    private final InquiryService inquiryService;


    /**
     * 사용자 문의 삭제 API
     */
    @DeleteMapping("/{inquiryId}")
    public ResponseEntity<?> deleteInquiry(
            @PathVariable Long inquiryId,
            @RequestAttribute("userEmail") String email
    ) {
        inquiryService.deleteInquiry(inquiryId, email);
        return ResponseEntity.ok(CommonResponseDto.success(null, "문의가 삭제 되었습니다."));
    }

    /**
     * 사용자 문의 수정 API
     */
    @PutMapping("/{inquiryId}")
    public ResponseEntity<?> updateInquiry(
            @PathVariable Long inquiryId,
            @RequestBody InquiryRequestDTO.Update dto,
            @RequestAttribute("userEmail") String email
    ) {
        Inquiry updated = inquiryService.updateInquiry(inquiryId, dto, email);
        return ResponseEntity.ok(CommonResponseDto.success(updated, "문의가 수정 되었습니다."));
    }


    /**
     * 사용자 문의 상세 조회 API
     */
    @GetMapping("/{inquiryId}")
    public ResponseEntity<CommonResponseDto<InquiryResponseDTO.DetailDTO>> detail(
            @PathVariable Long inquiryId
    ) {
        InquiryResponseDTO.DetailDTO inquiry = inquiryService.finById(inquiryId);

        return ResponseEntity.ok(CommonResponseDto.success(inquiry));
    }

    /**
     * 사용자 문의 목록 조회 API
     */
    @GetMapping
    public ResponseEntity<CommonResponseDto<Page<InquiryResponseDTO.ListDTO>>> list(
            @PageableDefault(size = 10, sort = "id", direction = Sort.Direction.DESC)
            Pageable pageable
    ) {
        Page<InquiryResponseDTO.ListDTO> inquiries = inquiryService.findInquiries(pageable);
        return ResponseEntity.ok(CommonResponseDto.success(inquiries));
    }


    /**
     * 사용자 문의 생성 API
     */
    @PostMapping
    public ResponseEntity<?> createInquiry(
            @RequestBody InquiryRequestDTO.Create dto,
            @RequestAttribute("userEmail") String email
    ) {

        Inquiry createdInquiry = inquiryService.createInquiry(dto, email);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(CommonResponseDto.success(createdInquiry, "문의 등록이 완료되었습니다"));
    }
}
