package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.Const;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
public class AdminController {
    @Autowired
    AdminService adminService;
    @Autowired
    RoleService roleService;

    @RequestMapping("/admin/index")
    public String index(
            @RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", required = false, defaultValue = "10") Integer pageSize,
            @RequestParam(value = "condition", required = false, defaultValue = "") String condition,
            Model model) {
        //1.开启分页插件功能
        PageHelper.startPage(pageNum, pageSize);//将数据通过ThreadLocal绑定到线程上，传给后续 流程
        //2.获取分页数据。业务层调用dao获取数据，并封装成分页插件
        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("condition", condition);
        PageInfo<TAdmin> page = adminService.listPage(paramMap);


        //3数据存储
        model.addAttribute("page", page);
        return "admin/index";
    }

    @RequestMapping("/admin/toAdd")
    public String toAdd() {
        return "admin/add";
    }

    @RequestMapping("/admin/doAdd")
    public String doAdd(TAdmin admin) {
    admin.setUserpswd(new BCryptPasswordEncoder().encode(Const.DEFALUT_PASSWORD));
        adminService.saveAddmin(admin);
        return "redirect:/admin/index?pageNum=" + Integer.MAX_VALUE;
    }

    @RequestMapping("/admin/toUpdate")
    public String toUpdate(Integer id, Model model) {
        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin", admin);
        return "admin/update";
    }

    @RequestMapping("/admin/doUpdate")
    public String doUpdate(TAdmin admin, Integer pageNum) {
        adminService.updateAdmin(admin);
        return "redirect:/admin/index?pageNum=" + pageNum;
    }

    @RequestMapping("/admin/deleteAdmin")
    public String deleteAdmin(Integer id, Integer pageNum) {
        adminService.deleteAdminById(id);
        return "redirect:/admin/index?pageNum=" + pageNum;
    }

    @RequestMapping("/admin/deleteBatch")
    public String deleteBatch(String ids, String pageNum) {
        adminService.deleteBatch(ids);
        return "redirect:/admin/index?pageNum=" + pageNum;

    }

    @RequestMapping("/admin/assignRole")
    public String toAssignRole(Integer adminId,Model model) {
        System.out.println("adminId=====>"+adminId);
        //1.查询用户所拥有的的角色
        List<Integer> listRoleId = roleService.listRoleByAdminId(adminId);
        //2.查询所有角色
        List<TRole> listRole = roleService.listRole();
        ArrayList<TRole> assignRoleList = new ArrayList<>();
        ArrayList<TRole> unAssignRoleList = new ArrayList<>();
        for (TRole role : listRole) {
            if(listRoleId.contains(role.getId())){
                assignRoleList.add(role);
            }else{
                unAssignRoleList.add(role);
            }
        }
        model.addAttribute("adminId",adminId);
        model.addAttribute("assignList",assignRoleList);
        model.addAttribute("unAssignList",unAssignRoleList);
        return "admin/assignRole";
    }
    @ResponseBody
    @RequestMapping("/admin/doAssignRoleToAdmin")
    public String doAssignRoleToAdmin(@RequestBody String idStr) {
        System.out.println("str===>"+idStr);
        String[] id = idStr.split(",");
        Integer adminId=Integer.parseInt(id[0]);
        Integer [] roleId=new Integer[id.length-1];
        for (int i = 1; i <id.length ; i++) {
            roleId[i-1]=Integer.parseInt(id[i]);
        }
        roleService.saveAdminAndRoleRelationship(adminId, roleId);

        return "ok";
    }

    @ResponseBody
    @RequestMapping("/admin/doUnAssignRoleToAdmin")
    public String doUnAssignRoleToAdmin(@RequestBody String str) {
        System.out.println(str);
        String[] ids = str.split(",");
        Integer adminId=Integer.parseInt(ids[0]);
        Integer [] roleId=new Integer[ids.length-1];
        for (int i = 1; i <ids.length ; i++) {
            roleId[i-1]=Integer.parseInt(ids[i]);
        }
        roleService.deleteAdminAndRoleRelationship(adminId, roleId);
        return "ok";
    }
}
