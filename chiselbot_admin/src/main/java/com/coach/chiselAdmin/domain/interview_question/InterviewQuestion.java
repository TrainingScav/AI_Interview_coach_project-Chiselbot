package com.coach.chiselAdmin.domain.interview_question;


import com.coach.chiselAdmin._global.entity.BaseEntity;
import com.coach.chiselAdmin.domain.admin.Admin;
import com.coach.chiselAdmin.domain.interview_category.InterviewCategory;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "interview_question_meta")
@Builder
public class InterviewQuestion extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long questionId;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")  // FK
    private InterviewCategory categoryId;

    @NotNull
    @Enumerated(EnumType.STRING)
    private InterviewLevel interviewLevel;

    // 관리자 Entity 생기면 연결
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "admin_id")  // FK
    private Admin adminId;

    @NotNull
    @Column(length = 255)
    private String questionText;

    @Column(length = 255)
    private String intentText;

    @Column(length = 255)
    private String pointText;

    @Column(columnDefinition = "TEXT")
    private String intentVector;

    @Column(columnDefinition = "TEXT")
    private String pointVector;

    @Column(length = 255)
    private String answerText;

    @Column(columnDefinition = "TEXT")
    private String answerVector;

}
