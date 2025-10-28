package com.coach.chiselbot.domain.Inquiry;

import com.coach.chiselbot.domain.user.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Timestamp;

@Entity
@Data
@Table(name = "USER_INQUIRY")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Inquiry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    // 답변자(관리자) 임시 컬럼
    private String adminName;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false,columnDefinition = "TEXT")
    private String content;

    @Column(columnDefinition = "TEXT")
    private String answerContent;

    @Enumerated(EnumType.STRING)
    private InquiryStatus status;

    @CreationTimestamp
    private Timestamp createdAt;

    // 문의 등록 시간 임시 컬럼
    private String answeredAt;

    @UpdateTimestamp
    private Timestamp updateAt;


}
