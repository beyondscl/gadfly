package com.cat.TestCollection;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Stack;
import java.util.Vector;

/**
 * author: 牛虻.
 * time:2017/11/15 0015
 * email:pettygadfly@gmail.com
 * doc:
 * 实现了RandmoAccess接口，即提供了随机访问功能。
 * RandmoAccess是java中用来被List实现，为List提供快速访问功能的。
 * 通过元素的序号快速获取元素对象；这就是快速随机访问。
 * -----------------------------------------------------------------------------
 * 这里主要讲解java.utils.collection. list
 * arraylist
 * linkedlist
 * vector
 * stack
 */
public class TestList {
    public static void main(String[] args) {

    }

    /**
     * 源码分析：
     * 一个方法一个方法分析
     * http://blog.csdn.net/jzhf2012/article/details/8540410
     * 被标记为：transient Object[] a
     * 动态数组实现(数组内存连续)，默认值10，默认扩容X*1.5+1，不安全
     * 它继承自AbstractList，实现了List、RandomAccess、Cloneable、java.io.Serializable接口
     * <p/>
     * 优化：防止动态扩容，若提前能大致判断list的长度，调用ensureCapacity调整容量，将有效的提高运行速度
     * 底层数组操作，system.arrayCopy调用的c
     * <p>
     * 遍历方式，随机访问[推荐]，迭代器
     */
    public void arrayListTest() {
        ArrayList arrayList = new ArrayList();
    }

    /**
     * 源码分析
     * http://blog.csdn.net/jzhf2012/article/details/8540543
     * transient
     * 不安全
     * 使用内部类实现了双向链表
     * 所以随机访问肯定慢，但是删除添加很快，因为不需要复制数组
     * 比如获取inex=6,先中间判断在循环，减少一半的循环
     * <p>
     * 遍历方式，for ,迭代器
     */
    public void linkedListTest() {
        LinkedList linkedList = new LinkedList();
    }

    /**
     * 源码分析
     * https://www.cnblogs.com/skywang12345/p/3308833.html
     * 向量 很多方法加入了synchronized ->线程安全，但是迭代器不安全
     * 默认10，不填写的话扩容1倍
     * 遍历方式4种，随机访问[推荐]，迭代器，for in ,Enumeration
     * 不推荐使用了
     */
    public void vectorTest() {
        Vector vector = new Vector();
        vector.elements(); // ->Enumeration
    }

    /**
     * 源码分析
     * stack ，集成了vector，filo
     * 对Stack、同其父类一样、早已不推荐使用、这里也只是针对Stack源码中提供的方法进行了分析、
     * 如果真要使用栈这种结构来实现数据存储、
     * 推荐使用Deque 接口及其实现提供了LIFO 堆栈操作的更完整和更一致的 set，应该优先使用此 set，而非此类。权当了解！
     * 添加了2个同步方法而已pop删除并返回,peek仅仅返回
     */
    public void stackTest() {
        Stack stack = new Stack();
    }
}
