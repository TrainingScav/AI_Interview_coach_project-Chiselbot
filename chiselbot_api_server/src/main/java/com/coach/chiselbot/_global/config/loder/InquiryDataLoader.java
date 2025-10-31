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
@Profile("local")
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
                        .title("결제 환불 요청")
                        .content("결제 후 사용하지 않아 환불 요청드립니다.")
                        .answerContent("좋은 제안 감사합니다. 다음 업데이트에 반영 검토하겠습니다 🙏")
                        .status(InquiryStatus.WAITING)
                        .build()
        );

        inquiryRepository.save(
                Inquiry.builder()
                        .user(users.get(1))
                        .title("기능 제안")
                        .content("AI 추천 기능에 이력서 분석 기능을 추가해주셨으면 합니다.")
                        .answerContent("현재 서버 부하로 인해 일시적인 지연이 발생하고 있습니다. 개선 중입니다.")
                        .status(InquiryStatus.WAITING)
                        .build()
        );

        inquiryRepository.save(
                Inquiry.builder()
                        .user(users.get(2))
                        .title("AI 답변 지연시간")
                        .content("답변 지연 시간이 긴 것 같습니다.저만 그런걸까요ㅠㅠ")
                        .answerContent(null)
                        .status(InquiryStatus.WAITING)
                        .build()
        );
        System.out.println("기본 문의 3건 생성 완료되었습니다.");
    }
}
