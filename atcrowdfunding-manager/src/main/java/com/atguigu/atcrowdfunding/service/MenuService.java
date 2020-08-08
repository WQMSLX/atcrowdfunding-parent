package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TMenu;

import java.util.List;

/**
 * Packge: com.atguigu.atcrowdfunding.service
 *
 * @author 汪启明
 * @version v1.0.0
 * @create 2020-07-26-21:50
 **/
public interface MenuService {
    List<TMenu> listAllMenus();

    List<TMenu> listAllMenusTree();

    void addMenu(TMenu menu);

    TMenu getMenuById(Integer id);

    void updateMenu(TMenu menu);

    void deleteMenuById(Integer id);
}
