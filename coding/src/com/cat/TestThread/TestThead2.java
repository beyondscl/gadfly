package com.cat.TestThread;

/**
 * author: 牛虻.
 * time:2017/11/16
 * email:pettygadfly@gmail.com
 * doc:
 *  JAVA线程间通信的几种方式，阿里面试遇到：【其实这么不太合理，我觉得应该问线程同步一般怎么实现好点】
 *      比如erlang通信是基于消息发送；
 *      java通信是基于内存共享
 *  http://blog.csdn.net/u011514810/article/details/77131296
 *  比如如何实现，线程1 打印1234，线程2打印abcd，交替执行
 *  方式1：
 *  .使用基本方法，                object的 wait/notify [notifyall]
 *  .使用lock 子类reentrant 中的condition await/signal[signalAll]
 *  .AtomicInteger/volatile
 *  方式2：
 *  BlockingQueue
 *  方式3：
 *  PipedInputStreamAPI
 *  方式4：
 *  CyclicBarrierAPI
 *
 *  额外关于线程同步问题：
 *  java线程通信是基于内存共享
 *
 *  什么时候同步？
 *      多线程访问一个公共资源的时候
 *  为什么要同步？
 *      比如一个公共资源是一个成员变量，通过jvm知道，是存放在堆中[普通内存]
 *      而线程运行是在栈内存，介于cpu缓存和普通内存之间的高速缓存 , cpu高速缓存-[jvm栈高速缓存]-内存
 *      jvm操作的时候，需要把内存读入到jvm栈高速缓存,修改之后在写回去，这里就涉及到几个问题
 *          1.我改了，你们什么时候看到
 *          2.我改的时候，你们能修改吗？能读取吗？
 *  在同步什么？
 *      解决上面2个问题：
 *          1.可见性，我改了写回去确定你们能看到
 *          2.独享[互斥]，同一时刻确定只有一个线程在修改
 *
 *  同步的的【常用】方式说明:
 *  synchronized 同步代码块/方法
 *      优点:简单，自动释放锁
 *      缺点：颗粒度太大，很多地方性能不好，不符合需求，比如在写的时候，多个读的时候不需要同步啊
 *  lock：基于对象的锁
 *      优点：粒度更小，但是需要手动释放
 *      lock:ReentrantLock 可重入锁 可替代synchronized
 *      ReentrantReadWriteLock: 读写锁，一个地方写，多个地方读的时候不加锁，
 *
 *  [更多细节查看集合队列，栅栏，信号量等，来自书籍：java多线程编程!!!!!]
 *  ------------------------------------------上面是自己理解*更多细节可以查看jdk文档
 *
 */
public class TestThead2 {

    public static void main(String[] args) throws Exception {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {

            }
        });
//1方式
//        thread.wait();
//        thread.notify();
//2方式
//        重入锁
//        可重入锁
//        互斥锁
//        Lock lock = new ReentrantLock();
//        Condition condition = lock.newCondition();
//        condition.await();
//        condition.signal();
//        condition.signalAll();
//3读写锁
//        ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
//        lock.writeLock();
//        lock.readLock();
    }

}
