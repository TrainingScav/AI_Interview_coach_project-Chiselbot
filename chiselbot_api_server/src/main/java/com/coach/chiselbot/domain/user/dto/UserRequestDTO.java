package com.coach.chiselbot.domain.user.dto;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

public class UserRequestDTO {

    @Getter
    @Setter
    public static class SignUp {

        @NotEmpty
        @Size(min = 2, max = 20)
        private String name;

        @NotEmpty
        @Email
        @Pattern(regexp = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$", message = "유효한 이메일 형식이 아닙니다.")
        private String email;

        @NotEmpty
        @Size(min = 4, max = 20)
        private String password;

        private Timestamp createdAt;
    }

    @Getter
    @Setter
    public static class Login{
        @NotEmpty
        @Email
        @Pattern(regexp = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$", message = "유효한 이메일 형식이 아닙니다.")
        private String email;
        private String password;
    }

    @Getter
    @Setter
    public static class Update {

        private String email;

        @NotBlank
        @Size(min = 2, max = 20)
        private String name;

        @NotBlank
        @Size(min = 4, max = 20, message = "비밀번호는 4자 이상 필수입니다")
        private String password;

        private Timestamp updatedAt;
    }


}