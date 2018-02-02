### netty
1.netty是一个jboss的开源项目，基于java nio ,react模式的 高效 '异步'非阻塞 系统
目的是解决java高并发线程低效，开发难等问题
```
```
2.它能干什么？
```
1.传统bio
2.基于java的nio,channel,buffer
3.netty对传统java的封装
    3.1解决粘包，拆包问题，四种模式[自定义协议]，详情见下面
    3.2序列化解决，传统和jbossmarshalling
    3.3集成其它协议，比如protobuf
4.netty多协议开发
    4.1http,socket[tcp/udp]
    4.2websocket
    4.3文件传输，你的系统理解下传统文件操作，xml解析，对理解spring源码，各种模式有帮助
5.核心类
    5.1bytebuf
    5.2channel/unsafe
    5.3channelPipeLine/channelHandler
    5.4.eventLoop,eventLoopGroup
    5.5future,promise
6.废话篇
    6.1java多线程你得详细了解，包括jvm模型
    6.2netty架构剖析
    6.3阿里dubbo的应用
    6.4社区
```

#### 粘包拆包问题
```
为什么存在？
因为tcp/ip协议对数据发送做了优化，多个碎片信息可能组合到一起同时发送
同时服务端也是一样，会把多个数据放在buffer里面在获取，提升效率
```
```
描述：多个tcp包发过来，服务器不知道怎么来判定多少数据是一个正确的包
```
```
解决办法：
1.每个消息定长；不用想肯定不好，岂不是每个消息都是最大的长度？
2.分隔符，包括自定义特殊的比如##￥￥@，比如换行
3.约定消息协议，这个最多，比如每个消息前面几个字节约定了当前消息的正确数据，包括长度等
    3.1 常用的有google的protobuf,monkey中有例子
```
```
换行符解决对应netty：
1.服务器客户端都添加对应解码器
2.服务器客户端回复都需要加上换行符，不然收不到
class ChildChannelHandler extends ChannelInitializer {
    @Override
    protected void initChannel(Channel channel) throws Exception {
        channel.pipeline().addLast(new LineBasedFrameDecoder(1024));//换行符解码器
        channel.pipeline().addLast(new StringDecoder());//string解码器
        channel.pipeline().addLast(new Serverv1());//自定义处理方法
    }
}
原理：
LineBasedFrameDecoder 扫描字节流中换行符 \n,\r\n ，记为一行，在扫描
StringDecoder 将对象转为string
构成文本解码器
```
```
DelimiterBasedFrameDecoder 自定义特殊符号解码器
```
```
FixedLengthFrameDecoder 固定长度解码器
```
```
序列化
  为什么不用java自己的序列化？
    1.如果用自己的那么只能在java平台
    2.性能不好，体积庞大
    3.api不友好
    4.就好比window上自带的播放器或者浏览器，你会用吗？
    可是使用jboss marshalling序列化包
```
### 自定消息结构，将于14章，私有协议栈来测试

```
顺便提一句：idea支持动态编译类，但是新加的类是不支持的哦！！！
```