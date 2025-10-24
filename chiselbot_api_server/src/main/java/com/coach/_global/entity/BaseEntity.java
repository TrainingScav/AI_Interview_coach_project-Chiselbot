package com.coach._global.entity;


import jakarta.persistence.Column;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@EntityListeners(value = {AuditingEntityListener.class})
@Getter
@MappedSuperclass
/*
@MappedSuperclass:
 JPA 에서 공통 엔티티 속성을 상속받기 위해 사용
  */
// 등록시간, 수정시간 등록 - 상속받으면 알아서 생성됨
public class BaseEntity {
    @CreatedDate
    @Column(name = "regdate", updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "moddate")
    private LocalDateTime modifiedAt;
}
