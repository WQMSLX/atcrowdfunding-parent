package com.atguigu.atcrowdfunding.component;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.dao.TAdminMapper;
import com.atguigu.atcrowdfunding.dao.TPermissionMapper;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;

@Service
public class SecurityUserDetailServiceImpl implements UserDetailsService {
    @Autowired
    TAdminMapper adminMapper;

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TPermissionMapper permissionMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        //根据用户名查询信息
        TAdminExample example = new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(username);
        List<TAdmin> list = adminMapper.selectByExample(example);

        if (list == null || list.size() == 0) {
            return null;
        }
        TAdmin admin = list.get(0);
        Integer adminId = admin.getId();

        //2.根据用户id角色查询
        List<TRole> roleList = roleMapper.listRoleByAdminId(adminId);

        //2.根据用户id查询许可
        List<TPermission> permissionList = permissionMapper.listPermissionByAdminId(adminId);
        //4.构建权限集合
        //用角色表示全香港需要增加”ROLE_“
        HashSet<GrantedAuthority> authorities = new HashSet<>();
        for (TRole role : roleList) {
            authorities.add(new SimpleGrantedAuthority("ROLE_" + role));
        }
        for (TPermission permission : permissionList) {
            authorities.add(new SimpleGrantedAuthority(permission.getName()));
        }
        //5.返回查询结构，交给框架进行认证
        return new TAdminUser(admin, authorities);
    }
}
