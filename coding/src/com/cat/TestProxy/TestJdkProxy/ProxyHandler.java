package com.cat.TestProxy.TestJdkProxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

/**
 * author: 牛虻.
 * time:2017/11/16 0016
 * email:pettygadfly@gmail.com
 * doc:
 */
public class ProxyHandler implements InvocationHandler {
    private Object proxied;

    public ProxyHandler(Object proxied) {
        this.proxied = proxied;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        //在转调具体目标对象之前，可以执行一些功能处理

        //转调具体目标对象的方法
        //可以针对方法拦截左处理
        return method.invoke(proxied, args);

        //在转调具体目标对象之后，可以执行一些功能处理
    }
}