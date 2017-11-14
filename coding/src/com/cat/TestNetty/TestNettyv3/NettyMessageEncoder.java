package com.cat.TestNetty.TestNettyv3;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.MessageToMessageEncoder;
import io.netty.handler.codec.marshalling.DefaultMarshallerProvider;
import io.netty.handler.codec.marshalling.MarshallerProvider;
import io.netty.handler.codec.marshalling.MarshallingEncoder;
import org.jboss.marshalling.Marshaller;
import org.jboss.marshalling.MarshallerFactory;

import java.util.List;
import java.util.Map;

/**
 * author: 牛虻.
 * time:2017/11/14
 * email:pettygadfly@gmail.com
 * doc:
 */
public class NettyMessageEncoder extends MessageToMessageEncoder {
    MarshallingEncoder marshallingEncoder;

    public NettyMessageEncoder() {
        this.marshallingEncoder = MarshallingCodeCFactory.buildMarshallingEncoder();
    }

    @Override
    protected void encode(ChannelHandlerContext ctx, Object msg, List out) throws Exception {

        NettyMessage nm = (NettyMessage) msg;
        if (null == nm || nm.getHeader() == null)
            throw new Exception("msg is null");
        ByteBuf byteBuf = Unpooled.buffer();
        byteBuf.writeInt(nm.getHeader().getCrcCode());
        byteBuf.writeInt(nm.getHeader().getLength());
        byteBuf.writeLong(nm.getHeader().getSessionID());
        byteBuf.writeByte(nm.getHeader().getType());
        byteBuf.writeByte(nm.getHeader().getPriority());
        byteBuf.writeInt(nm.getHeader().getAttachment().size());

        String key = null;
        byte[] keyArray = null;
        Object value = null;
        for(Map.Entry<String ,Object> param : nm.getHeader().getAttachment().entrySet()){

        }
        key = null;
        keyArray = null;
        value = null;
        if(nm.getBody()!=null){
        }
    }
}
