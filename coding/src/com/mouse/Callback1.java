package com.mouse;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Author : LengTingxue.
 * Date : 2018/1/15.
 * Doc :
 */

public class Callback1 {

    private List<DoSomething> runnables = new ArrayList<>();
    ExecutorService executors = Executors.newFixedThreadPool(5);

    public static void main(String[] args) {
        Callback1 javaLearn = new Callback1();
        javaLearn.initFactory();
        javaLearn.insertAssets();
    }

    public void initFactory() {
        new Thread(() -> {
            while (true) {
                try {
                    Thread.sleep(2000);
                    if (runnables.size() != 0) {
                        executors.execute(() -> {
                            DoSomething doSomething = runnables.remove(0);
                            doSomething.printTime();
                        });
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        }).start();
    }
    public void insertAssets(){
        new Thread(()->{
           while (true){
               try {
                   Thread.sleep(1500);
                   runnables.add(() -> System.out.println(Calendar.getInstance().getTimeInMillis()));
               } catch (InterruptedException e) {
                   e.printStackTrace();
               }
           }
        }).start();
    }

    interface DoSomething {
        void printTime();
    }

}
