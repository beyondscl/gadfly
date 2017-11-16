package com.cat.TestSkill;

/**
 * author: 牛虻.
 * time:2017/11/16 0016
 * email:pettygadfly@gmail.com
 * doc:你真的懂string吗?
 * <p/>
 * stirng 为什么是final？
 * 1.性能
 * 可以采用内联方式，加快效率(跟jvm实现有关)
 * hash中的key:因为创建的时候就缓存了string对象的hash
 * <p/>
 * 2.安全
 * .string是不可变的，内部实现是final char[]但是没有暴露相关方法操作它
 * .语言本身实现就需要与本地操作系统交互，不能被继承就无法～
 * .字符串池的实现提供了基础
 * .多线程安全使用，相比stringbuilder，直接在地址上修改新对象
 * .如果能被继承，那么可能会出现一些奇奇怪怪的问题
 * <p/>
 * 字符串不可变怎么理解？
 * 给字符串重新副职，就是新的对象。说白了就是不允许在地址上修改值。
 */
public class TestString {
    public static void main(String[] args) {
        String str = "hello";
        str = str + "world"; //会生成一个新对象
        System.out.println(str);

        //线程安全，对方法加了锁的
        StringBuffer sb = new StringBuffer("hello");
        sb.append(" world");

        //线程不安全
        StringBuilder stringBuilder = new StringBuilder("hello");
        stringBuilder.append(" world");

    }
}
