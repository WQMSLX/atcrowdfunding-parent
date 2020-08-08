package com.atguigu.atcrowdfunding.service.impl;/**
 * Packge: com.atguigu.atcrowdfunding.service.impl
 *
 * @author 汪启明
 * @create 2020-07-30-16:10
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TPermissionMenu;
import com.atguigu.atcrowdfunding.dao.TPermissionMapper;
import com.atguigu.atcrowdfunding.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-30 16:10
 **/
@Service
public class PermissionServiceImpl implements PermissionService {
    @Autowired
    TPermissionMapper permissionMapper;

    @Override
    public List<TPermission> listPermission() {
        return permissionMapper.selectByExample(null);
    }

    @Override
    public void addPermission(TPermission permission) {
        permissionMapper.insertSelective(permission);
    }

    @Override
    public TPermission getPermission(Integer id) {
        return permissionMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateService(TPermission permission) {
        permissionMapper.updateByPrimaryKeySelective(permission);
    }

    @Override
    public void deletePermission(Integer id) {
        permissionMapper.deleteByPrimaryKey(id);
    }
}
