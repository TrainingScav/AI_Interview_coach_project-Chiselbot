package com.coach.chiselAdmin._global.config;//package com.coach._global.config;

import com.coach.chiselAdmin.domain.interview_category.InterviewCategoryRepository;
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
