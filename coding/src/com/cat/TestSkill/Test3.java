package com.cat.TestSkill;

/**
 * author: 牛虻.
 * time:2017/11/14
 * email:pettygadfly@gmail.com
 * doc:
 * i = i++;问题
 * <p>
 * 这只是一个语言的特性而已
 * 1、java运算符的优先级++符是大于=的。
 * 2、The result of the postfix increment expression is not a variable, but a value.后＋＋符表达式的结果是个值而不是一个变量。
 * 也就是说后＋＋符先将自己的值存储起来，然后对变量进行++;
 * 再进行赋值操作，也就是将先存储起来的值赋给变量i,这样的操作就导致了i值被置为0了
 * javap -c 反汇编查看
 * java 栈基本指令表
 * https://www.cnblogs.com/chenqiangjsj/archive/2011/04/02/2003892.html
 */
public class Test3 {
    public static void main(String[] args) {
        int i = 0;
        i = i++;
        System.out.println(i); //i = 0
    }
}
