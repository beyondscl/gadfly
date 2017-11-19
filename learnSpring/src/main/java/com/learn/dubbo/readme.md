```
1.可能不识别，<dubbo:applicatioj ...
解决：setting -> luangre and dtd -> 配置:
D:/mavenRep/repository/com/alibaba/dubbo/2.5.7/dubbo-2.5.7.jar!/META-INF/dubbo.xsd
http://code.alibabatech.com/schema/dubbo/dubbo.xsd
```
```
2.Invalid multicast address 127.0.0.1, scope: 224.0.0.0 - 239.255.255.255
注意：multicast地址不能配成127.0.0.1，也不能配成机器的IP地址，必须是D段广播地址，也就是：224.0.0.0到239.255.255.255之间的任意地址
```