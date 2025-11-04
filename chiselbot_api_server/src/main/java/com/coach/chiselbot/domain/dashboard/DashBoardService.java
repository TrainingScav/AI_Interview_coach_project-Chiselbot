package com.coach.chiselbot.domain.dashboard;

import com.coach.chiselbot.domain.Inquiry.InquiryRepository;
import com.coach.chiselbot.domain.dashboard.dto.DashBoardResponse;
import com.coach.chiselbot.domain.interview_question.InterviewQuestionRepository;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DashBoardService {

    private final UserJpaRepository userRepository;
    private final InquiryRepository inquiryRepository;
    private final InterviewQuestionRepository questionRepository;

    // 대시보드 4개 카드 통계
    public DashBoardResponse.DashBoardStat getDashBoardStat(){
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();

        return DashBoardResponse.DashBoardStat.builder()
                .totalUsers(userRepository.count()) // 전체 회원수
                .todayUsers(userRepository.countTodayUsers(startOfDay)) // 금일 가입자수
                .todayInquiries(inquiryRepository.countTodayInquiries(startOfDay)) // 금일 문의 수
                .pendingInquiries(inquiryRepository.countWaitingInquiries()) // 문의 대기건수
                .build();
    }

    // 카테고리별 질문 수
    public List<CategoryQuestionCount> getCategoryQuestion(){

        return questionRepository.countQuestionsByCategory();
    }

    // 전체 질문 수
    public long getQuestionCount(){
        return questionRepository.count();
    }

    // 연도선택 - 월별 문의 통계
    public List<MonthlyInquiryStats> getMonthlyStatsByYear(int year) {
        return inquiryRepository.countInquiriesByYear(year);
    }

}
