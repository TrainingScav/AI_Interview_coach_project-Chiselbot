package com.coach.chiselbot.domain.notification;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Builder
public class NotifyCommand {
    private String type;
    private String to;
    private String subject;
    private String body;


}
