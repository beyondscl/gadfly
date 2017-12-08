package com.cat.TestDesign;

/**
 * author: 牛虻.
 * time:2017/11/22
 * email:pettygadfly@gmail.com
 * doc: 【static】关键字
 * <p>分割线-------------------</p>
 * this代表当前对象本身
 * static方法就是没有this的方法。
 * <<p>分割线-------------------</p>
 * 1.java编程思想：
 * 在static方法内部不能调用非静态方法或属性,方法中不允许出现this
 * 在非static方法内部可以调用非静态方法或属性,对于静态的也可以使用this，或者不用this
 * 而且可以在没有创建任何对象的前提下，仅仅通过类本身来调用static方法。
 * 这实际上正是static方法的主要用途
 * 2.总结:方便在没有创建对象的情况下来进行调用（方法/变量）=>所以static修饰的不能用this =>static方法中，不允许出现this
 * 3.另外记住，即使没有显示地声明为static，类的构造器实际上也是静态方法。
 * 4.
 * <p>分割线-------------------</p>
 * 1.static变量
 * 2.static方法
 * 3.static代码块:很多时候会将一些只需要进行一次的初始化操作都放在static代码块中进行，优化
 */
public class TestSingle extends TestSingleSuper {
    //static不能使用this
    private static TestSingle testSingle = new TestSingle();

    private TestSingle() {
    }

    private TestSingle(String name) {
        this();
    }

    public static TestSingle getInstance() {
        return testSingle;
        //this can not referenced by a static context
        //return this.testSingle;//this错误
    }

    public static TestSingle getTestSingle2() {
        if (null == testSingle) {
            synchronized (testSingle) {
                testSingle = new TestSingle();
            }
        }
        return testSingle;
    }

    public static void main(String[] args) {
        System.out.println(TestSingle.getInstance());
        System.out.println(TestSingle.getTestSingle2());
    }
}

class TestSingleSuper {

    static String age = "22~";
    protected String name = "hello~";

    //不允许出现this
    protected static String sayHello() {
//        return age;//正确
//        return this.age;//错误
//        return TestSingleSuper.age;//正确
        return "";
    }

    //你随意
    String sayBaybay() {
        this.sayHello();
        System.out.println(this.age);
        return age + this.age + TestSingleSuper.age + this.name;
    }

}


class Main {
    static int value = 33;

    public static void main(String[] args) throws Exception {
        new Main().printValue();
    }

    private void printValue() {
        int value = 3;
        System.out.println(this.value);
    }
}

