### aop
```
关注的是我们业务不关心的，比如日志，安全，事务等
spring实现有多种形式
    传统（基于java动态代理）
        基于代理的经典Spring AOP；
        纯POJO切面；
        @AspectJ注解驱动的切面；
    注入式AspectJ切面（适用于Spring各版本）
    注意表达式的正确性
    注意引入aop包，2个aspectj包

```
```
概念说明:
    Aspectj  -> 切面
    Pointcut ->切入点，表达式配置
    Advise   ->通知：前，后，异常，环绕
    类方法   ->被代理对象
    其它的我觉得可以不考虑。因为这样已经可以使用了。
    可以在具体研究下动态代理和cglib
```