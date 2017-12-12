package com.cat.arithmetic;

/**
 * author: 牛虻.
 * time:2017/12/8
 * email:pettygadfly@gmail.com
 * doc:
 * 通常上用概念上简化问题，而不是用来解决效率
 */
public class TestDigui1 {


    public static void main(String[] args) {
//        wordsChange(size);
//        System.out.println("组合种类:" + count / size);
        hanNuoTa(2, 'a', 'b', 'c');
    }

    /**
     * 毕达哥拉斯
     * 第n项是由第n-1项+n得到
     * 1-> = 1
     * 2->[1] +2 = 3
     * 3->[2] +3 = 6
     * 7->28
     * long ~~40亿
     */
    public static long triangle(long n) {
        if (n == 1)
            return 1;
        return n + triangle(n - 1);
    }

    /**
     * 阶乘算法0的阶乘定义为1
     * 1*2*3*4...
     */
    public static void jiecheng() {

    }

    /**
     * 还没吃透！！！！
     * 单词全排列
     * 比如：hello 应该有5!这么多种可能5*4*3*2*1 = 120
     */
    private static char[] word = "abcd".toCharArray();
    private static int count = 0; //记录总次数和打印
    private static int size = word.length;//长度
    public static void wordsChange(int newSize) {
        if (newSize == 1) return;
        for (int i = 0; i < newSize; i++) {
            wordsChange(newSize - 1); //递归
            if (newSize == 2)
                display();
            rotate(newSize);
        }
    }

    //旋转
    private static void rotate(int newSize) {
        //将第一个后面的全部前移一个位置
        //将第一个放在最后
        int j;
        int position = size - newSize;
        char temp = word[position];
        for (j = position + 1; j < size; j++) {
            word[j - 1] = word[j];
        }
        word[j - 1] = temp;
    }

    private static void display() {
        for (int i = 0; i < size; i++) {
            ++count;
            System.out.print(word[i]);
            if (count % size == 0)
                System.out.println();
        }
    }

    /**
     * 汉诺塔
     * 假设有三个柱子左到右 a, b ,c
     * a上有n个从底到上从大到小的盘子，要移动到c上，一次移动一个盘子，可以使用a,b,c
     * 最后c上的排序要和a上一样
     * ------------------------
     * 思路：
     * n个盘子，如果n-1个移动到中间柱子，剩下一个直接从源头-->目的
     * n-1个盘子，那么将n-2个盘子移动到中间柱子......
     * n==1为结束条件
     * ------------------------
     * n = 2
     * disk 1 from :a to b
     * disk  :2 a to c
     * disk 1 from :b to c
     */
    private static void hanNuoTa(int count, char from, char inter, char to) {
        if (count == 1) {
            System.out.println("disk 1 from :" + from + " to " + to);
        } else {
            hanNuoTa(count - 1, from, to, inter);
            System.out.println("disk  :" + count + " " + from + " to " + to);
            hanNuoTa(count - 1, inter, from, to);
        }
    }
}