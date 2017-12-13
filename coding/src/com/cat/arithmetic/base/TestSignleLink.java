package com.cat.arithmetic.base;

/**
 * author: 牛虻.
 * time:2017/12/7
 * email:pettygadfly@gmail.com
 * doc:
 * 单链表测试
 */

/**
 * 模拟链表
 */
public class TestSignleLink {
    private int size;
    private Node firstNode; //这是头,不算节点

    public boolean isEmpty() {
        return this.size == 0;
    }

    /**
     * 从头插入
     * firstNode表示头，不是节点
     * 只有第一个插入的.next是null!!!,第二个和以后插入的next都是前一个节点
     *
     * @param node
     */
    public void add(Node node) {
        size++;
        node.next = this.firstNode;
        this.firstNode = node;
    }

    public void add(Node node, int index) {
    }

    /**
     * 返回链表第一个
     */
    public Node remove() {
        size--;
        Node temp = this.firstNode;
        this.firstNode = this.firstNode.next;
        return temp;
    }
}

/**
 * 模拟节点
 */
class Node {
    public Node next;
    private String name;
    private int age;

    public Node(String name, int age) {
        this.age = age;
        this.name = name;
    }

    public void displayNode() {
        System.out.println("this is" + this.name + "-->" + this.age);
    }
}

class Test {
    public static void main(String[] args) {
        TestSignleLink testSignleLink = new TestSignleLink();
        for (int i = 0; i < 10; i++) {
            Node node = new Node("1111", i);
            testSignleLink.add(node);
        }
        while (!testSignleLink.isEmpty()) {
            Node node = testSignleLink.remove();
            node.displayNode();
        }
    }
}