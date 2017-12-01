package com.cat.TestInnerClass;

/**
 * author: 牛虻.
 * time:2017/11/30 0030
 * email:pettygadfly@gmail.com
 * doc:
 * Test.java
 * Test2.java
 * 都是普通内部类用法，
 * 主要讲解基本，访问权限等，.this,.new
 * 可以在方法内或者作用域内(if内)等等
 */
interface Inter {

}

class InterImpl implements Inter {

}

interface Inter2 {
    Inter getInter();
}

class Test2Inner {
//    public Test2Inner(int a) {
//
//    }

    private String name = "bbb";
    private String localtion = "萧山";

    private class Test2InnerClass2 {//仅仅Test2Inner类可以调用,完全隐藏实现细节
        private int age = 1;

        public String sayHello() {
            return name;
        }

    }

    protected class Test2InnerClass3 {

    }

    public class Test2InnerClass4 {

    }

    //------------------------------>
    public Content getContent(final int a) { //传递参数需要final
        return new Content() {//匿名内部类,看似返回的是Content，其实省略了一步
            private int money = a;

            public int getMoney() {
                return this.money;
            }
        };//需要分号
    }

    //-------------------->上面等价下面
    private class myContent implements Content {
        //....
    }

    public Content getContent1() {
        return new myContent();
    }
    //------------------------------>

    static class Test2InnerClass5 {//不依赖父类

        Test2InnerClass5() {
            System.out.println(111);
        }

        Test2InnerClass5(int a) {
            super();
        }
    }

    public static void main(String[] args) {
        Inter2 inter2 = new Inter2() {
            public Inter getInter() {
                return new InterImpl();
            }
        }; //可以访问所有
        System.out.println();
    }
}

public class Test2 extends Test2Inner {
    private Test2Inner test2Inner = new Test2Inner();

    public Test2(int a) { //必须有构造器，因为父类没有空构造器
//        super(a);
    }

    public static void main(String[] args) {
        Test2 test2 = new Test2(1); //可以访问所有非private
        new Test2Inner.Test2InnerClass5();
    }
}

interface Content {

}

