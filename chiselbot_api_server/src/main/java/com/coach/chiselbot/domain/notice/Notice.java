package com.coach.chiselbot.domain.notice;

import com.coach.chiselbot._global.entity.BaseEntity;
import com.coach.chiselbot.domain.admin.Admin;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "notice")
@Builder
public class Notice extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long noticeId;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    @Builder.Default
    @Column(nullable = false)
    private Integer viewCount = 0;

    @Builder.Default
    @Column(nullable = false)
    private Boolean isVisible = true;

    // 작성자 (관리자)
    @ManyToOne(fetch = FetchType.LAZY)
    private Admin admin;

    public void increaseViewCount() {
        this.viewCount++;
    }
}
