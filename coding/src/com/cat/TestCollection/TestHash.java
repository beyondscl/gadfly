package com.cat.TestCollection;


import java.util.HashMap;
import java.util.Hashtable;
import java.util.WeakHashMap;

/**
 * author: 牛虻.
 * time:2017/11/15 0015
 * email:pettygadfly@gmail.com
 * doc:
 * com.util
 * <p>
 * hashmap
 * hashtable
 * weekhashmap ->
 * 强引用，String s = new String() 线程运行完，自动回收，不需要 s = null
 * 额外：1下面三个主要用在缓存，提高效率，比如jdk动态加载用到了，弱引用,
 * 额外：2list调用清空方法，只是设置为null，并没有立即释放掉，就是以防刚申请来的内存很宝贵的，可能以后还需要
 * 软引用，内存不足时候自动回收
 * 弱引用，没有关联的时候自动回收
 * 虚引用， 忘记了
 * <p>
 * 你知道hash*中推荐用string做key吗？ ->请看TestString文件，因为它重写了hashcode等等
 * <p>
 * Java提供的位运算符有：
 * 左移( << )、右移( >> ) 、无符号右移( >>> ) 、
 * 位与( & ) 、位或( | )、位非( ~ )、位异或( ^ )，
 * 除了位非( ~ )是一元操作符外，其它的都是二元操作符。
 * <p>
 * HashMap和Hashtable的区别
 * 1.你可先谈实现原理，核心方法，rehash,迭代方式(快速失败，快速安全)
 * 2.下面的区别，以及线程不安全的替代方案
 * <p>
 * HashMap和Hashtable都实现了Map接口，但决定用哪一个之前先要弄清楚它们之间的分别。
 * 主要的区别有：
 * 线程安全性，同步(synchronization)，以及速度。
 * 1.HashMap几乎可以等价于Hashtable，除了HashMap是非synchronized的，
 * 并可以接受null(HashMap可以接受为null的键值(key)和值(value)，而Hashtable则不行)。
 * <p>
 * 2.HashMap是非synchronized，而Hashtable是synchronized，这意味着Hashtable是线程安全的，
 * 多个线程可以共享一个Hashtable；而如果没有正确的同步的话，多个线程是不能共享HashMap的。
 * Java 5提供了ConcurrentHashMap，它是HashTable的替代，比HashTable的扩展性更好。
 * <p>
 * 3.HashMap的迭代器(Iterator)是fail-fast迭代器，
 * 而Hashtable的enumerator迭代器不是fail-fast迭代器。
 * <p>
 * <p>
 * <p>
 * 链接：https://www.nowcoder.com/questionTerminal/95e4f9fa513c4ef5bd6344cc3819d3f7?pos=101&mutiTagIds=570&orderByHotValue=1
 * 来源：牛客网
 * <p>
 * 一：快速失败（fail—fast）
 *    在用迭代器遍历一个集合对象时，如果遍历过程中对集合对象的内容进行了修改（增加、删除、修改），则会抛出Concurrent Modification Exception。
 *    原理：迭代器在遍历时直接访问集合中的内容，并且在遍历过程中使用一个 modCount 变量。集合在被遍历期间如果内容发生变化，
 * 就会改变modCount的值。每当迭代器使用hashNext()/next()遍历下一个元素之前，都会检测modCount变量是否为expectedmodCount值，
 * 是的话就返回遍历；否则抛出异常，终止遍历。
 *    注意：这里异常的抛出条件是检测到 modCount！=expectedmodCount 这个条件。如果集合发生变化时修改modCount值刚好又设置为了expectedmodCount值，
 * 则异常不会抛出。因此，不能依赖于这个异常是否抛出而进行并发操作的编程，这个异常只建议用于检测并发修改的bug。
 *    场景：java.util包下的集合类都是快速失败的，不能在多线程下发生并发修改（迭代过程中被修改）。
 * 二：安全失败（fail—safe）
 *    采用安全失败机制的集合容器，在遍历时不是直接在集合内容上访问的，而是先复制原有集合内容，在拷贝的集合上进行遍历。
 *    原理：由于迭代时是对原集合的拷贝进行遍历，所以在遍历过程中对原集合所作的修改并不能被迭代器检测到，所以不会触发Concurrent Modification Exception。
 *    缺点：基于拷贝内容的优点是避免了Concurrent Modification Exception，但同样地，迭代器并不能访问到修改后的内容，
 * 即：迭代器遍历的是开始遍历那一刻拿到的集合拷贝，在遍历期间原集合发生的修改迭代器是不知道的。
 *    场景：java.util.concurrent包下的容器都是安全失败，可以在多线程下并发使用，并发修改。
 */
public class TestHash {
    public static void main(String[] args) {
        User us = new User();
        Dog dog = new Dog();
        System.out.println(dog.equals(us));
        System.out.println(dog.hashCode() == us.hashCode());

        System.out.println(1 << 30);
        WeakHashMap<String, User> wh = new WeakHashMap<String, User>();
        HashMap hashMap = new HashMap();
        int i = 0;
        while (i < 6) {
            User u = new User();
            u.setName("sdfasdf");
            hashMap.put(u.toString(), u);
            i++;
        }
        new TestHash().TestHashMap();
    }

    /**
     * hash相关：
     * 你需要回答至少5点内容
     * 1.基本信息，大小扩容因子
     * 2.数据结构 数组+链表
     * 3.线程不安全，如何变得安全
     * 4.核心的put方法，可能产生的几种情况
     * 5.减少rehash，减少重复计算bucketindex [bucket桶]
     * 6.其他，里面计算运用了大量的位运算
     * 7.hash*里面有个modCount字段，用于记录修改次数，定位于fail-fast|fail-save
     * <p>
     * 默认16（2的幂），最大2的30次方，扩容0.75f
     * <p>
     * 为什么是2的幂:
     * 就是运算快
     * </p>
     * <p>
     * 数据结构是数组+单链表的组合:
     * 定义：transient Entry[] table;
     * 其中用了大量的 >> | << |& |^ |~ 的位操作
     * </p>
     * 不要再并发场景中使用HashMap
     * HashMap是线程不安全的，如果被多个线程共享的操作，将会引发不可预知的问题。
     * 据sun的说法，在扩容时，会引起链表的闭环，在get元素时，就会无限循环。
     * 如何变得安全：
     * 1.使用Map m = Collections.synchronizedMap(new HashMap(...));，这里就是对HashMap做了一次包装
     * 2.使用java.util.HashTable，效率最低
     * 3.使用java.util.concurrent.ConcurrentHashMap，相对安全，效率较高
     * </p>
     * <p>
     * 通过hash快速存取的
     * </p>
     * <p>
     * 【核心分析put方法】
     * hashmap put()三种情况
     * 1：key hashcode不同，add
     * 2：key hashcode存在，但是equals相同，更新
     * 2：key hashcode存在，但是equals不同，更新，单链表
     * HashMap通过键的hashCode来快速的存取元素。
     * 当不同的对象hashCode发生碰撞时，HashMap通过单链表来解决，将新元素加入链表表头，
     * 通过next指向原有的元素。单链表在Java中的实现就是对象的引用(复合)。
     * </p>
     * <p>
     * 优化：
     * 能确定初始容量和扩容因子最好，以便最大限度地降低 rehash 操作次数
     * [rehash] 扩容
     * 当HashMap存放的元素越来越多，到达临界值(阀值)threshold时，就要对Entry数组扩容，
     * HashMap在扩容时，新数组的容量将是原来的2倍，
     * 由于容量发生变化，原有的每个元素需要重新计算bucketIndex，
     * 再存放到新数组中去，也就是所谓的rehash
     * --------------------------------------------------------------------
     * 扩容时所有的数据需要重新进行散列计算。虽然Hash具有O(1)的数据检索效率，
     * 但它空间开销却通常很大，是以[空间换取时间,提升效率包括连接池|对象池|**池都是这样]。
     * 所以适用于读取操作频繁，写入操作很少的操作类型。
     * </p>
     * <p>
     * http://blog.csdn.net/ghsau/article/details/16843543/
     * http://blog.csdn.net/ghsau/article/details/16890151
     * </p>
     */
    public void TestHashMap() {
        HashMap hashMap = new HashMap(16, 0.6f);
        System.out.println(hashMap.size());
    }

    /***
     * 同步的
     */
    public void TestHashTable() {
        Hashtable hashMap = new Hashtable(16, 0.6f);
        System.out.println(hashMap.size());
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

