package com.coach.chiselbot.domain.menuInfo;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuInfoRepository extends JpaRepository<MenuInfo, Long> {

    List<MenuInfo> findByParentIsNullOrderByMenuOrderAsc();

    boolean existsByMenuOrder(Integer menuOrder);

    List<MenuInfo> findByMenuOrderGreaterThanEqual(Integer menuOrder);

    List<MenuInfo> findAllByVisibleTrueOrderByMenuOrderAsc();

}
