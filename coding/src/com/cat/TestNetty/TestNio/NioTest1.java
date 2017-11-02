package com.cat.TestNetty.TestNio;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

/**
 * author: 牛虻.
 * time:2017/11/1
 * email:pettygadfly@gmail.com
 * doc: 来源http://ifeve.com/channels/ ，并发编程网
 * channel
 * --> buffer
 */
public class NioTest1 {
    public static void main(String[] args) throws IOException {
        RandomAccessFile aFile = new RandomAccessFile("F:\\bootstrap\\bower.json", "rw");
        FileChannel inChannel = aFile.getChannel();
        ByteBuffer buf = ByteBuffer.allocate(48);
        int bytesRead = inChannel.read(buf);
        while (bytesRead != -1) {
            System.out.println("Read " + bytesRead);
            buf.flip();
            while (buf.hasRemaining()) {
                System.out.print((char) buf.get());
            }
            buf.clear();
            bytesRead = inChannel.read(buf);
        }
        aFile.close();
    }
}
