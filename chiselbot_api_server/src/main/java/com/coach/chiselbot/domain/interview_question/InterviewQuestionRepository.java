package com.coach.chiselbot.domain.interview_question;

import com.coach.chiselbot.domain.dashboard.CategoryQuestionCount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface InterviewQuestionRepository extends JpaRepository<InterviewQuestion, Long> {

    // 카테고리 + 레벨 기준으로 랜덤 1개 선택
//    @Query(value = """
//        SELECT *
//        FROM interview_question_meta
//        WHERE category_id = :categoryId
//          AND interview_level = :level
//        ORDER BY RAND()
//        LIMIT 1
//    """, nativeQuery = true)
//    Optional<InterviewQuestion> findRandomByCategoryAndLevel(
//            @Param("categoryId") Long categoryId,
//            @Param("level") String level
//    );

    Optional<InterviewQuestion> findFirstByCategoryId_CategoryIdAndInterviewLevel(Long categoryId, InterviewLevel  interviewLevel);

    @Query("""
    SELECT q.categoryId.name AS categoryName,
           COUNT(q) AS questionCount
    FROM InterviewQuestion q
    GROUP BY q.categoryId.name""")
    List<CategoryQuestionCount> countQuestionsByCategory();
}
