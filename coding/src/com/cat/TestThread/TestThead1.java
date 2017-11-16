package com.cat.TestThread;

/**
 * Created by Administrator on 2017/10/25 0025.
 * 线程的基本用法：http://www.cnblogs.com/davidIsOK/p/3918096.html
 *
 * @doc :
 *   实现线程的3中基本方式，
 *     继承thread,
 *     实现Runnable,
 *     实现callable 等
 * .五种状态，new创建，start就绪等待cpu调用，run运行，中断join,wait等，结束stop
 * .start 与run的区别：状态上就有本质区别,run就是一个线程的基本方法，直接调用run，就相当于串行调用，会阻塞
 * .sleep与wait的区别：sleep线程内休眠，不释放锁
 * .sleep，setPriority,yield等基本方法
 * .join[线程的强制执行]  T.join T执行完后，才会执行其后面的代码，相当于阻塞了。
 * .thread.setDaemon(true)必须在thread.start(),主线程与垃圾回收都是守护现成，当只有这2个的时候就退出了。
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
