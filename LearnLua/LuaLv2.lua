--2017年11月6日13:48:39
--牛虻
--字符串： http://www.runoob.com/lua/lua-strings.html
print("---------->函数与操作较多，用到的时候查找")
print("---------->字符串三种方式\"\",'',[[]]")
print("---------->常用函数复制，查找，匹配，反转，取段，格式化等等")


print("---------->数组,正常循环，pairs")
array1 = { { 1, 2, "a" }, { 1, 2, "a" }, { 1, 2, "a" } }
for i = 1, #array1 do
    print(array1[i][i])
end

print("---------->pairs泛型迭代器，有状态，无状态迭代器")
for k in pairs(array1) do
    print(k .. k .. ":" .. array1[k][k])
end

mytable = nil
-- lua 垃圾回收会释放内存

print("---------->表pairs,ipairs")
local table1 = { "apple", "banana", "orige" }
table.insert(table1, "mango") -->添加到末尾
table.remove(table1) -->移除末尾的一个
print(table.concat(table1, " "))
table.sort(table1)

tip = [[数组只能用下标，而表可以用key或者下标]]
print(tip)

print("---------->连接,加入分隔符或者不加" .. type(table.concat(table1, ",")))
print("----->指定连接", table.concat(table1, ",", 2, 3))
print("----->插入移除")
print("----->排序")
print("----->最大值")


print("---------->原表，操作2个table")

-- __index 元方法
-- 这是 metatable 最常用的键。
-- 当你通过键来访问 table 的时候，如果这个键没有值，那么Lua就会寻找该table的metatable（假定有metatable）中的__index 键。如果__index包含一个表格，Lua会在表格中查找相应的键。

--__newindex 元方法
--__newindex 元方法用来对表更新，__index则用来对表访问 。
--当你给表的一个缺少的索引赋值，解释器就会查找__newindex 元方法：如果存在则调用这个函数而不进行赋值操作。
--其他的不在叙述，比如__add  对应2个表相加



table2 = {}
table3 = { name = "aaa", age = 22 } -->string作为key不能直接赋值
table3["aa"] = "bbb"

meta1 = setmetatable(table2, {
    __index = table3,
    __newindex = function(meta1, key, value)
        print("增加新数据", key, value, "但是我直接过滤掉，不接受,")
        rawset(meta1, key, "\"rawset 设置新值" .. value .. "\"")
    end
}) -->table3为原表,  注意是2个下划线
ometa1 = getmetatable(meta1)
print(meta1.aa)
print(meta1["aa"])
print(meta1.age)

meta1.newKey = "newValue"
print(meta1.newKey, table2.newKey, table3.newKey)

