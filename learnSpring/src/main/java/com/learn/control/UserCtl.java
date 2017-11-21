package com.learn.control;

import com.learn.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * author: 牛虻.
 * time:2017/11/11
 * email:pettygadfly@gmail.com
 * doc:
 */
@Controller
@RequestMapping("/user/*")
public class UserCtl {

    @Resource
    private UserService userService;

    @RequestMapping("jumpToMain")
    public String jump() {

        userService.addUser();
        return "main";
    }

}
