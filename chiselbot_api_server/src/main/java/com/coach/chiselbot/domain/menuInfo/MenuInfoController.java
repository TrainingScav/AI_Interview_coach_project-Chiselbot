package com.coach.chiselbot.domain.menuInfo;

import com.coach.chiselbot._global.common.Define;
import com.coach.chiselbot._global.dto.CommonResponseDto;
import com.coach.chiselbot.domain.menuInfo.dto.MenuInfoRequest;
import com.coach.chiselbot.domain.menuInfo.dto.MenuInfoResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/menus")
@RequiredArgsConstructor
public class MenuInfoController {
    private final MenuInfoService menuInfoService;

    @GetMapping
    public String menuInfoPage(Model model) {
        List<MenuInfoResponse.FindAll> menuInfos = menuInfoService.getAllMenus();
        model.addAttribute("menuInfo",  menuInfos);
        return "menuInfo/menuInfo_list";
    }

    // 중복검사
    @GetMapping("/checkOrder")
    @ResponseBody
    public ResponseEntity<?> checkOrder(@RequestParam(name = "menuOrder") Integer menuOrder){
        boolean exists = menuInfoService.existsByMenuOrder(menuOrder);
        return ResponseEntity.ok(CommonResponseDto.success(exists));
    }

//    @PostMapping("/create")
//    @ResponseBody
//    public ResponseEntity<?> createMenu(MenuInfoRequest.CreateMenu request){
//
//        MenuInfoResponse.FindById newMenu = menuInfoService.createMenu(request);
//
//        return ResponseEntity.ok(CommonResponseDto.success(newMenu, Define.SUCCESS));
//    }

    @PostMapping("/create")
    public String createMenu(MenuInfoRequest.CreateMenu request, RedirectAttributes rttr){
        menuInfoService.createMenu(request);
        rttr.addFlashAttribute("message", Define.SUCCESS);
        return "redirect:/admin/menus";
    }

//    @PostMapping("/update/{id}")
//    public ResponseEntity<?> updateMenu(@PathVariable(name = "id") Long menuId ,
//                                        MenuInfoRequest.UpdateMenu request){
//
//        MenuInfoResponse.FindById updateMenu = menuInfoService.updateMenu(menuId, request);
//
//        return ResponseEntity.ok(CommonResponseDto.success(updateMenu, Define.SUCCESS));
//    }

    @PostMapping("/update/{id}")
    public String updateMenu(@PathVariable(name = "id") Long menuId ,
                             MenuInfoRequest.UpdateMenu request,
                             RedirectAttributes rttr){

        menuInfoService.updateMenu(menuId, request);
        rttr.addFlashAttribute("message", Define.SUCCESS);

        return "redirect:/admin/menus";
    }

    @GetMapping("/delete/{id}")
    public String deleteMenu(@PathVariable Long id, RedirectAttributes rttr) {
        menuInfoService.deleteMenu(id);
        rttr.addFlashAttribute("message", Define.SUCCESS);
        return "redirect:/admin/menus";
    }

    @GetMapping("/create")
    public String createMenuForm(){
        return "menuInfo/menuInfo_form";
    }

    @GetMapping("/update/{id}")
    public String detailMenu(@PathVariable(name = "id") Long id, Model model){
        MenuInfoResponse.FindById menu = menuInfoService.findById(id);
        model.addAttribute("menu", menu);

        return "menuInfo/menuInfo_update";
    }
}
