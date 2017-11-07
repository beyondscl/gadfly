--牛虻
--2017年11月6日16:06:53
--doc 模块，包
print("--------->模块,名称可以不用于文件名同名")
local x = 2
Luav3 = {}
Luav3.time = "2017年11月6日16:08:39"
function Luav3.moudleFun1( ... ) -->公有
	print(x)
	moudleFun2(...)
end
function moudleFun2( ... ) -->私有
	print(x)
end

print("--------->包需要c写在连接")

