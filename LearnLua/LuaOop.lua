--面向对象
--2017年11月7日14:16:42

--类似于模块，【不建议使用】

Account = {
    -->table
    id = 1, -->属性有
    gold = 99,
}
function Account.getGold() -->方法
    return Account.gold
end

function Account.setGold(gold)
    Account.gold = Account.gold + gold
end

print(Account.getGold())
print(Account.getGold())

print("---------------------华丽的分割线")
print("---------------------计算面积")
Shape = {
    area = 0,
    type = "正方形"
}
function Shape:new(o, side)
    o = o or {}
    self.type = Shape
    setmetatable(o, self)
    self.__index = self
    side = side or 0
    self.area = side * side
    return o
end

function Shape:getArea()
    return self.area
end

myshape1 = Shape:new(nil, 2)
print(myshape1:getArea()) -->注意对应的冒号或点号

--正方形
Square = Shape:new()

function Square:new(o, w, h)
    o = o or Shape:new(o)
    setmetatable(o, self)
    self.__index = self
    self.type = Square
    self.area = "自定义运算面积"
    return o
end

function Square:getArea()
    return self.area
end

square1 = Square:new(nil, 0)
print(square1:getArea())