#### 粘包拆包问题
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
序列化编解码器
  为什么不用java自己的序列化？
    1.如果用自己的那么只能在java平台
    2.性能不好，体积庞大
    3.api不友好
    4.就好比window上自带的播放器或者浏览器，你会用吗？
```
### 自定消息结构，将于14章，私有协议栈来测试

```
顺便提一句：idea支持动态编译类，但是新加的类是不支持的哦！！！
```