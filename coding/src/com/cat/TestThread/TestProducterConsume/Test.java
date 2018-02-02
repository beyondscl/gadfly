package com.cat.TestThread.TestProducterConsume;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Random;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.logging.Logger;

/**
 * author: 牛虻.
 * time:2018/2/2
 * email:pettygadfly@gmail.com
 * doc:
 * 生产消费者模型 使用object的  wait 和 notify
 */
public class Test {
    private static Logger log = Logger.getLogger(Test.class.getName());
    private static ArrayList<FutureTask> tasks = new ArrayList<FutureTask>();
    private static boolean flag = true;

    public static void main(String[] args) {
        produter();
        consumer();
        shutdown();
    }

    public static void produter() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (flag) {
                    try {
                        int sleepTime = new Random(Calendar.getInstance().getTime().getTime()).nextInt(3) * 1000;
//                        log.info(Thread.currentThread().getId() + "sleepTime:" + sleepTime);
                        Thread.sleep(sleepTime);
                        tasks.add(new FutureTask(new Callable() {
                            @Override
                            public Object call() throws Exception {
                                Thread.sleep(5000);
                                return new Object();
                            }
                        }));
                        log.info("生产后对列总数---->：" + tasks.size());
                        //必须在同步块里面，但是可以是任意一个对象
                        synchronized (tasks) {
                            tasks.notify();
                        }
                        log.info(String.valueOf(tasks.size()));
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                }
            }
        }).start();
    }


    public static void consumer() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (true) {
                    if (tasks.isEmpty()) try {
                        if (!flag){
                            log.info("停止消费对列总数---->：" + tasks.size());
                            log.info("停止消费---->");
                            break;
                        }
                        synchronized (tasks) {
                            log.info("consumer wait---->");
                            tasks.wait();
                        }
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    log.info("consumer start---->");
                    FutureTask futureTask = tasks.get(0);
                    futureTask.run();
                    try {
                        Object o = futureTask.get();
                        log.info(o.toString());
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    }
                    tasks.remove(0);
                    log.info("消费后对列总数---->：" + tasks.size());
                }
            }
        }).start();
    }

    public static void shutdown() {
        new Thread(() -> {
            try {
//                Thread.sleep(new Random(Calendar.getInstance().getTime().getTime()).nextInt(10) * 100*1000);
                Thread.sleep(12*1000);
                flag = false;
                log.info("关闭生产者");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();
    }
}

