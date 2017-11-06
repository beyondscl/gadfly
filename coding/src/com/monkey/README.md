#### 这里是protobuf相关知识
`
注意最后有一个空格，这里使用proto3
`
```
protoc.exe
   --java_out=F:\gitspace\gadfly\coding\src\com\monkey\outjava\
   --proto_path=F:\gitspace\gadfly\coding\src\com\monkey\proto  person.proto
```

### jboss marshalling编码器，
```
1.结合marshalling编码器，可以用于第14张，自定义协议栈，就是消息结构自定义
2.然后结合protobuf在改造
3.估计会上不少时间
```
