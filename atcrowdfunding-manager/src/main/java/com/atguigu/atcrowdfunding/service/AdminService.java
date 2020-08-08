package com.atguigu.atcrowdfunding.service;/**
 * Packge: com.atguigu.atcrowdfunding.service
 *
 * @author 汪启明
 * @create 2020-07-26-16:45
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-26 16:45
 **/

public interface AdminService {
    TAdmin getAdminByLoginacct(String loginacct, String userpswd);

    PageInfo<TAdmin> listPage(HashMap<String, Object> paramMap);

    void saveAddmin(TAdmin admin);

    TAdmin getAdminById(Integer id);

    void updateAdmin(TAdmin admin);

    void deleteAdminById(Integer id);

    void deleteBatch(String ids);



}
