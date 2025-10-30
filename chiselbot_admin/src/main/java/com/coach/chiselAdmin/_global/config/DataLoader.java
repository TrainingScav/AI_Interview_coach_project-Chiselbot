package com.coach.chiselAdmin._global.config;//package com.coach._global.config;

import com.coach.chiselAdmin.domain.interview_category.InterviewCategory;
import com.coach.chiselAdmin.domain.interview_category.InterviewCategoryRepository;
import com.coach.chiselAdmin.domain.interview_question.InterviewLevel;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestion;
import com.coach.chiselAdmin.domain.interview_question.InterviewQuestionRepository;
import com.coach.chiselAdmin.domain.menuInfo.MenuInfo;
import com.coach.chiselAdmin.domain.menuInfo.MenuInfoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component // IoC 대상
@RequiredArgsConstructor
@Profile("local")
@Order(1)
public class DataLoader implements CommandLineRunner {

    private final MenuInfoRepository menuInfoRepository;
    private final InterviewCategoryRepository categoryRepository;
    private final InterviewQuestionRepository questionRepository;

    @Override
    public void run(String... args) throws Exception {
        // --- 메뉴 더미 데이터 추가 ---
        if (menuInfoRepository.count() == 0) {
            MenuInfo dashboard = menuInfoRepository.save(MenuInfo.builder()
                    .menuName("대시보드")
                    .menuCode("ADMIN_DASHBOARD")
                    .urlPath("/admin/dashboard")
                    .menuOrder(1)
                    .description("관리자 대시보드")
                    .build());

            MenuInfo questionMenu = menuInfoRepository.save(MenuInfo.builder()
                    .menuName("질문 관리")
                    .menuCode("ADMIN_QUESTION")
                    .urlPath("/admin/questions")
                    .menuOrder(2)
                    .description("면접 질문 관리")
                    //.parent(dashboard) // 부모 연결 가능
                    .build());
        }

        // 1️. 카테고리 먼저 저장 (이미 있으면 생략)
        InterviewCategory category = categoryRepository.findById(1L)
                .orElseGet(() -> {
                    InterviewCategory newCategory = new InterviewCategory(1L, "기술");
                    return categoryRepository.save(newCategory);
                });

        // 2. InterviewQuestion 더미 데이터
        InterviewQuestion question = new InterviewQuestion();
        question.setCategoryId(category);
        question.setInterviewLevel(InterviewLevel.LEVEL_1);
        question.setAdminId(null);
        question.setQuestionText("JDBC는 무엇인가요");
        question.setAnswerText("자바에서 DB에 접근하여 데이터를 조회, 삽입, 수정, 삭제할 수 있도록 자바와 DB를 연결해 주는 인터페이스");
        question.setAnswerVector("[0.0123, -0.0345, 0.0567, -0.0789, 0.0912, -0.0456, 0.0678, -0.0123, 0.0345, -0.0567]");

        // 3️⃣ 저장
        questionRepository.save(question);

        System.out.println("✅ 더미 데이터 삽입 완료: InterviewCategory + InterviewQuestion");

    }
}
