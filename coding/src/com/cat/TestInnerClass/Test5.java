package com.cat.TestInnerClass;

/**
 * author: 牛虻.
 * time:2017/12/1 0001
 * email:pettygadfly@gmail.com
 * doc:
 * 内部类一般用于简单初始化，只使用一次的情况；
 * 其他内部用在可能需要多分实例的时候
 * 特殊情况除外
 * -------------------------------------->
 * 1.模板方法与控制框架 p:209 图形界面事件驱动
 * 2.内部类的继承，但是不知道有什么用
 * 3.覆盖内部类也是可以的，但是不知道有什么用
 */
public class Test5 {
}


//---------------->继承内部类
class Test1 {
    class Test3 {

    }
}

class Testa extends Test1.Test3 {
    //不这样写，无法通过，必须调用test1.super();
    Testa(Test1 test1) {
        test1.super();
    }
}