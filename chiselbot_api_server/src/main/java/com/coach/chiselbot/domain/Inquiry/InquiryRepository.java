package com.coach.chiselbot.domain.Inquiry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface InquiryRepository extends JpaRepository<Inquiry, Long> {

    @Query("SELECT i FROM Inquiry i LEFT JOIN FETCH i.answer WHERE i.id = :id")
    Optional<Inquiry> findByIdWithAnswer(@Param("id") Long id);

    @Query("SELECT i FROM Inquiry i JOIN FETCH i.user u LEFT JOIN FETCH i.answer a LEFT JOIN FETCH a.admin ad ORDER BY i.createdAt DESC")
    List<Inquiry> findAllWithUserAnswer();


    // 오늘 등록된 문의 수
    @Query("SELECT COUNT(i) FROM Inquiry i WHERE i.createdAt >= :startOfDay")
    long countTodayInquiries(@Param("startOfDay") LocalDateTime startOfDay);

    // 대기 상태(답변 미완료) 문의 수
    @Query("SELECT COUNT(i) FROM Inquiry i WHERE i.status = 'WAITING'")
    long countWaitingInquiries();
}
