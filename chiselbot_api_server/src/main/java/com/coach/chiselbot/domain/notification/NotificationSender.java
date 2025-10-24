package com.coach.chiselbot.domain.notification;

public interface NotificationSender {
    void send(NotifyCommand cmd);

    boolean supports(String type);
}
