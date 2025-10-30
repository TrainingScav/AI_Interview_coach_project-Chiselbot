package com.coach.chiselbot._global.dto;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class CommonResponseDto<T> {
    private boolean success;
    private T data;
    private String message;

    public static <T> CommonResponseDto<T> success(T data, String message) {
        return new CommonResponseDto<>(true, data, message);
    }

    public static <T> CommonResponseDto<T> success(T data) {
        return success(data, null);
    }

    public static <T> CommonResponseDto<T> error(String message) {
        return new CommonResponseDto<>(false, null, message);
    }

}
