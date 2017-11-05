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
 */
public class TestNettyv1 {
    public static void main(String[] args) throws Exception {
        EventLoopGroup boos = new NioEventLoopGroup();
        EventLoopGroup work = new NioEventLoopGroup();
        ServerBootstrap serverBootstrap = new ServerBootstrap();
        try {
            serverBootstrap.group(boos, work)
                    .channel(NioServerSocketChannel.class)
                    .option(ChannelOption.SO_BACKLOG, 1024)
                    .childHandler(new ChildChannelHandler());
            ChannelFuture channelFuture = serverBootstrap.bind("localhost", 9000);
            channelFuture.channel().closeFuture().sync();
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
        ctx.write(resp);
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {

    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        super.exceptionCaught(ctx, cause);
    }
}
