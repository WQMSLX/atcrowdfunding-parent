package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class MenuController {

    @Autowired
    MenuService menuService;

    @RequestMapping("/menu/index")
    public String index() {
        return "menu/index";
    }

    @ResponseBody
    @RequestMapping("/menu/loadTree")
    public List<TMenu> loadTree() {

       return menuService.listAllMenusTree();

    }
    @ResponseBody
    @RequestMapping("/menu/addMenu")
    public String addMenu(TMenu menu){
        menuService.addMenu(menu);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/menu/get")
    public TMenu getMenuById(Integer id){
        return menuService.getMenuById(id);
    }
    @ResponseBody
    @RequestMapping("/menu/update")
    public String updateMenu(TMenu menu){
        menuService.updateMenu(menu);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/menu/delete")
    public String deleteMenuById(Integer id){
        menuService.deleteMenuById(id);
        return "ok";
    }
}
