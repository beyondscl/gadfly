package com.learn.dao;

import com.learn.domain.User;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
@Repository
public interface UserDao {
    public User getUser(User user);

    public List<User> getAllUser();

    public void addUser(User user);
}
