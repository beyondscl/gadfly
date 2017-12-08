package com.cat.arithmetic;

/**
 * author: 牛虻.
 * time:2017/12/8
 * email:pettygadfly@gmail.com
 * doc:
 * 通常上用概念上简化问题，而不是用来解决效率
 */
public class TestDigui1 {
    /**
     * 还没吃透！！！！
     * 单词全排列
     * 比如：hello 应该有5!这么多种可能5*4*3*2*1 = 120
     */
    private static char[] word = "abcd".toCharArray();
    private static int count = 0; //记录总次数和打印
    private static int size = word.length;//长度

    public static void main(String[] args) {
        wordsChange(size);
        System.out.println("组合种类:" + count / size);
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
}
