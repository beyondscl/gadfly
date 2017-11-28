package com.cat.TestSet;

import java.util.Comparator;
import java.util.Iterator;
import java.util.TreeSet;

/**
 * author: 牛虻.
 * time:2017/11/28 0028
 * email:pettygadfly@gmail.com
 * doc:
 * 读取一份英文文档，取出用得次数最多的10个单词
 */
public class TestTreeSet implements Comparable, Comparator {
    public static void main(String[] args) {
        TreeSet<Word> treeSet = new TreeSet<Word>();
        Word word = new Word();
        word.setCount(10);
        word.setWord("aaaaaaaaaaaa");
        treeSet.add(word);

        word = new Word();
        word.setCount(1);
        word.setWord("bbb");
        treeSet.add(word);

        word = new Word();
        word.setCount(11);
        word.setWord("ccc");
        treeSet.add(word);
        System.out.println(treeSet.size());
        Iterator iterable = treeSet.iterator();
        while (iterable.hasNext()) {
            Word w = (Word) iterable.next();
            System.out.println(w.getWord() + " --->" + w.getCount());
        }
    }

    public int compareTo(Object o) {//Comparable
        return 0;
    }

    public int compare(Object o1, Object o2) {//Comparator
        return 0;
    }
}

class Word implements Comparable {
    private int count;
    private String word;

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    //Comparable 自然排序；重写了该方法
    public int compareTo(Object o) {
        return ((Word) o).getCount() - this.count; //这样会升序排列
    }

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    //Comparator自定义排序 compare，需要在new treeser的时候new compareor接口

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (this.word.equals(((Word) obj).getWord())) return true;
        return false;
    }

    @Override
    public int hashCode() {
        return this.word.hashCode();
    }
}
