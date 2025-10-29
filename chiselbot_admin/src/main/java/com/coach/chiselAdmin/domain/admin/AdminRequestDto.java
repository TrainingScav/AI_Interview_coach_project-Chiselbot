package com.coach.chiselAdmin.domain.admin;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

public class AdminRequestDto {

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Login {
        private String email;
        private String password;
    }
}