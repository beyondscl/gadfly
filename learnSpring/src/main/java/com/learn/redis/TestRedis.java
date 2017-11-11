package com.learn.redis;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.junit.Test;
import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * author: 牛虻.
 * time:2017/11/11
 * email:pettygadfly@gmail.com
 * doc:
 *  超级详细
 *  http://blog.csdn.net/u013256816/article/details/51125842
 */
@Service
public class TestRedis {
    public final static String host = "192.168.0.227";
    public final static int port = 6379;
    public final static Jedis jedis = new Jedis(host, port, 1000);


    @Test
    public void addString() {

    }



}

class User {
    private String id;
    private String name;
    private int age;
    private double money;

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

    public double getMoney() {
        return money;
    }

    public void setMoney(double money) {
        this.money = money;
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}