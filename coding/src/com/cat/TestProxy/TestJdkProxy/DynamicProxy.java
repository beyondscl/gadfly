package com.cat.TestProxy.TestJdkProxy;

/**
 * author: 牛虻.
 * time:2017/11/16 0016
 * email:pettygadfly@gmail.com
 * doc:
 * jdk 基于方式
 * Proxy,InvocationHandler
 * cglib 继承方式(重写类被代理类的所有方法) 基于asm内存反射，应用广泛效率高
 * 优点：CGLib创建的动态代理对象性能比JDK创建的动态代理对象的性能高不少，
 * 缺点：但是CGLib在创建代理对象时所花费的时间却比JDK多得多，
 * 所以对于单例的对象，因为无需频繁创建对象，用CGLib合适，
 * 反之，使用JDK方式要更为合适一些。
 * 同时，由于CGLib由于是采用动态创建子类的方法，final类|方法（无法继承或重写），无法进行代理
 */

import sun.misc.ProxyGenerator;

import java.io.FileOutputStream;
import java.lang.reflect.Proxy;

public class DynamicProxy {
    public static void main(String args[]) {
//        ReferenceQueue wq = new ReferenceQueue();
//        WeakReference weakReference = new WeakReference(wq);
//        SoftReference
//        WeakHashMap
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
        //生成新的类
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