package com.cat.TestSkill;

/**
 * author: 牛虻.
 * time:2017/11/15
 * email:pettygadfly@gmail.com
 * doc:
 *     equals空指针异常问题
 */
public class Test4 {
    public static void main(String[] args) {
        String str = null;
//        if (str.equals("a")){ //空指针异常
//
//        }
        if ("a".equals(str)) {

        }
        int i = 2;
        if (3 == i) { //推荐这样写,if(i=4){}c++不会有问题,java编译就会提示。应该无所谓类

        }
        System.out.println(1);
    }
}
