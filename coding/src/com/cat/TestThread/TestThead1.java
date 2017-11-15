package com.cat.TestThread;

/**
 * Created by Administrator on 2017/10/25 0025.
 * 线程的基本用法：http://www.cnblogs.com/davidIsOK/p/3918096.html
 *
 * @doc :2种方式启动
 * 1.创建与启动,run也会执行不过是单个进程的阻塞。
 * 2.中断
 * 3.sleep，设置优先级，让步等基本方法
 * 4.join[线程的强制执行]  T.join T执行完后，才会执行其后面的代码，相当于阻塞了。
 * 5thread.setDaemon(true)必须在thread.start(),主线程与垃圾回收都是守护现成，当只有这2个的时候就退出了。
 *
 * JAVA线程间通信的几种方式，阿里面试遇到
 * http://blog.csdn.net/u011514810/article/details/77131296
 */
public class TestThead1 extends Thread {
    int i = 0;

    public static void main(String[] args) throws InterruptedException {
        Thead1 thread1 = new Thead1();
        Thread testT1 = new Thread(thread1);
        testT1.start();
        testT1.join();//执行完成，后面的代码才会执行
//        for (int i = 0; i < 100; i++) {
//            new Thread(thread1).start();
//        }
        TestThead1 testThead1 = new TestThead1();
        testThead1.start();
    }

    public void run() {
        int j = 100;
        try {
            while (j > 0) {
                System.out.println(Thread.currentThread().getName() + ":" + j--);
                Thread.sleep(800);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

class Thead1 implements Runnable {
    int j = 20;

    @Override
    public void run() {
        try {
//            for (int i = 0; i < 100; i++) {
//                Thread.sleep(100);
//                System.out.println(Thread.currentThread().getName()+":"+i++);
//            }
            while (j > 0) {
                System.out.println(Thread.currentThread().getName() + ":" + j--);
                Thread.sleep(900);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
