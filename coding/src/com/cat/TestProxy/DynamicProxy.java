package com.cat.TestProxy;

/**
 * author: 牛虻.
 * time:2017/11/16 0016
 * email:pettygadfly@gmail.com
 * doc:
 *  jdk基于接口
 *      Proxy,InvocationHandler
 *  cglib基于asm内存反射，应用广泛效率高
 */

import sun.misc.ProxyGenerator;

import java.io.FileOutputStream;
import java.lang.reflect.Proxy;

public class DynamicProxy {
    public static void main(String args[]) {
        RealSubject real = new RealSubject();
        Subject proxySubject = (Subject) Proxy.newProxyInstance(Subject.class.getClassLoader(),
                new Class[]{Subject.class},
                new ProxyHandler(real));

        proxySubject.doSomething();

        //write proxySubject class binary data to file
        createProxyClassFile();
    }

    public static void createProxyClassFile() {
        String name = "ProxySubject";
        byte[] data = ProxyGenerator.generateProxyClass(name, new Class[]{Subject.class});
        try {
            FileOutputStream out = new FileOutputStream(name + ".class");
            out.write(data);
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}