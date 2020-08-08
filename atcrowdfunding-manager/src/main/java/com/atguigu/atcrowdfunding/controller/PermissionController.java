package com.atguigu.atcrowdfunding.controller;/**
 * Packge: com.atguigu.atcrowdfunding.controller
 *
 * @author 汪启明
 * @create 2020-07-30-14:58
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-30 14:58
 **/
@Controller
public class PermissionController {
    @Autowired
    PermissionService permissionService;

    @RequestMapping("/permission/index")
    public String toPermission() {
        return "permission/index";
    }
    @ResponseBody
    @RequestMapping("/permission/loadTree")
    public List<TPermission> loadPermissionTree(){
        return permissionService.listPermission();
    }

    @ResponseBody
    @RequestMapping("/permission/add")
    public String addPermission(TPermission permission){
    permissionService.addPermission(permission);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/permission/get")
    public TPermission getPermission(Integer id){
        return permissionService.getPermission(id);
    }
    @ResponseBody
    @RequestMapping("/permission/update")
    public String updatePermission(TPermission permission){
        permissionService.updateService(permission);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/permission/delete")
    public String deletePermission(Integer id){
        permissionService.deletePermission(id);
        return "ok";
    }
}
