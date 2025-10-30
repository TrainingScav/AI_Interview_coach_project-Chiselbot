package com.coach.chiselbot._global.config;

import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import lombok.RequiredArgsConstructor;
import org.hibernate.sql.Insert;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;

@Component
@RequiredArgsConstructor
@Profile("dev")
@Order(1)
public class DataLoader implements CommandLineRunner {

    private final UserJpaRepository userJpaRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {

        User testUser1 = userJpaRepository.save(new User(
                null,
                "유저1",
                "test1@naver.com",
                passwordEncoder.encode("1234"),
                Timestamp.from(Instant.now()),
                null));

        User testUser2 = userJpaRepository.save(new User(
                null,
                "유저2",
                "test2@naver.com",
                passwordEncoder.encode("1234"),
                Timestamp.from(Instant.now()),
                null));


        User testUser3 = userJpaRepository.save(new User(
                null,
                "유저3",
                "test3@naver.com",
                passwordEncoder.encode("1234"),
                Timestamp.from(Instant.now()),
                null));
    }
}
