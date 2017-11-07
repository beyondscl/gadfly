-- 什么是协同(coroutine)？
-- Lua 协同程序(coroutine)与线程比较类似：拥有独立的堆栈，独立的局部变量，独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西。
-- 协同是非常强大的功能，但是用起来也很复杂。
-- 线程和协同程序区别
-- 线程与协同程序的主要区别在于，一个具有多个线程的程序可以同时运行几个线程，而协同程序却需要彼此协作的运行。
-- 在任一指定时刻只有一个协同程序在运行，并且这个正在运行的协同程序只有在明确的被要求挂起的时候才会被挂起。
-- 协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

--

co = coroutine.create(
		function(name)
			local index = 0
			while(index<3)
				do
				print(coroutine.running()) -->线程thread: 0049CC38
				print("hello",name)
				index = index+1
				coroutine.yield("return"..index)
			end
		end	
	)

print(coroutine.resume(co,'b'))
print(coroutine.resume(co))
print(coroutine.resume(co))
print(coroutine.resume(co))
print(coroutine.resume(co))


print("----------------------------------------------------")
co2 = coroutine.create(
    function()
        for i=1,10 do
            print(i)
            -- if i == 3 then
                print(coroutine.status(co2))  --running
                print(coroutine.running()) --thread:XXXXXX
            -- end
            coroutine.yield() -->每次循环需要收到调用
        end
    end
)
 
coroutine.resume(co2) --1
coroutine.resume(co2) --2
coroutine.resume(co2) --3
 
print(coroutine.status(co2))   -- suspended
print(coroutine.running()) 
