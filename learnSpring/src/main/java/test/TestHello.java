package test;



import org.junit.Assert;
import org.junit.Test;

import java.util.Calendar;

/**
 * author: 牛虻.
 * time:2017/11/11
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestHello {

    @Test
    public  void sayHello(){
        System.out.println(Calendar.getInstance().getTime());
        Assert.assertNotNull(null);
    }
}
