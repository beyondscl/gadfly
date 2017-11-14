package springbook.partone.main.java.soundsystem;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Date;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = CDPlayerConfig.class)
public class CDPlayerTest {

    //多个子类，优先注入@Primary
    //Qualifier("sgtPeppers") 限定注入
    //自定义,比如Qualifier就是一个i额
    @Autowired
    @Qualifier("sgtPeppers")
    private CompactDisc compactDisc;

    //    java.lang.NoSuchMethodError: org.springframework.util.Assert.notNull(Ljava/lang/Object;Ljava/util/function/Supplier;)V
//    测试包版本不对
    //测试不通过，可能是junit,springtext 包不应该provide,去掉jsp，servlet包
    @Test
    public void play() {
        System.out.println(compactDisc);

    }

    //运行时注入 1.占位符2.Spring Expression Language，SpEL
    @Test
    public void go() {
        this.compactDisc.baibai("", new Date());
    }

}
