package com.dog;

/**
 * Created by Administrator on 2017/3/18 0018.
 * 快速排序算法分析
 *
 *很形象
 *http://blog.csdn.net/morewindows/article/details/6684558
 * 对挖坑填数进行总结
 1．i =L; j = R; 将基准数挖出形成第一个坑a[i]。

 2．j--由后向前找比它小的数，找到后挖出此数填前一个坑a[i]中。

 3．i++由前向后找比它大的数，找到后也挖出此数填到前一个坑a[j]中。

 4．再重复执行2，3二步，直到i==j，将基准数填入a[i]中。
 */
public class FastSot  implements  FastSotF{

    public static void main(String[] args) {
        int[] array = new int[]{2, 3, 1, 8, 0};
        quick_sort(array,0,4);
        print(array);
    }

    //快速排序
   static void quick_sort(int s[], int l, int r)
    {
        if (l < r)
        {
            //Swap(s[l], s[(l + r) / 2]); //将中间的这个数和第一个数交换 参见注1
            int i = l, j = r, x = s[l];
            while (i < j)
            {
                while(i < j && s[j] >= x) // 从右向左找第一个小于x的数
                    j--;
                if(i < j)
                    s[i++] = s[j];

                while(i < j && s[i] < x) // 从左向右找第一个大于等于x的数
                    i++;
                if(i < j)
                    s[j--] = s[i];
            }
            s[i] = x;
            quick_sort(s, l, i - 1); // 递归调用
            quick_sort(s, i + 1, r);
        }
    }
    private static void swap(int[] a, int big, int small) {
        int t = a[small];
        a[small] = a[big];
        a[big] = t;
    }
    private static void print(int[] a) {
        for (int t : a) {
            System.out.print(t);
            System.out.print(",");
        }
    }
    int AdjustArray(int s[], int l, int r) //返回调整后基准数的位置
    {
        int i = l, j = r;
        int x = s[l]; //s[l]即s[i]就是第一个坑
        while (i < j)
        {
            // 从右向左找小于x的数来填s[i]
            while(i < j && s[j] >= x)
                j--;
            if(i < j)
            {
                s[i] = s[j]; //将s[j]填到s[i]中，s[j]就形成了一个新的坑
                i++;
            }

            // 从左向右找大于或等于x的数来填s[j]
            while(i < j && s[i] < x)
                i++;
            if(i < j)
            {
                s[j] = s[i]; //将s[i]填到s[j]中，s[i]就形成了一个新的坑
                j--;
            }
        }
        //退出时，i等于j。将x填到这个坑中。
        s[i] = x;

        return i;
    }
}
