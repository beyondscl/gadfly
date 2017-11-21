package com.learn.service;

import com.learn.dao.UserDao;
import com.learn.domain.User;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserDao userDao;

//    @Resource
//    private JdbcTemplate jdbcTemplate;

    public User getUser(User user) {
        return userDao.getUser(user);
    }

    public List<User> getAllUser() {
        return userDao.getAllUser();
    }

    public void test() {
    }

    public void addUser(User user) {
        userDao.addUser(user);
    }
}
