package com.cat.TestSkill;

/**
 * author: 牛虻.
 * time:2017/11/26 0026
 * email:pettygadfly@gmail.com
 * doc:
 */
public enum TestEnum {
    INSTANCE;
    private Single single;

    TestEnum() {//默认私有
        single = new Single();
    }

    public Single getInstance() { //方法不要也可以
        return single;
    }

    public static void main(String[] args) {
        System.out.println(TestEnum.INSTANCE.single);
        System.out.println(TestEnum.INSTANCE.getInstance());
        System.out.println(TestEnum.INSTANCE.single == TestEnum.INSTANCE.getInstance());
    }
}

class Single {

}