package com.coach.chiselbot.domain.notice;

import com.coach.chiselbot._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.notice.dto.NoticeRequest;
import com.coach.chiselbot.domain.notice.dto.NoticeResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

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
