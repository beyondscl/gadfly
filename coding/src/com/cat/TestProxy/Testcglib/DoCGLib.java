package com.cat.TestProxy.Testcglib;

/**
 * author: 牛虻.
 * time:2017/11/17
 * email:pettygadfly@gmail.com
 * doc:
 */
public class DoCGLib {
    public static void main(String[] args) {
        CglibProxy proxy = new CglibProxy();
        //通过生成子类的方式创建代理类
        SayHello proxyImp = (SayHello) proxy.getProxy(SayHello.class);
        proxyImp.say();
        System.out.println(DoCGLib.class.getName());// stirng 包名+类名
        System.out.println(DoCGLib.class);//class 包名+类名
        System.out.println(Object.class);
    }
}