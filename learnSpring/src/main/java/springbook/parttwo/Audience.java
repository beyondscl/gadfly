package springbook.parttwo;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

/**
 * author: 牛虻.
 * time:2017/11/14
 * email:pettygadfly@gmail.com
 * doc:
 */
@Aspect //声明一个切面
public class Audience {

    @Pointcut("execution(** com.learn.parttwo.Performance(..))") //切点,就是为了少写代码
    public void performance() {
    }

    @Before("performance()")
    public void actorBefore() {
        System.out.println("actorBefore");
    }
}
