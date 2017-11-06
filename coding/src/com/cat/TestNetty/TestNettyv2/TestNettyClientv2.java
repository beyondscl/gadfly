package com.cat.TestNetty.TestNettyv2;

import io.netty.bootstrap.Bootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.handler.codec.serialization.ClassResolvers;
import io.netty.handler.codec.serialization.ObjectDecoder;
import io.netty.handler.codec.serialization.ObjectEncoder;

import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

/**
 * author: 牛虻.
 * time:2017/11/4 0004
 * email:pettygadfly@gmail.com
 * doc:
 */
public class TestNettyClientv2 {
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
            ChannelFuture channelFuture = bootstrap.connect("localhost", 9002).sync();
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
//        channel.pipeline().addLast(new LineBasedFrameDecoder(1024)); //回车换行符解决粘包拆包问题,所以客户端加上回车换行符号
//        channel.pipeline().addLast(new StringDecoder());

//        ByteBuf delimiter = Unpooled.copiedBuffer("@_".getBytes()); //自定义特殊符号解码器
//        channel.pipeline().addLast(new DelimiterBasedFrameDecoder(1024,delimiter));
//        channel.pipeline().addLast(new StringDecoder());

//        channel.pipeline().addLast(new FixedLengthFrameDecoder(30));//固定长度解码器
//        channel.pipeline().addLast(new StringDecoder());

        channel.pipeline().addLast(new ObjectDecoder(1024 * 1024,
                ClassResolvers.cacheDisabled(
                        this.getClass().getClassLoader())));
        channel.pipeline().addLast(new ObjectEncoder());
        channel.pipeline().addLast(new Client1());
    }
}

//书上:不应该继承 ChannelHandlerAdapter,SimpleChannelInboundHandler客户端会释放bytebuf
class Client1 extends SimpleChannelInboundHandler {
    private static final Logger log = Logger.getLogger(Client1.class.getName());
    private int counter = 0;
    byte[] req = ("你好" + System.getProperty("line.separator") + "@_").getBytes();

    public Client1() {
        log.info("Client1 start" + new Date());
    }

    //链接成功,发送消息给服务端
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
//        ByteBuf firstMessage;
//        for (int i = 0; i < 100; i++) { //不加编码器，服务器客户端可能收到的包都不对
//            firstMessage = Unpooled.buffer(req.length);
//            firstMessage.writeBytes(req); //发送bytebuf不然服务器不会收到
//            ctx.writeAndFlush(firstMessage);
//        }
        for (int i = 0; i < 100; i++) { //测试序列化解码器
            Producter p = new Producter();
            p.setOrderId(i + "");
            p.setName("不告诉你" + i);
            p.setTime(Calendar.getInstance().getTime().toString());
            ctx.write(p);
        }
        ctx.flush();
//        new Thread(new HeartBeat(ctx)).start(); //开启简单心跳检测
    }

    @Override
    protected void channelRead0(ChannelHandlerContext channelHandlerContext, Object o) throws Exception {
//        String body = String.valueOf(o);
//        ByteBuf byteBuffer = (ByteBuf) o;
//        byte[] req = new byte[byteBuffer.readableBytes()];
//        byteBuffer.readBytes(req);
//        String body = new String(req, "UTF-8");
//        System.out.println("client channelRead:" + body + "====counter=" + ++counter);

        Producter productor = (Producter) o;
        System.out.println(productor.getOrderId());
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
