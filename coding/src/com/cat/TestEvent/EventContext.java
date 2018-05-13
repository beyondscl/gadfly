package com.cat.TestEvent;

/**
 * author: 牛虻.
 * time:2018/5/13 0013
 * email:pettygadfly@gmail.com
 * doc:
 */
public interface EventContext {
    boolean addEventListener(EventListener eventListener);
    void fireEvent(Event event);
}
