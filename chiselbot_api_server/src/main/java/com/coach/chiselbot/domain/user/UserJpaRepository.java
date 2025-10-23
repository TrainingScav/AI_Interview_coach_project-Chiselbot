package com.coach.chiselbot.domain.user;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserJpaRepository extends JpaRepository<User, Long> {
    // 이메일 중복 여부 확인 - 메서드 쿼리 (Query Method) 기능 활용
    Optional<User> findByEmail(String email);
}
