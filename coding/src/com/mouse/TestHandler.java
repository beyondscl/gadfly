package com.mouse;

/**
 * author: 牛虻.
 * time:2018/1/16
 * email:pettygadfly@gmail.com
 * doc:
 * handler,looper,message,messageQueue 模拟实现一个简单的android异步回调机制
 */
public class TestHandler {

    public static void main(String[] args) {
        new Thread(() -> {
            Looper.loopPerpar();
            Handler.Callback callback = msg -> new TestHandler().otherFun(msg);
            Handler handler = new Handler(callback);
            Handler handler1 = new Handler(callback);
            Handler handler2 = new Handler(callback);
            handler.sendMessage(0);
            handler1.sendMessage(2);
            handler2.sendMessage(3);
            Looper.loop();
        }).start();

    }

    public void otherFun(Message msg) {
        System.out.println("otherFun" + msg.what);
    }
}
