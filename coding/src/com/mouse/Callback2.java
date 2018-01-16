package com.mouse;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * author: 牛虻.
 * time:2018/1/15
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Callback2 {

    //维护一个callback列表
    private List<Callback> list = new ArrayList<>();
    ExecutorService executors = Executors.newFixedThreadPool(1);
    ExecutorService single = Executors.newSingleThreadExecutor();


    //启动执行线程
    private void doCallback() {
        single.execute(() -> {
            for (; ; ) {
                if (!list.isEmpty()) {
                    Callback callback = list.remove(0);
                    callback.handleMessage();
                }
            }
        });
    }

    public Callback2() {

    }

    public Callback2(Callback callback) {
        list.add(callback);
    }

    public void sendEmptyMessage(int what) {
//
//
//        if (what >= 0) {
//            executors.execute(() -> {
//                if (!list.isEmpty()) {
//                    Callback callback = list.remove(0);
//                    callback.handleMessage();
//                }
//            });
//        }
        new Thread(() -> {
            Callback callback = list.remove(0);
            callback.handleMessage();
        }).start();

    }

    interface Callback {
        boolean handleMessage();
    }

    //how dos it work?
    private class Mesasge {

    }

    //这里在回调一些其他的东西？？？

    public static void main(String[] args) {
        Executors.newSingleThreadExecutor().submit(new Runnable() {
            @Override
            public void run() {
                System.out.println(1);
            }
        });


//        Callback2.Callback callback = () -> {
////            【这里是核心，因为我们需要回调】
//            doSomethingOther();
//            return true;
//        };
//        new Callback2(callback).sendEmptyMessage(0);
    }

    private static void doSomethingOther() {
        System.out.println("doSomethingOther" + Calendar.getInstance().getTimeInMillis());
    }
}
