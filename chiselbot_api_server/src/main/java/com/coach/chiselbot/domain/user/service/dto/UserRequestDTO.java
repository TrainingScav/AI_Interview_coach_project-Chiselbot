package com.coach.chiselbot.domain.user.service.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.EmbeddableInstantiator;


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


}
