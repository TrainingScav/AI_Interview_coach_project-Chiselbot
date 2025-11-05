package com.coach.chiselbot.domain.user.login;

import com.coach.chiselbot._global.config.oauth.kakao.KakaOAuthClient;
import com.coach.chiselbot.domain.kakao.RedirectRequiredException;
import com.coach.chiselbot.domain.kakao.dto.KakaoUserInfoResponseDto;
import com.coach.chiselbot.domain.user.Provider;
import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import com.coach.chiselbot.domain.user.dto.UserRequestDTO;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

@Component
@RequiredArgsConstructor
public class KakaoLoginStrategy implements LoginStrategy {

    @Value("${oauth.kakao.client-id}")
    private String clientId;

    @Value("${oauth.kakao.redirect-uri}")
    private String redirectUri;


    private final KakaOAuthClient kakaOAuthClient;
    private final UserJpaRepository userJpaRepository;

    @PostConstruct
    public void init() { System.out.println("✅ Kakao Client ID: " + clientId); System.out.println("✅ Kakao Redirect URI: " + redirectUri); }

    @Override
    public User login(UserRequestDTO.Login dto) {
        if (dto.getAuthCode() == null || dto.getAuthCode().isBlank()) {
            String kakaoAuthUrl = UriComponentsBuilder
                    .fromUriString("https://kauth.kakao.com/oauth/authorize")
                    .queryParam("response_type", "code")
                    .queryParam("client_id", clientId)
                    .queryParam("redirect_uri", redirectUri)
                    .build()
                    .toUriString();

            throw new RedirectRequiredException(kakaoAuthUrl);
        }

        String accessToken = kakaOAuthClient.getAccessToken(dto.getAuthCode());

        KakaoUserInfoResponseDto kakaoUser = kakaOAuthClient.getUserInfo(accessToken);

        String email = kakaoUser.getKakaoAccount().getEmail();
        String nickname = kakaoUser.getKakaoAccount().getProfile().getNickName();

        return userJpaRepository.findByEmail(email)
                .orElseGet(() -> userJpaRepository.save(
                        User.builder()
                                .email(email)
                                .name(nickname)
                                .provider(Provider.KAKAO)
                                .build()
                ));
    }

    @Override
    public boolean supports(String type) {
        return "kakao" .equalsIgnoreCase(type);
    }
}
