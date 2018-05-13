package com.cat.TestEvent;

/**
 * author: 牛虻.
 * time:2018/5/13 0013
 * email:pettygadfly@gmail.com
 * doc:
 */
public class DefaultEvent implements Event{
    private int type;
    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
}
