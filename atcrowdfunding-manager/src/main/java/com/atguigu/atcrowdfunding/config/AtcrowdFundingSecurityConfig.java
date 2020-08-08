package com.atguigu.atcrowdfunding.config;

import com.atguigu.atcrowdfunding.component.SecurityUserDetailServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@EnableGlobalMethodSecurity(prePostEnabled = true)
@EnableWebSecurity//
@Configuration//声明一个配置
public class AtcrowdFundingSecurityConfig extends WebSecurityConfigurerAdapter {
    @Autowired
    UserDetailsService userDetailsService;
/*
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }*/


    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        //super.configure(auth);//取消默认的认证
        auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());

    }


    @Override
    protected void configure(HttpSecurity http) throws Exception {
       // super.configure(http);
        //1.允许访问所有静态资源
        http.authorizeRequests().antMatchers("/static/**", "/login.jsp").permitAll()
                .anyRequest().authenticated();//剩下的都需要认证

        //login.jsp==post yong
        //2.授权登陆页面
        http.formLogin().loginPage("/login.jsp")//指定登陆页面
                .loginProcessingUrl("/login")//登录页form表单提交的地址
                .usernameParameter("loginacct")
                .passwordParameter("userpswd")
                .defaultSuccessUrl("/main");//这样注册注销就用框架完成了代替，自己写的
        //3.授权注销
        http.logout().logoutUrl("/logout").logoutSuccessUrl("/login.jsp");

        //4.同意异常处理403
        //4.统一异常处理。403
        http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
            @Override
            public void handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException, ServletException {
                //同步请求  VS  异步请求
                //处理的方式是不一样的。
                //同步请求直接跳转到错误的页面就可以了；异步请求，需要返回一个错误的标识；
                //X-Requested-With: XMLHttpRequest   异步请求会携带这个请求头信息。同步请求不会携带。
                String s = httpServletRequest.getHeader("X-Requested-With");
                if("XMLHttpRequest".endsWith(s)){ //异步
                    httpServletResponse.getWriter().print("403");
                }else{//同步
                    httpServletRequest.getRequestDispatcher("/WEB-INF/jsp/error/error403.jsp")
                            .forward(httpServletRequest,httpServletResponse);
                }

            }
        });
        //5.授权记住我的功能
        http.rememberMe();
        //禁用csrf
        http.csrf().disable();

    }
}
