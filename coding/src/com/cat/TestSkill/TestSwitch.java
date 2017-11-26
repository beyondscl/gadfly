package com.cat.TestSkill;

/**
 * author: 牛虻.
 * time:2017/11/26 0026
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestSwitch {
    private final int CLICK_QUERY = 1; //不加final 不然case后面会出错
    private final int CLICK_RESET = 2;

    public static void main(String[] args) {
//        int a = 11; //打印default
        int a = 1; //打印1，2，3
        switch (a) {
            case 1:
                System.out.println(1);
            case 2:
                System.out.println(2);
            case 3:
                System.out.println(3);
                break;
            default:
                System.out.println("defalut");
        }
    }

    public void onClick() {
        int tag = CLICK_QUERY;
        switch (tag) {
            case CLICK_QUERY:
                break;
            case CLICK_RESET:
                break;
        }
    }
}
