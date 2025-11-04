package com.coach.chiselbot.domain.dashboard.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

public class DashBoardResponse {

    @Getter
    @Setter
    @Builder
    public static class DashBoardStat{
        private long totalUsers;
        private long todayUsers;
        private long todayInquiries;
        private long pendingInquiries;
    }

}
