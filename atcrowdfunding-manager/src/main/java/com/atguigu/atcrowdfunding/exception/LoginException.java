package com.atguigu.atcrowdfunding.exception;/**
 * Packge: com.atguigu.atcrowdfunding.exception
 *
 * @author 汪启明
 * @create 2020-07-26-17:39
 * @version v1.0.0
 **/

/**
 * @program: atcrowdfunding-parent
 * @description:
 * @author: Mr.Wang
 * @create: 2020-07-26 17:39
 **/

public class LoginException extends RuntimeException{
   public LoginException(){}
   public LoginException(String msg){
      super(msg);
   }
}
