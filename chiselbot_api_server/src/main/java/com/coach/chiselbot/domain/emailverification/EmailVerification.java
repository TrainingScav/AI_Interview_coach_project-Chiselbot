package com.coach.chiselbot.domain.emailverification;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Entity
@Table(name = "email_verifications")
@Getter
@Setter
public class EmailVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "verification_id")
    private Long verificationId;

    @Column(name = "created_at", nullable = false)
    private Timestamp createdAt;

    @Column(name = "email", nullable = false, length = 255)
    private String email;

    @Column(name = "expired_at", nullable = false)
    private Timestamp expiredAt;

    @Column(name = "is_verified", nullable = false, length = 1)
    private String isVerified; // 'Y' or 'N'

    @Column(name = "verification_code", nullable = false, length = 100)
    private String codeHash;
}
