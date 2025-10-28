package com.coach.chiselbot.domain.emailverification;

import com.coach.chiselbot.domain.notification.NotificationSender;
import com.coach.chiselbot.domain.notification.NotificationSenderFactory;
import com.coach.chiselbot.domain.notification.NotifyCommand;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.util.Optional;

@Transactional
@Service
@RequiredArgsConstructor
public class EmailVerificationService {

    private final EmailVerificationJpaRepository repository;
    private final NotificationSenderFactory senderFactory;
    private final PasswordEncoder passwordEncoder;

    private final Duration ttl = Duration.ofMinutes(5);
    private final SecureRandom secureRandom = new SecureRandom();

    public void sendCode(String rawEmail) {
        String email = normalizeEmail(rawEmail);
        Instant now = Instant.now();

        String code = generateNumericCode(6);
        String hash = passwordEncoder.encode(code);

        EmailVerification ev = new EmailVerification();
        ev.setEmail(email);
        ev.setCreatedAt(Timestamp.from(now));
        ev.setExpiredAt(Timestamp.from(now.plus(ttl)));
        ev.setIsVerified("N");
        ev.setCodeHash(hash);
        repository.save(ev);

        NotificationSender sender = senderFactory.findSender("EMAIL");
        String subject = "[Chiselbot] 이메일 인증";
        String body = "인증 코드: " + code + "\n유효시간: 5분";
        NotifyCommand cmd = NotifyCommand.builder()
                .type("EMAIL")
                .to(email)
                .subject(subject)
                .body(body)
                .build();
        sender.send(cmd);
    }

    public boolean verifyCode(String rawEmail, String inputCode) {
        String email = normalizeEmail(rawEmail);
        String code  = (inputCode == null) ? "" : inputCode.trim();
        Instant now = Instant.now();

        Optional<EmailVerification> opt = repository.findTopByEmailOrderByVerificationIdDesc(email);
        if (!opt.isPresent()) {
            return false;
        }
        EmailVerification ev = opt.get();

        if ("Y".equals(ev.getIsVerified())) {
            return true; // 이미 인증됨(최신이 인증 상태면 통과)
        }
        if (now.isAfter(ev.getExpiredAt().toInstant())) {
            return false; // 만료
        }

        boolean ok = passwordEncoder.matches(inputCode, ev.getCodeHash());
        if (!ok) {
            return false;
        }

        ev.setIsVerified("Y");
        repository.save(ev);
        return true;
    }

    private String normalizeEmail(String rawEmail) {
        return rawEmail == null ? null : rawEmail.trim().toLowerCase();
    }

    private String generateNumericCode(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int digit = this.secureRandom.nextInt(10);
            sb.append(digit);
        }
        return sb.toString();
    }

    @Transactional(readOnly = true)
    public boolean isRecentlyVerified(String rawEmail) {
        String email = normalizeEmail(rawEmail);
        java.util.Optional<EmailVerification> opt =
                repository.findTopByEmailOrderByVerificationIdDesc(email);
        if (!opt.isPresent()) {
            return false;
        }
        EmailVerification ev = opt.get();
        return "Y".equals(ev.getIsVerified()); // 최신 레코드가 인증 완료(Y)여야 함
    }

}
