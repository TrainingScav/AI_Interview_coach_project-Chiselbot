package com.coach.chiselbot.domain.menuInfo.dto;

import com.coach.chiselbot.domain.menuInfo.MenuInfo;
import lombok.Getter;
import lombok.Setter;

public class MenuInfoRequest {

    @Getter
    @Setter
    public static class CreateMenu {
        private String menuName;
        private String menuCode;
        private MenuInfo parent;
        private Integer menuOrder;
        private String urlPath;
        private Boolean visible = true;
        private String description;
    }


    @Getter
    @Setter
    public static class UpdateMenu {
        private String menuName;
        private String menuCode;
        private MenuInfo parent;
        private Integer menuOrder;
        private String urlPath;
        private Boolean visible;
        private String description;
    }
}
