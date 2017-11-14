package com.learn.partone.main.java.soundsystem;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.*;
import org.springframework.core.type.AnnotatedTypeMetadata;
import org.springframework.stereotype.Component;

import java.util.Date;

@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE) //=@Scope("prototype")
@Primary
@Component
@Conditional(SgtPeppers.class) // 条件创建beam
public class SgtPeppers implements CompactDisc, Condition {

    private String title = "Sgt. Pepper's Lonely Hearts Club Band";
    private String artist = "The Beatles";

    public void play() {
        System.out.println("Playing " + title + " by " + artist);
    }

    //运行是注入的一种方式，调用其他类，方法等
    //可以读取配置，获取环境变量等
    public void baibai(@Value("#{'i hava a runtime name ~'}") String name, Date date) {
        System.out.println(name + date.toString());
    }


    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return true;
    }
}
