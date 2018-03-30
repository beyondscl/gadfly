package com.cat.TestThread;

import java.util.Calendar;

/**
 * author: 牛虻.
 * time:2018/3/30
 * email:pettygadfly@gmail.com
 * doc:指令重排序
 */
public class TestZlcpx {


    public static void main(String[] args) {
        int n = 9;
        Thread[] threads = new Thread[n];
        int i = 0;
        while (i < n) {
            threads[i] = new Thread(() -> {
                TestZlcpx t = new TestZlcpx();
                t.getPro1();
                t.getPro2();
            });
            threads[i].start();
            i++;
        }
    }

    int b = 0;
    public void getPro1() {
//        System.out.println(Calendar.getInstance().getTime().toString() + "getPro1");
        System.out.println(Thread.currentThread().getId() + ";getPro1;"+b++);
    }

    public void getPro2() {
//        System.out.println(Calendar.getInstance().getTime().toString() + "getPro2");
        System.out.println(Thread.currentThread().getId() + ":getPro2;"+b);
    }

}
