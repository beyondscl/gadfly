package com.learn.control;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * author: 牛虻.
 * time:2017/11/11
 * email:pettygadfly@gmail.com
 * doc:
 */
@Controller
public class UserCtl {

    @RequestMapping("/user/jumpToMain")
    public String jump() {
        return "main";
    }

}
