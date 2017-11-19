package com.learn.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
@Repository
public class UserDao {

    @Resource
    private JdbcTemplate jdbcTemplate;

    public int addUser() {
        String sql = "insert into sys_user values(2,'test','test')";
        sql = "select * from sys_user";
        jdbcTemplate.execute(sql);
        return 1;
    }
}
