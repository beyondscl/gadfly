package com.learn.parttwo;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * author: 牛虻.
 * time:2017/11/14
 * email:pettygadfly@gmail.com
 * doc:
 */
@Configuration
@EnableAspectJAutoProxy
@ComponentScan
public class ConfigPerformance {

    @Bean
    public Audience audience() {
        return new Audience();
    }

}
