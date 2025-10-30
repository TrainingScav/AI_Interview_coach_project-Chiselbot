package com.coach.chiselbot._global.config.loder;


import com.coach.chiselbot.domain.Inquiry.Inquiry;
import com.coach.chiselbot.domain.Inquiry.InquiryRepository;
import com.coach.chiselbot.domain.Inquiry.InquiryStatus;
import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;

@Component
@RequiredArgsConstructor
@Profile("dev")
@Order(2)
public class InquiryDataLoader implements CommandLineRunner {

    private final InquiryRepository inquiryRepository;
    private final UserJpaRepository userJpaRepository;

    @Override
    public void run(String... args) throws Exception {

        List<User> users = userJpaRepository.findAll();
        if (users.isEmpty()) return; // 유저 없을 때 생략

        Timestamp now = Timestamp.from(Instant.now());

        inquiryRepository.save(
                Inquiry.builder()
                        .user(users.get(0))
                        .admin(null)
                        .title("결제 환불 요청")
                        .content("결제 후 사용하지 않아 환불 요청드립니다.")
                        .answerContent(null)
                        .status(InquiryStatus.WAITING)
                        .createdAt(now)
                        .answeredAt(null)
                        .build()
        );

        inquiryRepository.save(
                Inquiry.builder()
                        .user(users.get(1))
                        .admin(null)
                        .title("기능 제안")
                        .content("AI 추천 기능에 이력서 분석 기능을 추가해주셨으면 합니다.")
                        .answerContent(null)
                        .status(InquiryStatus.WAITING)
                        .createdAt(now)
                        .answeredAt(null)
                        .build()
        );

        inquiryRepository.save(
                Inquiry.builder()
                        .user(users.get(2))
                        .admin(null)
                        .title("AI 답변 지연시간")
                        .content("답변 지연 시간이 긴 것 같습니다.저만 그런걸까요ㅠㅠ")
                        .answerContent(null)
                        .status(InquiryStatus.WAITING)
                        .createdAt(now)
                        .answeredAt(null)
                        .build()
        );
        System.out.println("기본 문의 3건 생성 완료되었습니다.");
    }
}
