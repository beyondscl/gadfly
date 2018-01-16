package com.mouse;

/**
 * author: 牛虻.
 * time:2018/1/16
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Handler {
    final Looper mLooper;
    final MessageQueue mQueue;
    final Callback mCallback;

    Handler(Callback callback) {
        mLooper = Looper.myLooper();
        mQueue = mLooper.messageQueue;
        mCallback = callback;
    }

    interface Callback {
        void handleMessage(Message msg);
    }

    public void dispatchMessage(Message message) {
        handleMessage(message);
    }

    public void sendMessage(int what) {
        Message msg = Message.get();
        msg.what = what;
        msg.target = this;
        mQueue.putMsg(msg);
    }

    /**
     * Subclasses must implement this to receive messages.
     */
    public void handleMessage(Message msg) {
        mCallback.handleMessage(msg);
    }

}
