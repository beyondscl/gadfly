package com.learn.control;

import com.learn.domain.User;
import com.learn.service.UserService;
import org.junit.Assert;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import java.util.UUID;

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
        User iUesr = new User();
        iUesr.setId(UUID.randomUUID().toString());
        iUesr.setName("hello");
        iUesr.setAge(11);
        userService.addUser(iUesr);
        System.out.println("-------------------------");
        User user = new User();
        user.setId("1");
        User result = userService.getUser(user);
        User result2 = userService.getUser(user);
        User result3 = userService.getUser(user);
        Assert.assertNotNull(result);
        Assert.assertNotNull(result2);
        Assert.assertNotNull(result3);
        System.out.println("-------------------------");
        Object o = userService.getAllUser();
        System.out.println("-------------------------");

        return "main";
    }

}
