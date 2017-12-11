package com.cat.arithmetic.gaojipaixu;

/**
 * author: 牛虻.
 * time:2017/12/11
 * email:pettygadfly@gmail.com
 * doc:
 * 希尔排序
 * 基于插入排序
 * 差不多任何排序都可以从希尔开始，如果效率不好转为快速排序等方式
 * 间隔公式计算1:h = 3*h +1 当h为1的时候，就是插入排序
 */
public class TestXiEr {
    public static void main(String[] args) {
        int[] a = {2, 1, 7, 6, 8, 4, 99, 3, 5, 6, 4, 5, 6, 7, 4, 5, 6, 7, 8};
        shellSort(a);
    }

    private static void shellSort(int[] a) {
        int inner, outer;

        int h = 1;
        while (h <= a.length / 3)
            h = 3 * h + 1;
        print(a);
        System.out.println("-->" + h);
        while (h > 0) {
            for (outer = h; outer < a.length; outer++) {
                int temp = a[outer];
                inner = outer;
                while (inner > h - 1 && a[inner - h] >= temp) {
                    a[inner] = a[inner - h];
                    inner -= h;
                }
                a[inner] = temp;
            }
            h = (h - 1) / 3;
            print(a);
            System.out.println("-->" + h);
        }
    }

    public static void println(int[] o) {
        for (int i = 0; i < o.length; i++) {
            System.out.println("index:" + i + " " + o[i]);
        }
    }


    public static void print(int[] o) {
        for (int i = 0; i < o.length; i++) {
            System.out.print(o[i] + "  ");
        }
    }
}