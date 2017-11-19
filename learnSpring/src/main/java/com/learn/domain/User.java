package com.learn.domain;

import com.sun.istack.internal.NotNull;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
public class User {
    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @NotNull
    private String uid ;
    private String name ;
    private int age ;
}
