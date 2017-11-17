package com.cat.TestCollection;

import java.util.HashMap;
import java.util.WeakHashMap;

/**
 * author: 牛虻.
 * time:2017/11/15 0015
 * email:pettygadfly@gmail.com
 * doc:
 * hashmap
 * hashtable
 * weekhashmap ->
 * 强引用，String s = new String() 线程运行完，自动回收，不需要 s = null
 * 额外：1下面三个主要用在缓存，提高效率，比如jdk动态加载用到了，弱引用,
 * 额外：2list调用清空方法，只是设置为null，并没有立即释放掉，就是以防刚申请来的内存很宝贵的，可能以后还需要
 * 软引用，内存不足时候自动回收
 * 弱引用，没有关联的时候自动回收
 * 虚引用， 忘记了
 * 你知道hash*中推荐用string做key吗？ ->请看TestString文件，因为它重写了hashcode等等
 * <p>
 * Java提供的位运算符有：
 * 左移( << )、右移( >> ) 、无符号右移( >>> ) 、
 * 位与( & ) 、位或( | )、位非( ~ )、位异或( ^ )，
 * 除了位非( ~ )是一元操作符外，其它的都是二元操作符。
 */
public class TestHash {
    public static void main(String[] args) {
        User us = new User();
        Dog dog = new Dog();
        System.out.println(dog.equals(us));
        System.out.println(dog.hashCode()==us.hashCode());

        System.out.println(1 << 30);
        WeakHashMap<String, User> wh = new WeakHashMap<String, User>();
        HashMap hashMap = new HashMap();
        int i = 0;
        while (i<6) {
            User u = new User();
            u.setName("sdfasdf");
            hashMap.put(u.toString(), u);
            i++;
            System.out.println(u.hashCode());
        }
    }

    /**
     * 默认16，最大2的30次方，扩容0.75f
     * 不要再并发场景中使用HashMap
     * <p>
     * HashMap是线程不安全的，如果被多个线程共享的操作，将会引发不可预知的问题。
     * 据sun的说法，在扩容时，会引起链表的闭环，在get元素时，就会无限循环。
     *
     * 通过hash快速存取的
     * hashmap put()三种情况
     * 1：key hashcode不同，add
     * 2：key hashcode存在，但是equals相同，更新
     * 2：key hashcode存在，但是equals不同，更新，单链表
     * HashMap通过键的hashCode来快速的存取元素。
     * 当不同的对象hashCode发生碰撞时，HashMap通过单链表来解决，将新元素加入链表表头，
     *              通过next指向原有的元素。单链表在Java中的实现就是对象的引用(复合)。
     *
     *              http://blog.csdn.net/ghsau/article/details/16843543/
     */
    public void TestHashMap() {
        HashMap hashMap = new HashMap();
    }
}

class User {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
class Dog {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object obj) {
        return true;
    }
}

