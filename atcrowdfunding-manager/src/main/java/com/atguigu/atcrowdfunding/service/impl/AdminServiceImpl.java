package com.atguigu.atcrowdfunding.service.impl;/**
 * Packge: com.atguigu.atcrowdfunding.service.impl
 *
 * @author 汪启明
 * @create 2020-07-26-16:47
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TAdminRoleExample;
import com.atguigu.atcrowdfunding.dao.TAdminMapper;
import com.atguigu.atcrowdfunding.dao.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-26 16:47
 **/
@Service
public class AdminServiceImpl implements AdminService {
    final TAdminMapper tAdminMapper;


    @Autowired
    public AdminServiceImpl(TAdminMapper tAdminMapper) {
        this.tAdminMapper = tAdminMapper;
    }

    @Override
    public TAdmin getAdminByLoginacct(String loginacct, String userpswd) {
        TAdminExample example = new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(loginacct);
        List<TAdmin> list = tAdminMapper.selectByExample(example);
        if (list == null || list.size() == 0) {
            throw new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }
        TAdmin admin = list.get(0);
        if (!admin.getUserpswd().equals(MD5Util.digest(userpswd))) {
            throw new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }
        return admin;
    }

    @Override
    public PageInfo<TAdmin> listPage(HashMap<String, Object> paramMap) {
        TAdminExample example = new TAdminExample();//相当于null
        String condition = (String) paramMap.get("condition");
        System.out.println(condition);
        if (!StringUtils.isEmpty(condition)) {
            example.createCriteria().andLoginacctLike("%" + condition + "%");
            TAdminExample.Criteria criteria2 = example.createCriteria();
            criteria2.andUsernameLike("%" + condition + "%");
            TAdminExample.Criteria criteria3 = example.createCriteria();
            criteria3.andEmailLike("%" + condition + "%");

            example.or(criteria2);
            example.or(criteria3);
        }
        //Limit索引是0可以省路
        List<TAdmin> list = tAdminMapper.selectByExample(example);//limit ?,? ->limit(pageNum)  (pageNum-1)*pageSize,pageSize
        int navigatePages = 5;
        PageInfo<TAdmin> page = new PageInfo<>(list, navigatePages);
        return page;
    }

    @Override
    public void saveAddmin(TAdmin admin) {
        admin.setUserpswd(MD5Util.digest(Const.DEFALUT_PASSWORD));
        admin.setCreatetime(DateUtil.getFormatTime());

        tAdminMapper.insertSelective(admin);//属性为null的不参与SQL语句的生成。所谓的动态sql.
    }

    @Override
    public TAdmin getAdminById(Integer id) {
        return tAdminMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateAdmin(TAdmin admin) {//这里可以和save合并
        tAdminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public void deleteAdminById(Integer id) {
        tAdminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatch(String ids) {
        if (!StringUtils.isEmpty(ids)) {
            String[] idArr = ids.split(",");
            List<Integer> listId = new ArrayList<>();
            for (String s : idArr) {
                int i = Integer.parseInt(s);
                listId.add(i);
            }
            TAdminExample example = new TAdminExample();
            example.createCriteria().andIdIn(listId);
            tAdminMapper.deleteByExample(example);
        }
    }



}
