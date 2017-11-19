package com.learn.dubbo.service;

import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Provider {
    public static void main(String[] args) throws Exception {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext(
                new String[]{"/dubbo-provider.xml"});
        context.start();
        System.out.println("press any key to exit:====>");
        System.in.read(); // press any key to exit
    }
}