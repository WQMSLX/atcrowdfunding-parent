package com.atguigu.atcrowdfunding.service;/**
 * Packge: com.atguigu.atcrowdfunding.service
 *
 * @author 汪启明
 * @create 2020-07-30-16:09
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TPermission;

import java.util.List;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-30 16:09
 **/

public interface PermissionService {
    public List<TPermission> listPermission();

    void addPermission(TPermission permission);

    TPermission getPermission(Integer id);

    void updateService(TPermission permission);

    void deletePermission(Integer id);
}
