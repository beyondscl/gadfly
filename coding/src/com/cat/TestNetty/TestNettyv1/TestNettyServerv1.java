package com.cat.TestNetty.TestNettyv1;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;

import java.io.UnsupportedEncodingException;
import java.util.Date;

/**
 * author: 牛虻.
 * time:2017/11/4 0004
 * email:pettygadfly@gmail.com
 * doc:
 *   这里只是简单的测试访问通过，还没有解决粘包拆包的问题
 */
public class TestNettyServerv1 {
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
            ChannelFuture channelFuture = serverBootstrap.bind("localhost", 9001).sync();
            //等待服务端监听端口关闭
            channelFuture.channel().closeFuture().sync();
            System.out.println("start at localhost 9000");
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
        channel.pipeline().addLast(new Serverv1());
    }
}

//书上:不应该继承 ChannelHandlerAdapter
class Serverv1 extends ChannelInboundHandlerAdapter {

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws UnsupportedEncodingException {
        ByteBuf byteBuffer = (ByteBuf) msg;
        byte[] req = new byte[byteBuffer.readableBytes()];
        byteBuffer.readBytes(req);
        String body = new String(req, "UTF-8");
        System.out.println("Serverv1 channelRead:" + body);
        ByteBuf resp = Unpooled.copiedBuffer(new Date().toString().getBytes());
        ctx.write(resp); //不直接写入channel
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        ctx.flush();//将缓冲区数据写入channel
        System.out.println("Serverv1 channelReadComplete:" +  new Date());
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        ctx.close();
        super.exceptionCaught(ctx, cause);
    }
}
