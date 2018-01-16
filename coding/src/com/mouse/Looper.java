package com.mouse;

/**
 * author: 牛虻.
 * time:2018/1/16
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Looper {

    private static ThreadLocal threadLocal;
    static MessageQueue messageQueue = new MessageQueue();

    private static Message msg;

    public static void loopPerpar() {
        if (threadLocal == null) {
            threadLocal = new ThreadLocal();
            threadLocal.set(new Looper());
        } else {
            throw new RuntimeException("had init");
        }
    }

    public static  void loop() {
        for (; ; ) {
            msg = messageQueue.getMsg();
            if (null == msg)
                return;
            msg.target.dispatchMessage(msg);
        }
    }

    public static Looper myLooper() {
        return (Looper) threadLocal.get();
    }

}
