package com.cat.arithmetic;

/**
 * author: 牛虻.
 * time:2017/12/4 0004
 * email:pettygadfly@gmail.com
 * doc:
 * 数组
 * 1.无序，重复增删查改
 * 2.有序不重复增删查改
 * 封装细节，提供外部接口
 * 线性查找 O(n)
 * 二分查找 O(log /n) O order of =大约是
 * -------------
 * 用代码复杂度，提升效率
 * 数组自动扩容等(比如liast)
 * ------------------
 */
public class TestBinarySearch {


    public static void main(String[] args) {
        int[] a = new int[1000];
        for (int i = 0; i < 1000; i++) {
            a[i] = i;
        }
        System.out.println(TestBinarySearch.binarySearch(a, 999));
        System.out.println(TestBinarySearch.binarySearch2(a, 999, 0, a.length - 1));

    }

    /**
     * 二分查找例子
     *
     * @param arrar
     * @param search
     * @return
     */
    public static int binarySearch(int[] arrar, int search) {
        int start = 0;
        int end = arrar.length - 1;
        int sIndex;
        int count = 0;
        while (true) {
            count++;
            sIndex = (start + end) / 2;
            int t = arrar[sIndex];
            if (t == search) {
                System.out.println(count);
                return arrar[sIndex];
            } else if (start > end) {
                System.out.println(count);
                return -1;
            }
            if (t < search) //启动开始和结束指针
                start = sIndex + 1;
            else
                end = sIndex - 1;
        }
    }

    /**
     * 二分查找例子
     * 使用递归
     *
     * @param array
     * @param search
     * @return
     */
    public static int binarySearch2(int[] array, int search, int low, int up) {
        if (low > up) return -1;
        int curIndex = (low + up) / 2;
        if (array[curIndex] == search)
            return array[curIndex];
        if (array[curIndex] > search) {
            return binarySearch2(array, search, low, curIndex - 1);
        } else {
            return binarySearch2(array, search, curIndex + 1, up);
        }
    }

}
