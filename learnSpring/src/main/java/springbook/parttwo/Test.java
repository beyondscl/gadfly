package springbook.parttwo;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * author: 牛虻.
 * time:2017/11/14
 * email:pettygadfly@gmail.com
 * doc:
 */
public class Test {

    public static void main(String[] args) {
        //创建spring IOC容器
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("aop_test_applicationContext.xml");
        //从IOC容器中获取bean实例
        Performance performance = (Performance) applicationContext.getBean(Performance.class);
        performance.perform();
    }
}
