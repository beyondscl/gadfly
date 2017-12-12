package com.cat.TestProxy.Testcglib;

/**
 * author: 牛虻.
 * time:2017/11/17
 * email:pettygadfly@gmail.com
 * doc:
 */

public class SayHello { //final 类直接报错，无法继承
    public void say() { //final 方法无法被代理，因为无法重写
        System.out.println("hello everyone");
    }
}