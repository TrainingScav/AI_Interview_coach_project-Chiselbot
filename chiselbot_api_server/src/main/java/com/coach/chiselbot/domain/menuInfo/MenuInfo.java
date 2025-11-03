package com.coach.chiselbot.domain.menuInfo;

import com.coach.chiselbot._global.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "menu_info")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MenuInfo extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String menuName; // 메뉴명

    @Column(nullable = false, length = 50, unique = true)
    private String menuCode; // 내부 코드명 (예: MY_PAGE, SAVED_BOX)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private MenuInfo parent; // 상위 메뉴

    @Column
    private Integer menuOrder; // 메뉴 순서

    @Column(length = 255)
    private String urlPath; // URL 경로


    // @Builder는 기본값(필드 초기화값)을 무시함
    // 이럴 땐 반드시 @Builder.Default를 써서 초기값 세팅이 되도록 해야함.
    @Builder.Default
    @Column(nullable = false)
    private Boolean visible = true; // 노출 여부

    @Column(length = 255)
    private String description; // 설명
}
