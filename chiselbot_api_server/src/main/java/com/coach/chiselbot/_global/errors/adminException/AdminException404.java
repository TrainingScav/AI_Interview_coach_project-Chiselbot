package com.coach.chiselbot._global.errors.adminException;

// 404 Not Found 상황에서 사용할 커스텀 예외 클래스
public class AdminException404 extends RuntimeException {

    // 에러 메세지로 사용할 문자열을 super 클래스에게 전달
    public AdminException404(String message) {
        super(message);
    }

    // 요청한 리소스가 없을 때 ..
}
