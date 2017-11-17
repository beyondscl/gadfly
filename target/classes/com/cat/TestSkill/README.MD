#### 这个包，包含了java的一些其他技巧
1. Test2: `java是值传递还是引用传递？`
2. TestProxy: `动态代理，代理只会代理被代理实例的方法`

```
example：
methodA(){
    this.methodB();//不被代理,这可能影响spring事务
    Proxy.methodB();//被代理,
}
methodB(){
    
}
```
3.缓存击穿 `高并发中涉及到 ，双重锁检验`

4.为什么要重写hashcode
```
就是为了比较对象：
object 默认调用的是 == 
public boolean equals(Object obj) {  
    return (this == obj);  
}  

对象相等，equals相等，hashcode相等
equals不相等，hashcode可能相等
```
5.算法复杂度？