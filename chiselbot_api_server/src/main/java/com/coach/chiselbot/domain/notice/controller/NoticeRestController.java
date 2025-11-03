package com.coach.chiselbot.domain.notice.controller;

import com.coach.chiselbot._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.notice.NoticeService;
import com.coach.chiselbot.domain.notice.dto.NoticeResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/notice")
public class NoticeRestController {

    private final NoticeService noticeService;

    @GetMapping
    public ResponseEntity<?> noticeList() {
        List<NoticeResponse.FindAll> noticeList = noticeService.getNoticeList();

        return ResponseEntity.ok(CommonResponseDto.success(noticeList));
    }

    @GetMapping("/{noticeId}")
    public ResponseEntity<?> noticeDetail(@PathVariable(name = "noticeId") Long noticeId){

        NoticeResponse.FindById notice = noticeService.getNoticeDetail(noticeId);

        return ResponseEntity.ok(CommonResponseDto.success(notice));

    }
}
