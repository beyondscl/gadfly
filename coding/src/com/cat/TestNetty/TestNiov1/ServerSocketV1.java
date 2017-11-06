package com.cat.TestNetty.TestNiov1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * author: 牛虻.
 * time:2017/11/3
 * email:pettygadfly@gmail.com
 * doc:
 * 额外知识：
 * socket是基于tcp/ip的全双工链接
 * <p/>
 * 概要：
 * 同步阻塞例子[bio通信模型]
 * 最简单的基础tcp的socket和serverSocket
 * 单线程接收请求(accept)，1:1线程处理请求并返回
 * client                Thread1
 * client --> accepter ->Thread2
 * client                Thread3
 * <p/>
 * 分析：
 * 弊端：一个accepter压力大；1:1的线程处理性能差；入门级别而已
 * <p/>
 * 测试：
 * 可以通过telnet测试,客户端双方统一编码格式
 */
public class ServerSocketV1 {
    public static void main(String[] args) throws IOException {
        //1监听端口
        ServerSocket serverSocket = new ServerSocket(9007);
        Socket socket;
        while (true) {
            try {
                //2接收
                socket = serverSocket.accept();
                //3启动处理线程
                new Thread(new Handlerv1(socket)).start();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
//                if (socket != null) {
//                    socket.close();
//                    socket = null;
//                }
            }

        }
    }
}

class Handlerv1 implements Runnable {
    private Socket socket;

    public Handlerv1(Socket s) {
        this.socket = s;
    }

    @Override
    public void run() {
        try {
            //使用文件的包装类，请复习IO流相关知识
            InputStream inputStream = socket.getInputStream();
            InputStreamReader isr = new InputStreamReader(inputStream, "UTF-8");
            BufferedReader br = new BufferedReader(isr);
            while (true) {
                String line = br.readLine();
                if (null != line) {
                    System.out.println(line);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
