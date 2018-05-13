package com.cat.TestEvent;

/**
 * author: 牛虻.
 * time:2018/5/13 0013
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Test implements EventListener{

    public static void main(String[] args) {

    }
    @org.junit.Test
    public void testEvent(){
        //事件上下文
        DefaultEventContext defaultEventContext = DefaultEventContext.instance();
        defaultEventContext.addEventListener(this);//注册事件监听
        //生成事件
        DefaultEvent event = new DefaultEvent();
        event.setType(1);
        //用上下文触发事件
        defaultEventContext.fireEvent(event);
    }

    @Override
    public int getType() {
        return 0;
    }

    @Override
    public void setType(int type) {

    }

    @Override
    public void callBackEvent(Event event) {
        System.out.println(this.getClass().getName()+":fire a event type=:"+event.getType());
    }
}
