package com.learn.service;

import com.learn.dao.UserDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
@Service
public class UserService {
    @Resource
    private UserDao userDao;

    public int addUser() {
        return userDao.addUser();
    }
}
