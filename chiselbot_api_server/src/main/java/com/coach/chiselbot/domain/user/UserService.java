package com.coach.chiselbot.domain.user;

import com.coach.chiselbot.domain.user.login.LoginStrategy;
import com.coach.chiselbot.domain.user.login.LoginStrategyFactory;
import com.coach.chiselbot.domain.user.service.dto.UserRequestDTO;
import com.coach.chiselbot.domain.user.service.dto.UserResponseDTO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserJpaRepository userJpaRepository;
    private final PasswordEncoder passwordEncoder;
    private final LoginStrategyFactory loginStrategyFactory;

    public User signUp(UserRequestDTO.SignUp dto) {

        if (userJpaRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");

        }
        String encodedPassword = passwordEncoder.encode(dto.getPassword());
        User newUser = new User();
        newUser.setName(dto.getName());
        newUser.setEmail(dto.getEmail());
        newUser.setPassword(encodedPassword);

        Timestamp now = Timestamp.from(Instant.now());
        newUser.setCreatedAt(now);

        return userJpaRepository.save(newUser);
    }

    @Transactional(readOnly = true)
    public User login(String type, UserRequestDTO.Login dto) {

        LoginStrategy strategy = loginStrategyFactory.findStrategy(type);

        return strategy.login(dto);

    }

    // 회원 수정
    public User update(String id, UserRequestDTO.Update dto) {
        User user = userJpaRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));

        user.setName(dto.getName());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setUpdatedAt(Timestamp.from(Instant.now()));

        return userJpaRepository.save(user);
    }

    // 회원 전체 조회

    // 회원 단건 조회
    @Transactional(readOnly = true)
    public Map<String,Object> findOne(String userEmail) {
        User user = userJpaRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("회원이 아닙니다"));

        return Map.of(
                "id", user.getId(),
                "name", user.getName(),
                "email", user.getEmail(),
                "createdAt", user.getCreatedAt(),
                "updatedAt", user.getUpdatedAt()
        );
    }


}
