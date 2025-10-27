package com.coach.chiselAdmin.domain.admin;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AdminRepository extends JpaRepository<Admin, Long> {
    // 이메일 중복 여부 확인 - 메서드 쿼리 (Query Method) 기능 활용
    Optional<Admin> findByEmail(String email);
}
