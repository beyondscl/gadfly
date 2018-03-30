package com.cat.TestThread;

/**
 * author: 牛虻.
 * time:2018/3/30
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestVolatile {
    private static  boolean flag = false;

    public void testThead() {
        new Thread(() -> {
            while (!flag) {
                System.out.println(flag);
//                try {
//                    Thread.sleep(2000);
//                    System.out.println(1);
//
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
            }
        }).start();
    }

    public static void main(String[] args) throws InterruptedException {
        new TestVolatile().testThead();
        Thread.sleep(100);
        flag = true;
        System.out.println(flag);
    }
}
