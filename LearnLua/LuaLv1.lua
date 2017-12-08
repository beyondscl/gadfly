--2017年11月6日13:48:39
--牛虻

print("---------->while循环控制语句")
local whileFlag = 0
while (whileFlag < 2)
do
    whileFlag = 1 + whileFlag
    print(whileFlag);
end

print("---------->普通 for循环控制语句")
for i = 1, 10 do -->startIndex,end,incremetn[不填默认增加1]
end

for i = 1, 10, 5 do
end
for i = 2, 2, 1 do -->会执行一次
    print(i)
end

print("---------->for in循环控制语句")
local table = { "a", "b", "c" }
for i, v in pairs(table) do
    print(i .. ":" .. v)
end

local
tip = "pairs遍历表中全部key，value"
tip = tip .. "ipairs从下标为1开始遍历，然后下标累加1，如果某个下标元素不存在就终止遍历。"
tip = tip .. "这就导致如果下标不连续或者不是从1开始的表就会中断或者遍历不到元素。"
print(tip)


print("---------->if then end 可以嵌套")
local x, y = 1, 2
if (x < y) then
    if (x > 0) then
        x, y = 99, 100
    end
end
print(x, y);



print("---------->函数")
local function funArgs(...)
    print(1)
    print("函数参数个数" .. #arg)
    return 1, 2, 3
end

print(funArgs(a, 1, 2))