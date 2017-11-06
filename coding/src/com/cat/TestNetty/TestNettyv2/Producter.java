package com.cat.TestNetty.TestNettyv2;

import java.io.Serializable;

/**
 * author: 牛虻.
 * time:2017/11/6 0006
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Producter implements Serializable {
    private static final long serialVersionUID = 1L;
    private String orderId;
    private String time;
    private String name;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public static void main(String[] args) {
        System.out.println(new Producter().getName());
    }
}
