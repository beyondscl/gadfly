package com.learn.service;

import com.learn.domain.User;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * author: 牛虻.
 * time:2017/11/19 0019
 * email:pettygadfly@gmail.com
 * doc:
 */
@Service
public interface UserService {

    public User getUser(User user);

    public List<User> getAllUser();

    public void test();

    public void addUser(User user);

}
