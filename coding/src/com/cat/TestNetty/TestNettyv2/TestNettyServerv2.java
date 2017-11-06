package com.cat.TestNetty.TestNettyv2;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.serialization.ClassResolvers;
import io.netty.handler.codec.serialization.ObjectDecoder;
import io.netty.handler.codec.serialization.ObjectEncoder;

import java.io.UnsupportedEncodingException;
import java.util.UUID;

/**
 * author: 牛虻.
 * time:2017/11/4 0004
 * email:pettygadfly@gmail.com
 * doc:
 * 这里只是简单的测试访问通过，还没有解决粘包拆包的问题
 */
public class TestNettyServerv2 {
    public static void main(String[] args) throws Exception {
        //启动线程组reactor，一个监听端口，一个网络事件处理
        EventLoopGroup boos = new NioEventLoopGroup();
        EventLoopGroup work = new NioEventLoopGroup();
        ServerBootstrap serverBootstrap = new ServerBootstrap();//辅助类
        try {
            //设置参数，
            serverBootstrap.group(boos, work)
                    .channel(NioServerSocketChannel.class)//设置channel
                    .option(ChannelOption.SO_BACKLOG, 1024)//设置非阻塞与缓冲区大小
                    .childHandler(new ChildChannelHandler());//设置处理线程,比如日志，编解码
            //绑定端口
            ChannelFuture channelFuture = serverBootstrap.bind("localhost", 9002).sync();
            //等待服务端监听端口关闭
            channelFuture.channel().closeFuture().sync();
            System.out.println("start at localhost 9002");
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            boos.shutdownGracefully();
            work.shutdownGracefully();
        }
    }
}

class ChildChannelHandler extends ChannelInitializer {
    @Override
    protected void initChannel(Channel channel) throws Exception {
//        channel.pipeline().addLast(new LineBasedFrameDecoder(1024)); //回车换行符解决粘包拆包问题,所以客户端加上回车换行符号
//        channel.pipeline().addLast(new StringDecoder());

//        ByteBuf delimiter = Unpooled.copiedBuffer("@_".getBytes());
//        channel.pipeline().addLast(new DelimiterBasedFrameDecoder(1024, delimiter));
//        channel.pipeline().addLast(new StringDecoder());

//        channel.pipeline().addLast(new FixedLengthFrameDecoder(20));//固定长度解码器
//        channel.pipeline().addLast(new StringDecoder());

        channel.pipeline().addLast(new ObjectDecoder(1024 * 1024,
                ClassResolvers.weakCachingConcurrentResolver(//线程安全且待缓存的序列化解码器
                        this.getClass().getClassLoader())));//序列化解码器
        channel.pipeline().addLast(new ObjectEncoder());

        channel.pipeline().addLast(new Serverv1());
    }
}

//书上:不应该继承 ChannelHandlerAdapter
class Serverv1 extends ChannelInboundHandlerAdapter {
    private int counter = 0;

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws UnsupportedEncodingException {
//        String body = String.valueOf(msg);

//对应上面的解码器读取数据，不在重复注释
//        ByteBuf byteBuffer = (ByteBuf) msg;
//        byte[] req = new byte[byteBuffer.readableBytes()];
//        byteBuffer.readBytes(req);
//        String body = new String(req, "UTF-8");

//        byte[] req = ("回复你好" + System.getProperty("line.separator") + new Date().toString()).getBytes();

//        byte[] req = ("回复你好@_" + new Date().toString()).getBytes();
//        ByteBuf resp = Unpooled.copiedBuffer(req);

        Producter productor = (Producter) msg;
        System.out.println(productor.getOrderId());
        productor.setOrderId(UUID.randomUUID().toString());
        ctx.write(productor); //不直接写入channel
//        System.out.println("Serverv1 channe lRead:" + body + "====counter=" + ++counter);
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        ctx.flush();//将缓冲区数据写入channel
//        System.out.println("Serverv1 channelReadComplete:" + new Date());
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        ctx.close();
        super.exceptionCaught(ctx, cause);
    }
}
