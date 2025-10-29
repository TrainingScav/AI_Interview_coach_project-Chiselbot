package com.coach.chiselAdmin.domain.menuInfo;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MenuInfoService {

    private final MenuInfoRepository menuInfoRepository;

    /**
     * 전체 메뉴 목록 조회 (부모-자식 포함)
     */
    public List<MenuInfo> getAllMenus() {
        return menuInfoRepository.findAll();
    }

    /**
     * 루트 메뉴만 조회 (parent_id가 null)
     */
    public List<MenuInfo> getRootMenus() {
        return menuInfoRepository.findByParentIsNullOrderByMenuOrderAsc();
    }
}
