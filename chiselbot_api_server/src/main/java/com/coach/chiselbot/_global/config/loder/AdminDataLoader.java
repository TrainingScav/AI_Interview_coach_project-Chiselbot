package com.coach.chiselbot._global.config.loder;

import com.coach.chiselbot.domain.admin.Admin;
import com.coach.chiselbot.domain.admin.AdminRepository;
import com.coach.chiselbot.domain.interview_category.InterviewCategory;
import com.coach.chiselbot.domain.interview_category.InterviewCategoryRepository;
import com.coach.chiselbot.domain.interview_question.InterviewLevel;
import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import com.coach.chiselbot.domain.interview_question.InterviewQuestionRepository;
import com.coach.chiselbot.domain.menuInfo.MenuInfo;
import com.coach.chiselbot.domain.menuInfo.MenuInfoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Profile("local")
@Order(2)
public class AdminDataLoader implements CommandLineRunner {

    private final AdminRepository adminRepository;
    private final InterviewCategoryRepository categoryRepository;
    private final InterviewQuestionRepository questionRepository;
    private final MenuInfoRepository menuInfoRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {

        String password = passwordEncoder.encode("1234");

        if (adminRepository.count() == 0) {
            Admin admin = Admin.builder()
                    .adminName("관리자")
                    .email("admin@chisel.com")
                    .password(password)
                    .build();

            adminRepository.save(admin);
            System.out.println("기본 관리자 계정 생성 완료: admin@chisel.com");
        } else {
            System.out.println("Admin 데이터 이미 존재하므로 로드 생략");
        }


        // 1. 카테고리 먼저 저장 (이미 있으면 생략)
        InterviewCategory category = categoryRepository.findById(1L)
                .orElseGet(() -> {
                    InterviewCategory newCategory = new InterviewCategory(1L, "Java");
                    return categoryRepository.save(newCategory);
                });
        InterviewCategory category2 = categoryRepository.findById(2L)
                .orElseGet(() -> {
                    InterviewCategory newCategory = new InterviewCategory(2L, "Oracle");
                    return categoryRepository.save(newCategory);
                });
        InterviewCategory category3 = categoryRepository.findById(3L)
                .orElseGet(() -> {
                    InterviewCategory newCategory = new InterviewCategory(3L, "CSS");
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

        // --- 메뉴 더미 데이터 추가 ---
        if (menuInfoRepository.count() == 0) {
            MenuInfo dashboard = menuInfoRepository.save(MenuInfo.builder()
                    .menuName("메뉴관리")
                    .menuCode("ADMIN_MENU_INFO")
                    .urlPath("/admin/menus")
                    .menuOrder(1)
                    .description("관리자 메뉴관리")
                    .build());

            MenuInfo questionMenu = menuInfoRepository.save(MenuInfo.builder()
                    .menuName("질문관리")
                    .menuCode("ADMIN_QUESTION")
                    .urlPath("/admin/questions")
                    .menuOrder(2)
                    .description("면접 질문 관리")
                    //.parent(dashboard) // 부모 연결 가능
                    .build());

            // 추가하고자 하는 메뉴관리 추가 (위 코드 활용)
            MenuInfo promptMenu = menuInfoRepository.save(MenuInfo.builder()
                    .menuName("프롬프트 관리")
                    .menuCode("ADMIN_PROMPT")
                    .urlPath("/admin/prompts")
                    .menuOrder(3)
                    .description("코칭 AI 프롬프트 설정 관리 ")
                    //.parent(dashboard) // 부모 연결 가능
                    .build());
        }
    }
}
