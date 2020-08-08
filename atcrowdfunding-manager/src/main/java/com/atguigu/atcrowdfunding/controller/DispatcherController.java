package com.atguigu.atcrowdfunding.controller;/**
 * Packge: com.atguigu.atcrowdfunding.controller
 *
 * @author 汪启明
 * @create 2020-07-26-16:08
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.atguigu.atcrowdfunding.util.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-26 16:08
 **/
@Controller
public class DispatcherController {
    @Autowired
    AdminService adminService;

    @Autowired
    MenuService menuService;

/*
  //被springSecurity框架替代
    @RequestMapping("/login")
    public String login(String loginacct, String userpswd, HttpSession httpSession, Model model) {
        try {
            TAdmin admin = adminService.getAdminByLoginacct(loginacct, userpswd);
            httpSession.setAttribute("loginAdmin", admin);
            return "redirect:/main";//   /当前路径 没有斜向项目路径
        } catch (LoginException e) {
            e.printStackTrace();
            model.addAttribute("message", e.getMessage());
            return "forward:login.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", Const.SYSTEM_ERROR);
            return "forward:login.jsp";
        }



        //return "main";直接跳转页面会导致表单的重复提交
    }
*/
    @RequestMapping("/main")
    public String main(HttpSession httpSession) {
        List<TMenu> menus = menuService.listAllMenus();
        httpSession.setAttribute("parentMenuList", menus);
        /*menus.forEach(System.out::println);*/
        return "main";
    }

/*    @RequestMapping("/logout")
    public String logout(HttpSession httpSession) {
        if (httpSession != null) {
            httpSession.invalidate();
        }
        return "redirect:login.jsp";
    }*/
}
