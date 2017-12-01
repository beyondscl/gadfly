package com.cat.TestInnerClass;

/**
 * author: 牛虻.
 * time:2017/12/1 0001
 * email:pettygadfly@gmail.com
 * doc:
 * 内部类是面向闭包的！
 * 匿名内部类使用基本方法
 * 为什么需要内部类--->
 * 1：实现一个接口，最好接口中只有一个方法；继承一个类，重写其中一个方法，多了不合适
 * 2：简单
 * 3:内部类实现接口，根你外部类是否实现该接口没有半毛钱关系
 * 3.1：可以让一个内，多种方式实现一个接口
 * 4：模拟多继承，
 */
interface TestInter {
    void sayHello();
    class MyTest implements TestInter { //还能这么写，不知道用处在哪里

        public void sayHello() {
            System.out.println(111);
        }

        public static void main(String[] args) {
            MyTest  myTest = new MyTest();
            myTest.sayHello();
        }
    }
}
class TestSuper{
    //只能继承才能使用
    protected void sayHello(){
        System.out.println("super say hello");
    }
}
public class Test3 {

    public  void impl(TestInter testInter){
        testInter.sayHello();
    }


    public static void main(String[] args) {
        Test3 test3 = new Test3();
        //相当于，new了一个实现子类，并调用了其实现的方法
        //直接new一个'接口'，这里就是匿名内部类的用法
        //代理中invocationhandler中有使用，spring中有使用，runnable经常用
        test3.impl(new TestInter() {
            public void sayHello() {
                System.out.println("inter impl say hello");
            }
        });

        //如何在不new一个子类的情况下，调用其protected方法？
        //相当于，new了一个子类，并调用了其父类的方法
        new TestSuper(){
            @Override
            protected void sayHello(){
                super.sayHello();
            }
        }.sayHello();
    }
}
