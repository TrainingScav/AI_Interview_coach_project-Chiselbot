package com.coach.chiselbot.domain.user.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserResponseDTO {
	// JWT 토큰
	private final String token;
	// 사용자 식별 ID
	private final String userId;
	// 사용자 이름
	private final String name;
}