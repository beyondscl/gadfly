-- 什么是协同(coroutine)？
-- Lua 协同程序(coroutine)与线程比较类似：拥有独立的堆栈，独立的局部变量，独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西。
-- 协同是非常强大的功能，但是用起来也很复杂。
-- 线程和协同程序区别
-- 线程与协同程序的主要区别在于，一个具有多个线程的程序可以同时运行几个线程，而协同程序却需要彼此协作的运行。
-- 在任一指定时刻只有一个协同程序在运行，并且这个正在运行的协同程序只有在明确的被要求挂起的时候才会被挂起。
-- 协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

--running  获取当前正在运行的协同
--status   获取状态dead suspend running
--yield    暂停协同
--resume   恢复挂起的协同
--create   启动一个协同/wrap

print("----------------------------------------------------普通的方法调用")
co = coroutine.create(
		function(name)
			local index = 0
			while(index<3)
				do
				print(coroutine.running()) -->线程thread: 0049CC38
				print("hello",name)
				index = index+1
				coroutine.yield()
			end
		end	
	)

print(coroutine.resume(co,'b'))
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

print("----------------------------------------------------更详细的实例")

function foo(a)
	print("foo接收参数",a)

	--说明：coroutine.yield(2*a)这里返回 2*a|表达式 给 coroutine.resume，
	--说明：[这里在函数里面]return的作用是让外层可以接收再次输入的值,如果不在函数里面就不用return了
	--说明：比如local r1,r2,r3 = foo(a+1)，r1,r2,r3匹配的是coroutine.resume(co3,"第二次arg1","第二次arg2","第二次arg3")中的三个参数
	return coroutine.yield(2*a)

end
co3 = coroutine.create(function (a,b) --> a,b在第一次调用的时候就已经固定了
	print("1111111协同",a,b)
	local r1,r2,r3 = foo(a+1)

	print("2222222协同",r1,r2,r3)
	local w1,w2  = coroutine.yield((a+b)..r1,a-b)

	print("3333333协同",w1,w2)
	return b,"结束返回"

end)

print("mmm",coroutine.resume(co3,1,10))
print("mmm",coroutine.resume(co3,"第二次arg1","第二次arg2","第二次arg3"))
print("mmm",coroutine.resume(co3,"第三次arg1","第三次arg2"))
print("由此看出:resume和yield的配合强大之处在于，resume处于主程中，它将外部状态（数据）传入到协同程序内部；而yield则将内部的状态（数据）返回到主程中。")

print("----------------------------------------------------生产，消费者问题")
local newProductor -->用于下面创建协成
function productor()
	local x = 1
	while x<3 do
		send(x)
		x = x +1
	end
end

function customer()
	local  x = 1
	while x <3  do --coroutine.status(newProductor) ~= "dead"会获取一个垃圾数据
		print("收到y",receive())
		x = x+1
	end
end

function receive() -->外部主线程接收数据，使用resume
	if coroutine.status(newProductor) ~= "dead"
		then
			local status ,value = coroutine.resume(newProductor) -->感觉有点儿像erlang了~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			print("value",value)
			return value
	end	

end

function send(x) -->发送数据，那么是将内部数据发送到外部
	coroutine.yield(x)
end
newProductor = coroutine.create(productor)
customer()


--[[
--跟我的理解是一样的
co = coroutine.create(function (a)
	    local r = coroutine.yield(a+1)       -- yield()返回a+1给调用它的resume()函数，即2
    	print("r=" ..r)                       -- r的值是第2次resume()传进来的，100
	end)
status, r = coroutine.resume(co, 1)     -- resume()返回两个值，一个是自身的状态true，一个是yield的返回值2
coroutine.resume(co, 100)     --resume()返回true

]]
