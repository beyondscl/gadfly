package com.cat.TestInnerClass;

/**
 * author: 牛虻.
 * time:2017/12/1 0001
 * email:pettygadfly@gmail.com
 * doc:
 * 闭包与回调
 */
public class Test4 {
}

interface Increment {
    void increament();
}

class Impl1 implements Increment {

    public void increament() {

    }
}

class myImpl1 {
    public void increament() {
        System.out.println("myImpl1");
    }
}

//如果你想用另外一种方式实现接口，那么就用内部类，因为有2个increament方法,你同时只能有一份
class Impl2 extends myImpl1 {
    public void increament() {
        super.increament();
        System.out.println("myImpl2");
    }
    private class Closure implements Increment {
        public void increament() {
            Impl2.this.increament();
        }
    }
    Increment getCallBackReference(){
        return new Closure();
    }

    public static void main(String[] args) {
        new Impl2().getCallBackReference().increament();
    }
}






