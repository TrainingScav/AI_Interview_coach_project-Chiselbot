package com.coach.chiselAdmin._global.config;

import com.coach.chiselAdmin.domain.admin.Admin;
import com.coach.chiselAdmin.domain.admin.AdminRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Profile("local")
@Order(2)
public class AdminDataLoader implements CommandLineRunner {

    private final AdminRepository adminRepository;

    @Override
    public void run(String... args) throws Exception {
        if (adminRepository.count() == 0) {
            Admin admin = Admin.builder()
                    .adminName("관리자")
                    .email("admin@chisel.com")
                    .password("1234")
                    .build();

            adminRepository.save(admin);
            System.out.println("기본 관리자 계정 생성 완료: admin@chisel.com");
        } else {
            System.out.println("Admin 데이터 이미 존재하므로 로드 생략");
        }
    }
}
