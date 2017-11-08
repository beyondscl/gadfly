--文件操作
--错误处理，没细看
print(os.date())

path = "F:/gitspace/gadfly/LearnLua/evmStart.lua"
print("测试读取到文件 io.xxxfun")
print("------------------>普通模式")
file = io.open(path,"r")
io.input(file)
-- while io.read()~= "" do -->
-- 	print(io.read())	
-- end
-- -- io.close()
for line in io.lines() do -->读取全部文件
	print("===>"..line)
end
io.close()


print("测试追加文件")
file = io.open(path,"a")
io.output(file)
io.write("--文件追加测试"..os.date().."\n")
io.flush()
io.close()

print("------------------>不要同时测试")

print("------------------>完全模式 file:xxxfun,更多详细介绍请看api ")
-- file = io.open(path,"r")
-- file:seek("end",-30)
-- print(file:read("*a")) -->读取一行
-- file:close()

print("------------------>错误处理")
--[[编译错误，略过]]
--[[运行时错误]]
print("assert,error运行没成功,命令行识别")
-- assert(type(a) == "number", "a 不是一个数字")
-- error("not a number")
--[[
pcall,xpcall,debug
]]

function myfunction ()
	-- print(debug.traceback("Stack trace")) -->抛出一个错误
	print(debug.getinfo(1))
	print("Stack trace end")
    return 10
end
myfunction ()
print(debug.getinfo(1))