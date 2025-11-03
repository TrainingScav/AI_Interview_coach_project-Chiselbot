package com.coach.chiselbot._global.errors.adminException;

// 403 Forbidden 상황에서 사용할 커스텀 예외 클래스
public class AdminException403 extends RuntimeException {

    public AdminException403(String message) {
        super(message);
    }

    // 권한 없음.(본이이 작성한 게시글만 수정 가능)
    // 관리자만 접근 가능한 페이지
}
