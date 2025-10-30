package com.coach.chiselAdmin._global.config;

import com.coach.chiselAdmin.domain.admin.Admin;
import com.coach.chiselAdmin.domain.admin.AdminRepository;
import com.coach.chiselAdmin.domain.interview_category.InterviewCategory;
import com.coach.chiselAdmin.domain.interview_category.InterviewCategoryRepository;
import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Profile("local")
@Order(2)
public class AdminDataLoader implements CommandLineRunner {

    private final AdminRepository adminRepository;
    private final InterviewCategoryRepository categoryRepository;
    private final InterviewQuestionRepository questionRepository;

    @Override
    public void run(String... args) throws Exception {
        if (adminRepository.count() == 0) {
            Admin admin = Admin.builder()
                    .adminName("관리자")
                    .email("admin@chisel.com")
                    .password("1234")
                    .build();

            adminRepository.save(admin);
            System.out.println("기본 관리자 계정 생성 완료: admin@chisel.com");
        } else {
            System.out.println("Admin 데이터 이미 존재하므로 로드 생략");
        }


        // 1️. 카테고리 먼저 저장 (이미 있으면 생략)
        InterviewCategory category = categoryRepository.findById(1L)
                .orElseGet(() -> {
                    InterviewCategory newCategory = new InterviewCategory(1L, "Java");
                    return categoryRepository.save(newCategory);
                });
        Admin admin = adminRepository.findById(2L)
                .orElseGet(() -> {
                    Admin newAdmin = Admin.builder()
                            .adminName("관리자2")
                            .email("admin22@chisel.com")
                            .password("1234")
                            .build();
                    return adminRepository.save(newAdmin);
                });

        // 2. InterviewQuestion 더미 데이터
        InterviewQuestion question = new InterviewQuestion();
        question.setCategoryId(category);
        question.setInterviewLevel(InterviewLevel.LEVEL_1);
        question.setAdminId(admin);
        question.setQuestionText("JDBC는 무엇인가요");
        question.setAnswerText("자바에서 DB에 접근하여 데이터를 조회, 삽입, 수정, 삭제할 수 있도록 자바와 DB를 연결해 주는 인터페이스");
        question.setAnswerVector("[0.0123, -0.0345, 0.0567, -0.0789, 0.0912, -0.0456, 0.0678, -0.0123, 0.0345, -0.0567]");

        // 3. 저장
        questionRepository.save(question);

    }
}
