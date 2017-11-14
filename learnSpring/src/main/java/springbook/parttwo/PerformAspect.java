package springbook.parttwo;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * author: 牛虻.
 * time:2017/11/14
 * email:pettygadfly@gmail.com
 * doc:
 */
@Order(1)
@Aspect //声明一个切面
@Component
public class PerformAspect {
    @Pointcut("execution(* springbook.parttwo.*.*(..))") //公共,就是为了少写代码,不要写错了
    public void performance() {
    }

    @Before("performance()")
    public void actorBefore() {
        System.out.println("actorBefore");
    }
}
