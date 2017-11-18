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

4.equals ,hashcode
```
该怎么回答?
1.目的是为了比较两个对象是否相等
2.如果
  如果在同一个加载器加载的情况下
  如果在不重写的情况下: 
  对象相等，equals相等，hashcode相等
  对象不相等，equals不相等，hashcode可能相等(碰撞情况下)
3.为什么有时候要重写？
   默认是 this == **,比较的内存地址
   但是如下：
    Dog dog1=new Dog(12,"wangcai");//自己的内存空间
    Dog dog2=new Dog(12,"wangcai");//自己的内存空间
    很明显我们理解为相等，但是内存地址不一样
    那么我们重写equals：可以用一个唯一主见或者全部自己属性对比
    重写equals后,重写hashcode,不然equals相等，hashcode不会等的。
```
5.算法复杂度？