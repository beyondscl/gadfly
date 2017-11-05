package com.cat.TestNetty.TestNiov1;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.Socket;

/**
 * author: 牛虻.
 * time:2017/11/3
 * email:pettygadfly@gmail.com
 * doc: 最简单的基础tcp的socket和serverSocket
 */
public class SocketV1 {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("127.0.0.1", 9007);
        BufferedWriter bufferedWriter =
                new BufferedWriter(
                        new OutputStreamWriter(
                                socket.getOutputStream(), "UTF-8"));
        bufferedWriter.write("你好!\n大家好!");
        bufferedWriter.flush();
        bufferedWriter.close();
        socket.close();
    }
}
