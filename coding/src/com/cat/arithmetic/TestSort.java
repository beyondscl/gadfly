package com.cat.arithmetic;

import java.util.ArrayList;

/**
 * author: 牛虻.
 * time:2017/12/6
 * email:pettygadfly@gmail.com
 * doc:
 * 三种基本排序
 * 冒泡排序 O = n * n-1 * n-2 *1  = n(n-1)/2 = n*n去掉常数，时间复杂度约为n平方，交换次数为n平方
 * 选择排序 时间复杂度约为n平方，交换次数为n
 * 插入排序
 * <p>
 * 计算机可读性是否提高
 * 代码可读性是否提高
 */
public class TestSort<E> { //随便写着玩儿
    public static void main(String[] args) {
        Object[] o = getArray();
//        sortBubbling(o);
//        sortSelection(o);
        sortInsertion(o);
    }

    public static void print(Object[] o) {
        for (int i = 0; i < o.length; i++) {
            System.out.println("index:" + i + " " + o[i]);
        }
    }

    /**
     * 模拟一个无序不重复数组
     *
     * @return
     */
    public static Object[] getArray() {
        int leng = 10;
        ArrayList<Integer> a = new ArrayList<>(leng);
        for (int i = 0; i < leng; i++) {
            int t = (int) (Math.random() * leng * leng);
            if (!a.contains(t))
                a.add(t);
        }
        System.out.println("array length is :" + a.size());
        return a.toArray();
    }

    /**
     * 冒泡排序，比较次数，交换次数 n*n
     */
    public static Object[] sortBubbling(Object[] origin) {
        for (int i = 0; i < origin.length; i++) {
            for (int j = i + 1; j < origin.length; j++) {
                int a = (int) origin[i];
                int b = (int) origin[j];
                if (a > b) {
                    int c = a;
                    origin[i] = b;
                    origin[j] = c;
                }
            }
        }
        print(origin);
        return origin;
    }

    /**
     * 选择排序，比较次数n*n，交换次数 n
     * 每一次循环找出最小的和当前未排序的第一个位置交换
     * 优于冒泡，交换次数为n，如果交换时间花费大那么肯定是要优于冒泡的
     */
    public static Object[] sortSelection(Object[] origin) {
        for (int i = 0; i < origin.length; i++) {
            for (int j = i + 1; j < origin.length; j++) {
                int small = (int) origin[i]; //记录最小值和下标
                int smallIndex = i;
                int b = (int) origin[j];
                if (small > b) {
                    small = b;
                    smallIndex = j;
                }
                if (smallIndex != i) {
                    int temp = (int) origin[i];
                    origin[i] = small;
                    origin[j] = temp;
                }
            }
        }
        print(origin);
        return origin;
    }

    /**
     * 插入排序
     * 下标为0的元素是一个排好序的数组A，从下标为1的元素b插入到其左边有序数组A中
     * 在A中找到b应该插入的位置c，位置c及其后面的元素往后面移动
     *
     * @param origin
     * @return
     */
    public static Object[] sortInsertion(Object[] origin) {
        if (origin.length < 2) {
            throw new RuntimeException("i do't want to do it!");
        }
        for (int j = 1; j < origin.length; j++) {//从第2个元素开始插入
            int temp = (int) origin[j];//选取带插入数据
            int inner = j;
            while (inner > 0 && (int) origin[inner - 1] >= temp) {//向后移动;从右往左边扫描
                origin[inner] = origin[inner - 1];
                inner--;
            }
            origin[inner] = temp;//插入
        }
        print(origin);
        return origin;
    }
}
