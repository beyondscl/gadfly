package com.cat.TestProxy.TestJdkProxy;

/**
 * author: 牛虻.
 * time:2017/11/16 0016
 * email:pettygadfly@gmail.com
 * doc:
 */
public class RealSubject implements Subject {
    public void doSomething() {
        System.out.println("call doSomething()");
    }
    public final void doSomething2() {
        System.out.println("call doSomething()");
    }
}