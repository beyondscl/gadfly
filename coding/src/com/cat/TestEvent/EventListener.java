package com.cat.TestEvent;

/**
 * author: 牛虻.
 * time:2018/5/13 0013
 * email:pettygadfly@gmail.com
 * doc:
 */
public interface EventListener {
    //设置监听相关的事件信息
    int getType();
    void setType(int type);
    //接收事件的回调,监听器必须重写
    void callBackEvent(Event event);
}
