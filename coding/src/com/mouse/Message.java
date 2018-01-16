package com.mouse;

/**
 * author: 牛虻.
 * time:2018/1/16
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Message {
    Handler target;
    int what;

    static Message get() {
        return new Message();
    }
}
