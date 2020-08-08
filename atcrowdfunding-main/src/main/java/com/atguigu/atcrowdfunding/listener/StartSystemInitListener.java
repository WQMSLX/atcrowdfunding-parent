package com.atguigu.atcrowdfunding.listener;/**
 * Packge: com.atguigu.atcrowdfunding.listener
 *
 * @author 汪启明
 * @create 2020-07-26-15:48
 * @version v1.0.0
 **/

import com.atguigu.atcrowdfunding.util.Const;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-26 15:48
 **/

public class StartSystemInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener-contextInitialized");
        ServletContext servletContext = servletContextEvent.getServletContext();
        String contextPath = servletContext.getContextPath();
        servletContext.setAttribute(Const.PATH,contextPath);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener-contextDestroyed");

    }
}
