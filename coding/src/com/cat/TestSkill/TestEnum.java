package com.cat.TestSkill;

/**
 * author: 牛虻.
 * time:2017/11/26 0026
 * email:pettygadfly@gmail.com
 * doc:
 */
public enum TestEnum {//final
    INSTANCE, INST2;//必须第一行声明
    private static int age;
    private Single single;

    TestEnum() {//私有，那么不能被继承
        single = new Single();//不能用static
    }

    public static void main(String[] args) {
        System.out.println(TestEnum.INSTANCE.toString());
        System.out.println(TestEnum.INSTANCE.single);
        System.out.println(TestEnum.INSTANCE.getInstance());
        System.out.println(TestEnum.INSTANCE.single == TestEnum.INSTANCE.getInstance());
        for (TestEnum e : TestEnum.values()) {
            System.out.println(e + " -->" + e.ordinal());
        }
    }

    public Single getInstance() { //方法不要也可以
        return single;
    }
}

class Single {
    private static int age;

    public Single() {
        age = 2;
    }
}

class Single2 extends Single {
    private static int age;

}