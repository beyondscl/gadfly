package com.learn.redis;

import org.junit.Test;
import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;

/**
 * author: 牛虻.
 * time:2017/11/11
 * email:pettygadfly@gmail.com
 * doc:
 * 超级详细
 * http://blog.csdn.net/u013256816/article/details/51125842
 */
@Service
public class TestRedis {
    public final static String host = "39.108.178.35";
    public final static int port = 6379;
    public final static Jedis jedis = new Jedis(host, port, 1000);

    public static Jedis getJedisInstance() {
        return jedis;
    }

    @Test
    public void addString() {
        jedis.auth("password");
        jedis.set("name ","bbb");
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