package springbook.parttwo;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;

/**
 * author: 牛虻.
 * time:2017/11/14 0014
 * email:pettygadfly@gmail.com
 * doc:
 */

@Component
public class User1Performance implements Performance {
    @Override
    public void perform() {
        System.out.println(User1Performance.class.getName());
    }
}
