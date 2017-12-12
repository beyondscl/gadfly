package com.cat.TestTree;

import java.util.Stack;

/**
 * author: 牛虻.
 * time:2017/12/12 0012
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestTree {
    public static void main(String[] args) {
        Tree tree = new Tree();
        Node node = new Node();
        node.iData = 1;
        node.dData = 1;
        tree.insert(node);
        node = new Node();
        node.iData = 2;
        node.dData = 2;
        tree.insert(node);
        node = new Node();
        node.iData = 3;
        node.dData = 3;
        tree.insert(node);
        node = new Node();
        node.iData = 4;
        node.dData = 4;
        tree.insert(node);
        System.out.println(tree.find(4));
        tree.displayTree();
    }
}

class Node {
    public int iData;//id
    public int dData;//data
    public Node leftNode;
    public Node rightNode;

    public void display() {
        System.out.print("{");
        System.out.print(iData);
        System.out.print(",");
        System.out.print(dData);
        System.out.print("}");
    }
}

class Tree {
    private Node root;

    public Tree() {
        this.root = null;
    }

    /**
     * @param key
     * @return
     */
    public Node find(int key) {
        if (this.root == null) return null;
        Node current = root;
        while (true) {
            if (current.iData == key) return current;
            if (current.iData > key) {
                current = current.leftNode;
            } else {
                current = current.rightNode;
            }
            if (current == null) return null;
        }
    }

    /**
     * 插入节点应该和删除节点一样，因为不可能只是插入叶子节点
     *
     * @param newNode
     */
    public void insert(Node newNode) {
        if (root == null) root = newNode;
        else {
            Node current = root;
            Node parent;
            while (true) {
                parent = current;
                if (current.iData > newNode.iData) {
                    current = current.leftNode;
                    if (current == null) {
                        parent.leftNode = newNode;
                        return;
                    }
                } else {
                    current = current.rightNode;
                    if (current == null) {
                        parent.rightNode = newNode;
                        return;
                    }
                }
            }
        }
    }

    public void displayTree() {
        Stack gloabStack = new Stack();
        gloabStack.push(root);
        int nBlank = 32;
        boolean isRowEmpty = false;
        System.out.println("---------------->");
        while (isRowEmpty == false) {
            Stack localStack = new Stack();
            isRowEmpty = true;
            for (int i = 0; i < nBlank; i++) {
                System.out.println(' ');
            }
            while (gloabStack.isEmpty() == false) {
                Node temp = (Node) gloabStack.pop();
                if (temp != null) {
                    System.out.println(temp.iData);
                    localStack.push(temp.leftNode);
                    localStack.push(temp.rightNode);
                    if (temp.leftNode != null || temp.rightNode != null) {
                        isRowEmpty = false;
                    }
                } else {
                    System.out.println("--");
                    localStack.push(null);
                    localStack.push(null);
                }
                for (int i = 0; i < nBlank * 2 - 2; i++)
                    System.out.println(' ');
            }
            System.out.println();
            nBlank /= 2;
            while (gloabStack.isEmpty() == false)
                gloabStack.push(localStack.pop());
        }
        System.out.println("---------------->");
    }
}
