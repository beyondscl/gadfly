package com.cat.arithmetic.base;

/**
 * author: 牛虻.
 * time:2017/12/11
 * email:pettygadfly@gmail.com
 * doc:
 * 归并排序,没搞懂?
 * O = n*logn
 */
public class TestGuiBingSort {

    public static void main(String[] args) {
//        gbSort1();
        gbSort2(new int[a.length], 0, a.length - 1);
        display(a);

    }

    /**
     * 归并第一个测试
     * 将2个有序数组a,b排序到另一个有序数组c
     */
    private static void gbSort1() {
        int[] a = {1, 2, 3, 4};
        int[] b = {5, 6, 7, 8, 9};
        int[] c = new int[a.length + b.length];
        int aI = 0, bI = 0, cI = 0;
        while (aI < a.length && bI < b.length) {
            if (a[aI] < b[bI])
                c[cI++] = a[aI++];
            else
                c[cI++] = b[bI++];
        }
        while (aI < a.length) {
            c[cI++] = a[aI++];
        }
        while (bI < b.length) {
            c[cI++] = b[bI++];
        }
        display(c);
    }


    /**
     * 真正的归并排序
     */
    private static int[] a = {1, 3, 9, 2, 5, 7, 8};

    private static void gbSort2(int[] t, int low, int up) {
        if (low == up) return;
        else {
            int mid = (low + up) / 2;
            gbSort2(t, low, mid);
            gbSort2(t, mid + 1, up);
            merge(t, low, mid + 1, up);
        }
    }

    private static void merge(int[] work, int low, int mid, int up) {
        int j = 0;
        int lower = low;
        int n = up - lower + 1;
        while (low <= mid - 1 && mid <= up) {
            if (a[low] < a[mid])
                work[j++] = a[low++];
            else
                work[j++] = a[mid++];
        }
        while (low <= mid - 1) {
            work[j++] = a[low++];
        }
        while (mid <= up) {
            work[j++] = a[mid++];
        }
        for (int i = 0; i < n; i++) {
            a[lower + i] = work[i];
        }
    }


    private static void display(int[] s) {
        for (int t : s) {
            System.out.println(t);
        }
    }
}