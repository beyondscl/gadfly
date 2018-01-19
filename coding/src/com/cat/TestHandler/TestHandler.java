package com.cat.TestHandler;

/**
 * author: 牛虻.
 * time:2018/1/15 0015
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestHandler {

    private ThreadLocal threadLocal = new ThreadLocal();

    public static void main(String[] args) {
        TestHandler testHandler = new TestHandler();
        testHandler.loopPrepar();
        testHandler.loop();
    }


    private void loopPrepar() {
        if (null == threadLocal.get()) {
            threadLocal.set(new Looper());
        }
    }

    private void loop() {
        for (; ; ) {
            Looper looper = (Looper) threadLocal.get();
            if (looper == null)
                throw new RuntimeException("please call loopPrepar first");
            MessageQueue mq = looper.getMessageQueue();
            if (null == mq) {
                return;
            }
            looper.messageQueue.target.dispatchMessage(null);
        }
    }

}

class Looper {
    public MessageQueue messageQueue;

    public Looper() {

    }

    public MessageQueue getMessageQueue() {
        return messageQueue;
    }

}

class MessageQueue {
    public Target target;
    public MessageQueue() {

    }
}

class Message {
    public Message() {

    }
}

class Target {
    public Target() {

    }

    public void dispatchMessage(Message msg) {

    }
}
