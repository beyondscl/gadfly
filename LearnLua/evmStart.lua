--http://www.runoob.com/lua/lua-tutorial.html
--2017年11月6日11:20:22
--牛虻
-- this is 注释
print("-------->注释")
--[[
都是注释
]]--
--[=[
doc:test
]=]--
print("-------->string")
print("hello world!");
name = "牛虻"
print(name.." uuu"); -->字符串链接

html = [[
<html>
<head></head>
<body>
    <a href="http://www.runoob.com/">菜鸟教程</a>
</body>
</html>
]]
print(html)
print("html字符串长度"..#html)

print("-------->数值")
print(1.950251);
print(1.2 * "3"); -->数值

print(type(false)); -->boolean

print(type(x)) -->nil
print(type(type(x)))
 
print("-------->table，类似数据库表，erlang record, key是下标或者字符串")
local table1 = {} 
local table2 = {"a","b","c","d","d",1}
table2[22] = "aa"
table2["key"] = "value"
for k,v in pairs(table2) do
	print(k..":"..v)
end
print(table2.key);
print(table2["key"]);
print(table2[1]); -->下标1开始



print("-------->function函数与匿名函数")
local function sayHelloFun(n)
	if type(n) == 'number'
		then return "number"
	else 
		return "not number"
	end		
end
print(sayHelloFun("a"))
print(sayHelloFun(1))

local function sayHelloFun(n,fun)
	if type(n) == 'number'
		then return fun(n)
	else 
		return "not number"
	end		
end

function numberCount(n)
	return n%n
end
print(sayHelloFun("a"))
print(sayHelloFun(1,numberCount))


print("--------->变量与赋值")
a = 1
local b = 2
print(a,b)
a,b = b,a  -->交换值
print(a,b)

local x,y,z = 0,1,2 -->多变量同时赋值,不赋值都是nil
print(x,y,y)


print("--------->运算符,算数，关系，逻辑，其他")
print(true and false)
print(false or true)
print(not true)
print("..运算符".."")
print("#求字符串或表的长度"..#{1,2,3})






