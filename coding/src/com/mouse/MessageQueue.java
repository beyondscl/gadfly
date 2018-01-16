package com.mouse;

import java.util.ArrayList;

/**
 * author: 牛虻.
 * time:2018/1/16
 * email:pettygadfly@gmail.com
 * doc:
 */
public class MessageQueue {
    private ArrayList<Message> arrayList = new ArrayList<>();

    public Message getMsg() {
        if (!arrayList.isEmpty())
            return arrayList.remove(0);
        return null;
    }

    public void putMsg(Message msg) {
        arrayList.add(msg);
    }
}
