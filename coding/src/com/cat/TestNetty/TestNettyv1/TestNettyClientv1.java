package com.cat.TestNetty.TestNettyv1;

import io.netty.bootstrap.Bootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioSocketChannel;

import java.util.Date;
import java.util.logging.Logger;

/**
 * author: 牛虻.
 * time:2017/11/4 0004
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestNettyClientv1 {
    public static void main(String[] args) throws Exception {
        //启动线程组reactor，一个网络事件处理
        EventLoopGroup work = new NioEventLoopGroup();
        Bootstrap bootstrap = new Bootstrap();//辅助类
        try {
            //设置参数，
            bootstrap.group(work)
                    .channel(NioSocketChannel.class)//设置NioSocketChannel
                    .option(ChannelOption.TCP_NODELAY, true)//
                    .handler(new ChildChannelHandlerC1());//设置处理线程
            //异步链接
            ChannelFuture channelFuture = bootstrap.connect("localhost", 9001).sync();
            //等待服务端监听端口关闭
            channelFuture.channel().closeFuture().sync();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            work.shutdownGracefully();
        }
    }
}

class ChildChannelHandlerC1 extends ChannelInitializer {
    @Override
    protected void initChannel(Channel channel) throws Exception {
        channel.pipeline().addLast(new Client1());
    }
}

//书上:不应该继承 ChannelHandlerAdapter,SimpleChannelInboundHandler客户端会释放bytebuf
class Client1 extends SimpleChannelInboundHandler {
    private static final Logger log = Logger.getLogger(Client1.class.getName());

    private final ByteBuf firstMessage;

    public Client1() {
        log.info("Client1 start" + new Date());
        byte[] req = "sssssssssssss".getBytes();
        firstMessage = Unpooled.buffer(req.length);
        firstMessage.writeBytes(req); //发送bytebuf不然服务器不会收到
    }

    //链接成功,发送消息给服务端
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        ctx.writeAndFlush(firstMessage);
        new Thread(new HeartBeat(ctx)).start(); //开启简单心跳检测
    }

    @Override
    protected void channelRead0(ChannelHandlerContext channelHandlerContext, Object o) throws Exception {
        ByteBuf byteBuffer = (ByteBuf) o;
        byte[] req = new byte[byteBuffer.readableBytes()];
        byteBuffer.readBytes(req);
        String body = new String(req, "UTF-8");
        System.out.println("client channelRead:" + body);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        ctx.close();
        super.exceptionCaught(ctx, cause);
    }
}

class HeartBeat implements Runnable {

    private ChannelHandlerContext ctx;

    public HeartBeat(ChannelHandlerContext ctx) {
        this.ctx = ctx;
    }

    @Override
    public void run() {
        while (true) {
            byte[] req = ("HEARTBEAT-" + new Date().toString()).getBytes();
            ByteBuf heart = Unpooled.buffer(req.length);
            heart.writeBytes(req);
            ctx.writeAndFlush(heart);
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
