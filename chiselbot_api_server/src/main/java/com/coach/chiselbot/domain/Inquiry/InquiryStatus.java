package com.coach.chiselbot.domain.Inquiry;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum InquiryStatus {

    WAITING("대기"),
    ANSWERED("답변완료"),
    CLOSED("처리완료");

    private final String label;

}
