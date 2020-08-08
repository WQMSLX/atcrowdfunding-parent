package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

public interface RoleService {
    List<Integer> listRoleByAdminId(Integer adminId);

    void saveRole(TRole role);

    PageInfo<TRole> listRole(Map<String, Object> paramMap);
    List<TRole> listRole();


    TRole queryRoleById(Integer id);

    void updateRole(TRole role);

    void deleteById(Integer id);

    void deleteBatchRole(String iStr);

    void saveAdminAndRoleRelationship(Integer adminId, Integer[] roleId);

    void deleteAdminAndRoleRelationship(Integer adminId, Integer[] roleId);
}
