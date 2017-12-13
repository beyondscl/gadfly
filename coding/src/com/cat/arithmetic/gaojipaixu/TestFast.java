package com.cat.arithmetic.gaojipaixu;

/**
 * author: 牛虻.
 * time:2017/12/12
 * email:pettygadfly@gmail.com
 * doc:
 * 快速排序
 * pivot ->中心
 */
public class TestFast {
    public static void main(String[] args) {

    }

    /**
     * 基本的快速排序
     */
    public static void fastOne(int left, int right) {
        if (right < left) {
            return;
        } else {
            int partition = partition(left, right);
            fastOne(left, partition - 1);
            fastOne(partition + 1, right);
        }
    }

    private static int partition(int left, int right) {
        return -1;
    }
    //--------------------------------------------------------------------------

}
