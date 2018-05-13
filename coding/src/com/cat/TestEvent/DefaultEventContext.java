package com.cat.TestEvent;

import java.util.concurrent.CopyOnWriteArrayList;

/**
 * author: 牛虻.
 * time:2018/5/13 0013
 * email:pettygadfly@gmail.com
 * doc:
 */
public class DefaultEventContext implements EventContext {

    //提供单例
    private static DefaultEventContext defaultEventContext = null;
    //存储事件监听
    private CopyOnWriteArrayList<EventListener> list = new CopyOnWriteArrayList<EventListener>();

    //添加，删除，是否只是触发一次，无限制触发，获取所有监听器等等细节需要设计
    public boolean addEventListener(EventListener eventListener) {
        return list.add(eventListener);
    }

    public void fireEvent(Event event) {
        for (EventListener eventListener : list) {
            eventListener.callBackEvent(event);
        }
    }

    private DefaultEventContext() {

    }

    public static DefaultEventContext instance() {
        if (defaultEventContext == null) {
            synchronized (DefaultEventContext.class) {
                if (defaultEventContext == null) {
                    defaultEventContext = new DefaultEventContext();
                }
            }
        }
        return defaultEventContext;
    }
}
