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

4.WeakReference weakhashmap你有知道吗？ && 动态代理
```
https://www.tuicool.com/articles/imyueq
http://blog.csdn.net/sum__mer/article/details/53179662

java中也存在大量缓存：
1.比如integercache
2.对象缓存，动态代理中的
3.字符串尺池
4.......
2对象等不等，前提是在一个类加载器加载才有意义

运行期创建目标对象的代理非常耗时，
使用缓存来存储生成的代理类显得尤为重要。
jdk动态代理使用弱引用指向cache中的代理类，以便代理类对象能够被GC回收。

简答来说你至少要知道：弱引用有助于对象的垃圾回收!
强引用：String a = "abc"

弱引用在jdk代理，cglib代理中有用到
http://blog.csdn.net/sum__mer/article/details/53179662
<<<<<<< Updated upstream
```
5.equals ,hashcode
```
https://www.tuicool.com/articles/imyueq
http://blog.csdn.net/sum__mer/article/details/53179662

java中也存在大量缓存：
1.比如integercache
2.对象缓存，动态代理中的
3.字符串尺池
4.......
2对象等不等，前提是在一个类加载器加载才有意义

运行期创建目标对象的代理非常耗时，
使用缓存来存储生成的代理类显得尤为重要。
jdk动态代理使用弱引用指向cache中的代理类，以便代理类对象能够被GC回收。

简答来说你至少要知道：弱引用有助于对象的垃圾回收!
强引用：String a = "abc"

弱引用在jdk代理，cglib代理中有用到
http://blog.csdn.net/sum__mer/article/details/53179662
```