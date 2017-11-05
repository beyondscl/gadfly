package com.cat.TestNetty.TestNiov1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * author: 牛虻.
 * time:2017/11/3 0003
 * email:pettygadfly@gmail.com
 * doc:伪异步io模型
 * 处理进程用线程池取代１：１模型
 * 改进的地方：将接入的ｓｏｃｋｅｔ封装成ｔａｓｋ放入线程池中
 * 弊端：１．ｉｏ　ｗ／ｒ的时候是阻塞的，这样队列中的ｓｏｃｋｅｔ会一直阻塞，可查看ｉｏ文档
 * 　　　当网络不稳定，数据量大，第三方接口慢等问题都会拖慢系统
 * 2．阻塞队列也会成一个瓶颈
 * ３．如果后面的全部阻塞会导致ａｃｃｅｐｔｅｒ也阻塞，服务器觉得应答等一系列问题
 */
public class ServerSocketv2 {

    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(8000);
        while (true) {
            Socket socket = serverSocket.accept();
            new executor().execute(new Handlerv2(socket));
        }
    }
}

class executor {
    //关于线程池有多种选择，请学习
    //关于队列，有多种选择，请学习

    //线程池和队列有大小，不会撑死内存
    private ExecutorService executorService = new ThreadPoolExecutor(Runtime.getRuntime().availableProcessors(),
            20, 120L, TimeUnit.SECONDS, new ArrayBlockingQueue<Runnable>(200));

    public void execute(Runnable task) {
        executorService.execute(task);
    }
}

class Handlerv2 implements Runnable {
    Socket socket;

    public Handlerv2(Socket socket) {
        this.socket = socket;
    }

    @Override
    public void run() {
        InputStream is;
        try {
            is = socket.getInputStream();
            InputStreamReader isr = new InputStreamReader(is, "UTF-8");
            BufferedReader br = new BufferedReader(isr);
            String data = br.readLine();
            while (null != data) {
                System.out.println(data);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
