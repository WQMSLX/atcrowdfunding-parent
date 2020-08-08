package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.dao.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    TRoleMapper roleMapper;
    @Autowired
    TAdminRoleMapper adminRoleMapper;

    @Override
    public List<Integer> listRoleByAdminId(Integer adminId) {
        return adminRoleMapper.listRoleByAdminId(adminId);
    }

    @Override
    public void saveRole(TRole role) {
        roleMapper.insert(role);
    }

    @Override
    public List<TRole> listRole() {
        return roleMapper.selectByExample(null);
    }

    @Override
    public PageInfo<TRole> listRole(Map<String, Object> paramMap) {
        String condition = (String) paramMap.get("condition");
        List<TRole> list = null;
        TRoleExample example = new TRoleExample();
        if (!StringUtils.isEmpty(condition)) {
            example.createCriteria().andNameLike("%" + condition + "%");
        }
        list = roleMapper.selectByExample(example);

        int navigatePages = 5;//设置默认的【1，2，3，4，5】标签个数
        return new PageInfo<TRole>(list, navigatePages);
    }

    @Override
    public TRole queryRoleById(Integer id) {
        return roleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateRole(TRole role) {
        roleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteById(Integer id) {
        roleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatchRole(String iStr) {
        String[] roleIdArr = iStr.split(",");
        List<Integer> list = new ArrayList<>();
        for (String s : roleIdArr) {
            list.add(Integer.parseInt(s));
        }
        TRoleExample example = new TRoleExample();
        example.createCriteria().andIdIn(list);
        roleMapper.deleteByExample(example);
    }
    @Override
    public void deleteAdminAndRoleRelationship(Integer adminId, Integer[] roleId) {
        adminRoleMapper.deleteAdminAndRoleRelationship(adminId, roleId);
    }
    @Override
    public void saveAdminAndRoleRelationship(Integer adminId, Integer[] roleId) {
        adminRoleMapper.saveAdminAndRoleRelationship(adminId, roleId);
    }
}
