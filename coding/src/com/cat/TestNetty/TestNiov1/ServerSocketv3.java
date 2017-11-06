package com.cat.TestNetty.TestNiov1;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Iterator;
import java.util.Set;

/**
 * author: 牛虻.
 * time:2017/11/3 0003
 * email:pettygadfly@gmail.com
 * doc:
 * <p/>
 * nio简介：
 * 1.4 加入，本质还是同步非阻塞，但是叫做异步非阻塞也没问题，但是本质你要明白，使用poll/selector
 * 1.5 改进使用epoll，区别在于不受句柄限制
 * 1.7 才是真的aio，异步非阻塞。ａｓ*ServerSocket
 * <p/>
 * 核心概念介绍：
 * buffer　数据交互必须使用buffer和channel
 * 八种数据类型除开Boolean，[byte,short,int,long, char , float,double]buffer
 * channel 主要分为:selectorChannel|fileChannel
 * selector 轮训活动的channel，【因为轮训所以叫做同步阻塞，如果是采用回调才能叫做真正的异步非阻塞】
 * <p/>
 * io流是半双工的:一个流，同时只能单向传输
 * socket是全双工的:通道同时可以双向传输
 * 单工:只能单向传输的
 * <p/>
 * 注意：【解决粘包拆包半包问题】
 * <p/>
 * 可以查看netty笔记.doc文档
 * <p/>
 * 什么是多路复用：
 * 多个io阻塞复用到一个select上
 * 1.不受句柄限制，主要
 * 2.其它api简单，mmap加速内核等，系统开销小，不需要创建额外id线程，也不需要维护
 * 应用场景：
 * 服务器处理多个处于监听或者链接状态的套接字
 * 同时处理多种网络协议套接字
 */
public class ServerSocketv3 {

//    public static void main(String[] args) throws IOException {
//        //1打开通道
//        ServerSocketChannel ssc = ServerSocketChannel.open();
//        //2绑定端口
//        ssc.bind(new InetSocketAddress(InetAddress.getByName("IP"), 9001));
//        ssc.configureBlocking(false);
//        //3创建reactor线程，创建多路复用器
//        Selector selector = Selector.open();
//        new Thread(new ReactorTask()).start();
//        //4将ssc注册到reactor线程的多路复用器selector上
////        SelectionKey key = ssc.register(selector, SelectionKey.OP_ACCEPT, ioHandler);
//        //5selector轮训key
//        int num = selector.select();
//        Set selectedKeys = selector.selectedKeys();
//        Iterator it = selectedKeys.iterator();
//        while (it.hasNext()) {
//            SelectionKey key2 = (SelectionKey) it.next();
//
//        }
//        //6接入客户端，tcp三次握手，建立物理链路
//        SocketChannel channel = ssc.accept();
//        //7设置非阻塞
//        channel.configureBlocking(false);
//        channel.socket().setReuseAddress(true);
//        //8将客户端注册到selector上
////        SelectionKey key3 = channel.register(selector, SelectionKey.OP_READ, ioHandler);
//        //9读取数据到缓冲区
////        int readNumber = channel.read(receivedBuffer);
//        //10对buffer解码，然后封装成task投递到业务线程
//        //11对数据编码，异步发送给客户端
//    }

    public static void main(String[] args) {
        new Thread(new Serverv3(9001), "nio server test1").start();
    }
}

class Serverv3 implements Runnable {
    private Selector selector;
    private ServerSocketChannel servChannel;
    private volatile boolean stop;

    public Serverv3(int port) {
        try {
            //1打开通道
            selector = Selector.open();
            servChannel = ServerSocketChannel.open();
            servChannel.configureBlocking(false);
            //2绑定端口 ,有点儿问题哦
//            servChannel.bind(new InetSocketAddress(port), 1024);
            //3将channel注册到 多路复用器
            servChannel.register(selector, SelectionKey.OP_ACCEPT);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public void stop() {
        this.stop = true;
    }

    @Override
    public void run() {
        while (!this.stop) {//从多路复用器上，轮训获取就绪的channel
            try {
                selector.select(1000);//不论怎么样，每隔一秒都唤醒一次
                Set<SelectionKey> selectedKeys = selector.selectedKeys();
                Iterator<SelectionKey> it = selectedKeys.iterator();
                SelectionKey key;
                while (it.hasNext()) {
                    key = it.next();
                    it.remove();
                    try {
                        handlerInput(key);
                    } catch (Exception e) {
                        if (key != null) {
                            key.cancel();
                            if (key.channel() != null) {
                                key.channel().close();
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (selector != null) {//资源自动释放
            try {
                selector.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void handlerInput(SelectionKey key) throws IOException {
        if (key.isValid()) {
            if (key.isAcceptable()) {
                ServerSocketChannel ssc = (ServerSocketChannel) key.channel();
                SocketChannel sc = ssc.accept();//接收并完成握手，建立socket
                sc.configureBlocking(false);
                sc.register(selector, SelectionKey.OP_READ);//注册读取事件
            }
        }
        if (key.isReadable()) {
            SocketChannel sc = (SocketChannel) key.channel();//获取socket
            ByteBuffer readBuffer = ByteBuffer.allocate(1024);
            int readBytes = sc.read(readBuffer);//异步读取数据
            if (readBytes > 0) {
                readBuffer.flip();//设置读取位置位置
                byte[] bytes = new byte[readBuffer.remaining()];
                readBuffer.get(bytes);
                String body = new String(bytes, "UTF-8");
                System.out.println("===========+" + body);
                doWrite(sc, body);//返回数据
            } else if (readBytes < 0) {
                key.cancel();
                sc.close();
            } else {

            }
        }
    }

    //异步返回数据
    private void doWrite(SocketChannel channel, String response) throws IOException {
        if (response != null && response.trim().length() > 0) {
            byte[] bytes = response.getBytes();
            ByteBuffer writeBuffer = ByteBuffer.allocate(bytes.length);
            writeBuffer.put(bytes);
            writeBuffer.flip();
            channel.write(writeBuffer);
        }
    }
}
