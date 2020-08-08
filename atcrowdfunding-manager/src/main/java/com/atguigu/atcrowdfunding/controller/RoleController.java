package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class RoleController {
    @Autowired
    RoleService roleService;

    @ResponseBody
    @RequestMapping("/role/loadData")
    public PageInfo<TRole> localData(@RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
                                     @RequestParam(value = "pageSize", required = false, defaultValue = "5") Integer pageSize,
                                     @RequestParam(value = "condition", required = false, defaultValue = "") String condition) {
        System.out.println("loadData-->start");
        PageHelper.startPage(pageNum, pageSize);
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("condition",condition);
        //System.out.println("listPage-->runOver");
        return roleService.listRole(paramMap);
    }

    @RequestMapping(value = "/role/index")
    public String roleIndex() {
        return "role/index";
    }

    @ResponseBody
    @RequestMapping(value="/role/add")
    public String doAdd(TRole role) {
        System.out.println("doAdd-->role");
        roleService.saveRole(role);
        return "ok";
    }

    @ResponseBody
    @RequestMapping(value="/role/getRoleById")
    public TRole queryRoleById(Integer id){
        System.out.println("do===>queryROleById");
        System.out.println(id);
        return roleService.queryRoleById(id);
    }
    @ResponseBody
    @RequestMapping(value="/role/update")
    public String update(TRole role){

        System.out.println("do=======>updateRole");
        System.out.println("id"+role.getId()+"name"+role.getName());
        roleService.updateRole(role);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/role/delete")
    public String deleteById(Integer id){

        roleService.deleteById(id);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/role/deleteBatch")
    public String deleteBatch(String iStr){
        roleService.deleteBatchRole(iStr);
        return "ok";
    }
}
