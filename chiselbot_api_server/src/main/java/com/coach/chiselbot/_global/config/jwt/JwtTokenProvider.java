package com.coach.chiselbot._global.config.jwt;

import com.coach.chiselbot.domain.user.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SecurityException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Slf4j
@Component
public class JwtTokenProvider {

    private final SecretKey key;
    private final long validityInmilliseconds;

    public JwtTokenProvider(@Value("${jwt.secret}") String secretKey,
                            @Value("${jwt.expiration-in-ms}") long validityInmilliseconds) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);

        this.key = Keys.hmacShaKeyFor(keyBytes);
        this.validityInmilliseconds = validityInmilliseconds;
    }

    public String createToken(User user) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + validityInmilliseconds);

        return Jwts.builder()
                .subject(user.getEmail())
                .issuedAt(now)
                .expiration(validity)
                .signWith(key)
                .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .verifyWith(key)
                    .build().parseSignedClaims(token);
            return true;
        } catch (SecurityException | MalformedJwtException e) {
            log.error("잘못된 JWT 서명 입니다.", e);
        } catch (ExpiredJwtException e) {
            log.error("만료된 JWT 토큰입니다");
        } catch (UnsupportedJwtException e) {
            log.error("지원되지 않는 JWT 토큰입니다");
        } catch (Exception e) {
            log.error("JWT 토큰이 잘못되었습니다");
        }
        return false;
    }

    public String getSubject(String token) {
        return parseClaims(token).getSubject();
    }

    private Claims parseClaims(String token) {
        try{
            return Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }
}
