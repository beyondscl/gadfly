package com.cat.TestInnerClass;

/**
 * author: 牛虻.
 * time:2017/11/30 0030
 * email:pettygadfly@gmail.com
 * doc:
 */
interface Select {
    boolean end();

    Object current();

    void next();
}

public class Test {
    private Object[] items;
    private int next = 0;

    public Test(int count) {
        items = new Object[count];
    }

    public void add(Object o) {
        if (next < items.length) {
            items[next++] = o;
        }
    }

    private class Selector implements Select {

        public boolean end() {
            return false;
        }

        public Object current() {
            return null;
        }

        public void next() {

        }

        private Selector Selector() {
            return new Selector();
        }

    }

    private static class Test2 {

    }

    public static void main(String[] args) {

        Test test = new Test(10);//必须使用外部类对象
        Test.Selector ts = test.new Selector();//X.new X.this

        Test.Test2 tt2 = new Test2(); //静态不需要对象
    }

}
