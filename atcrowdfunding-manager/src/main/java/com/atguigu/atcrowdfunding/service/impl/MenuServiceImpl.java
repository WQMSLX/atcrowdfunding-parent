package com.atguigu.atcrowdfunding.service.impl;/**
 * Packge: com.atguigu.atcrowdfunding.service.impl
 *
 * @author 汪启明
 * @create 2020-07-26-21:51
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.dao.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-26 21:51
 **/
@Service
public class MenuServiceImpl implements MenuService {
    @Autowired
    TMenuMapper tMenuMapper;

    @Override
    public List<TMenu> listAllMenus() {
        List<TMenu> parentList = new ArrayList<>();
        Map<Integer, TMenu> cache = new HashMap<>();
        List<TMenu> menuList = tMenuMapper.selectByExample(null);
        for (TMenu tMenu : menuList) {
            Integer pid = tMenu.getPid();
            if (pid == 0) {
                parentList.add(tMenu);
                cache.put(tMenu.getId(), tMenu);
            }
        }
        for (TMenu tMenu : menuList) {
            Integer pid = tMenu.getPid();
            if (pid != 0) {
                TMenu parent = cache.get(pid);//
                parent.getChildren().add(tMenu);
            }
        }
        return parentList;
    }

    @Override
    public List<TMenu> listAllMenusTree() {
        /**
         * @description:  
         * 查询所有
         * @return: java.util.List<com.atguigu.atcrowdfunding.bean.TMenu>
         * @author: 汪启明
         * @time: 2020/7/29 12:12
         */
        // menus.forEach(System.out::println);
        return tMenuMapper.selectByExample(null);
       
    }

    @Override
    public void addMenu(TMenu menu) {
        tMenuMapper.insert(menu);
    }

    @Override
    public TMenu getMenuById(Integer id) {
        return tMenuMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateMenu(TMenu menu) {
        tMenuMapper.updateByPrimaryKeySelective(menu);
    }

    @Override
    public void deleteMenuById(Integer id) {
        tMenuMapper.deleteByPrimaryKey(id);
    }
}
