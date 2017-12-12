package com.cat.arithmetic;

import java.util.ArrayList;

/**
 * author: 牛虻.
 * time:2017/12/2 0002
 * email:pettygadfly@gmail.com
 * doc:
 */
public class PaiLieZuHe {
    private static ArrayList<Integer> tmpArr = new ArrayList<Integer>();

    public static void main(String[] args) {
        int[] com = {1, 2, 3, 4, 5, 6, 7, 8};
        int k = 8;
        if (k > com.length || com.length <= 0) {
            return;
        }
        combine(0, k, com);
    }

    public static void combine(int index, int k, int[] arr) {
        if (k == 1) {
            for (int i = index; i < arr.length; i++) {
                tmpArr.add(arr[i]);
                System.out.println(tmpArr.toString());
//                tmpArr.remove((Object) arr[i]);
            }
        } else if (k > 1) {
            for (int i = index; i <= arr.length - k; i++) {
                tmpArr.add(arr[i]);
                combine(i + 1, k - 1, arr);
//                tmpArr.remove((Object) arr[i]);
            }
        } else {
            return;
        }
    }
}
