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

    public DashBoardResponse.DashBoardStat getDashBoardStat(){
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();

        return DashBoardResponse.DashBoardStat.builder()
                .totalUsers(userRepository.count()) // 전체 회원수
                .todayUsers(userRepository.countTodayUsers(startOfDay)) // 금일 가입자수
                .todayInquiries(inquiryRepository.countTodayInquiries(startOfDay)) // 금일 문의 수
                .pendingInquiries(inquiryRepository.countWaitingInquiries()) // 문의 대기건수
                .build();
    }

    public List<CategoryQuestionCount> getCategoryQuestion(){

        return questionRepository.countQuestionsByCategory();
    }

    public long getQuestionCount(){
        return questionRepository.count();
    }
}
