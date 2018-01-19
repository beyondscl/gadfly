local ctrl
local fishCtrl = {}
local GetFishTypeByGroup
local SetTimeout
-- local ClearAllTimer
local LockShoot
local UnlockShoot 
local GetFishCountByGroup
local FishFormStart
local FishFormStop
local GetFishPathByGroup
local MakeFish
local AddFish
local GetPathTime
local SetFormFinishTime
local CheckHasType
local GetPlayerCount
local FormWillStart
local GetRoomPlayerCount
local AddAwardFish
local GetPoolGold
local this = {}
local refTime = 480 --固定的刷鱼潮时间
local refCount = 80 --鱼数目上限，达到该值，触发刷鱼潮
local waitTime = 30 --刷鱼阵之前需要等待的时间
local refDTime = 3 --触发刷鱼潮后，出鱼阵的时间间隔
local refreshing
local addFish
local this = {}
local fishTypeList
local fishListAll={  --刷鱼鱼类列表
	group10={1001,1002,1003,1004,1005,1006,1007,},
	group20={1008,1009,1010,1011,1012,1013,},
	group30={1014,1015,1016,1017,},
	group40={1025,1018,1024,1019,1020,1026,},
	group60={1027,1028,1029,1030,}
}

local cfg_time_rand={}  --刷新间隔
cfg_time_rand[10]={rmin=1,rmax=2}
cfg_time_rand[20]={rmin=1,rmax=3}
cfg_time_rand[30]={rmin=10,rmax=12}--保证刷新
cfg_time_rand[40]={rmin=40,rmax=60}--t1+t2
cfg_time_rand[60]={rmin=160,rmax=240}--t1+t2
cfg_time_rand[200]={rmin=70*0.5,rmax=110*0.5}--放水鱼时间区间

local cfg_count_limit={}  --数量限制
cfg_count_limit[10]={lmax=35,lmin=10,n=3} -->lmax的时候不刷,<=lmin的时候立刻刷n,其他刷1
cfg_count_limit[20]={lmax=12,lmin=2,n=1} -->lmax的时候不刷,<=lmin的时候立刻刷n,其他刷1
cfg_count_limit[30]={lmax=3,lmin=1,n=1} --保证数量,不到lmax就一直刷,无lmin,无n
cfg_count_limit[40]={lmax=1,lmin=1,n=1} --t1后检查,>lmax的时候不刷,<lmin的时候立刻刷,其他在t2后刷,无n
cfg_count_limit[60]={lmax=1,lmin=1,n=1} --t1后检查,>lmax的时候不刷,<lmin的时候立刻刷,其他在t2后刷,无n
cfg_count_limit[200]={lmax=1,lmin=1,n=1} --保证数量,不到lmax就一直刷,无lmin,无n

local main_award_chance_list={ --不同次数刷出主力放水目标的概率
	-- 0.0,
	-- 0.5,
	-- 1.0,
------↑测试----↓正式-------
0,
0.1,
0.1,
0.1,
0.2,
1,

}


local main_award_weight_list={

-- {typeid=5002,weight=5,},--蓝鲸
----------------------------------
{typeid=1018,weight=5,},--蓝鲸
{typeid=1019,weight=5,},--独角鲸
{typeid=1020,weight=5,},--巨头鲸
{typeid=1024,weight=5,},--虎鲸
{typeid=1025,weight=5,},--水母
{typeid=1026,weight=5,},--财神鲨

}

local award_weight_list={
{typeid=1018,if_award=1,weight=10,},--120
{typeid=1024,if_award=1,weight=8,},--150
-- {typeid=1025,if_award=1,weight=8,},--160
{typeid=1019,if_award=1,weight=8,},--180
{typeid=1020,if_award=1,weight=8,},--200
{typeid=1026,if_award=1,weight=8,},--250
-- {typeid=1027,if_award=1,weight=5,},--300
-- {typeid=1028,if_award=1,weight=5,},--350
-- {typeid=1029,if_award=1,weight=5,},--400
-- {typeid=1030,if_award=1,weight=5,},--500
-- {typeid=1031,if_award=1,weight=4,},--600
{typeid=1018,if_award=0,weight=80,},--120
{typeid=1024,if_award=0,weight=80,},--150
-- {typeid=1025,if_award=0,weight=80,},--160
{typeid=1019,if_award=0,weight=80,},--180
{typeid=1020,if_award=0,weight=80,},--200
{typeid=1026,if_award=0,weight=80,},--250
-- {typeid=1027,if_award=0,weight=48,},--300
-- {typeid=1028,if_award=0,weight=48,},--350
-- {typeid=1029,if_award=0,weight=48,},--400
-- {typeid=1030,if_award=0,weight=48,},--500
--{typeid=1031,if_award=0,weight=48,},--600

}

local award_rate_list={}
award_rate_list[0]={award_rate=1,main_award_rate=1,room_pool_value=0}--无场次池奖励1x/0
award_rate_list[1]={award_rate=2,main_award_rate=2,room_pool_value=150}--1档场次池奖励1.5x/4500
award_rate_list[2]={award_rate=3,main_award_rate=3,room_pool_value=4500}--2档场次池奖励2x

local fish_shoal = {}

	fish_shoal[1001] = {	--鲫鱼
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,-19,-22},{0,13,5},{0,4,-24},},
t={0,0.4,0.62,},
},
{
pos = {{0,18,19},{0,-4,26},{0,8,25},{0,-5,16},{0,0,20},},
t={0,0.08,0.52,0.96,1.34,},
},
{
pos = {{0,7,6},{0,-2,2},{0,-6,-18},{0,-1,-7},{0,23,-1},{0,-25,-6},{0,-6,12},},
t={0,0.44,0.56,0.96,1.3,1.64,1.74,},
},
-- {
-- pos = {{0,-26,7},{0,-10,26},{0,-14,8},{0,14,-21},{0,-9,16},{0,-22,-4},{0,-4,25},{0,-8,-6},{0,1,9},},
-- t={0,0.08,0.46,0.82,1.26,1.42,1.78,2.12,2.5,},
-- },
	}

	fish_shoal[1002] = {	--香鱼
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,-22,-26},{0,16,2},{0,0,-9},},
t={0,0.4,0.62,},
},
{
pos = {{0,15,-17},{0,25,1},{0,-21,5},{0,-11,11},{0,22,11},},
t={0,0.16,0.46,0.88,1.14,},
},
{
pos = {{0,23,-19},{0,-12,23},{0,13,23},{0,22,3},{0,10,-22},{0,-14,8},{0,-13,16},},
t={0,0.18,0.28,0.32,0.56,0.56,0.94,},
},
-- {
-- pos = {{0,-20,21},{0,20,-12},{0,-17,-8},{0,5,16},{0,-25,-22},{0,-7,16},{0,8,-22},{0,11,-22},{0,-21,24},},
-- t={0,0.18,0.36,0.4,0.76,0.78,1,1.44,1.78,},
-- },
	}
	
	fish_shoal[1003] = {--斑马鱼
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,15,-24},{0,-25,-7},{0,-6,-13},},
t={0,0.04,0.1,},
},
{
pos = {{0,-3,10},{0,-8,19},{0,-24,12},{0,19,-24},{0,10,-11},},
t={0,0.4,0.76,0.92,1.32,},
},
{
pos = {{0,19,-18},{0,5,27},{0,24,-3},{0,-18,-15},{0,25,15},{0,16,16},{0,14,-19},},
t={0,0.1,0.54,0.54,0.92,1.34,1.54,},
},
-- {
-- pos = {{0,-14,-24},{0,24,-5},{0,-1,17},{0,0,22},{0,3,18},{0,6,-19},{0,6,9},{0,-5,-13},{0,5,-7},},
-- t={0,0.2,0.54,0.94,1.36,1.64,2.06,2.34,2.72,},
-- },
	}
	
	fish_shoal[1004] = {--河豚
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,15,21},{0,25,-6},{0,-9,24},},
t={0,0.25,0.48,},
},
{
pos = {{0,1,-10},{0,-11,9},{0,11,-5},{0,16,4},{0,-22,13},},
t={0,0.03,0.63,1.16,1.61,},
},
	}
	
	fish_shoal[1005] = {--鲽鱼
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,3,16},{0,-24,22},{0,5,9},},
t={0,0.23,1.01,},
},
{
pos = {{0,-11,1},{0,29,-17},{0,15,-5},{0,2,6},{0,-11,21},},
t={0,0.43,1.16,1.89,2.59,},
},
	}
	
	fish_shoal[1006] = {--小丑鱼
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,-9,-23},{0,-26,13},{0,-23,34},},
t={0,0.85,0.85,},
},
{
pos = {{0,1,33},{0,16,37},{0,-2,33},{0,29,19},{0,22,37},},
t={0,1.1,2.13,3.16,4.11,},
},
	}
	
	fish_shoal[1007] = {--虎皮鱼
-- {
-- pos = {{0,0,0},},
-- t={0,},
-- },
{
pos = {{0,-35,-39},{0,-24,0},{0,-18,34},},
t={0,1.05,2.1,},
},
{
pos = {{0,49,10},{0,-28,31},{0,0,13},{0,14,-2},{0,41,15},},
t={0,0.5,1.58,2.66,3.74,},
},
	}
	
	fish_shoal[1008] = {--蓝线雀
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,18,11},{0,-19,-21},},
t={0,0.33,},
},
	}
	--火焰灯鱼
	fish_shoal[1009] = {
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,27,-9},{0,24,12},},
t={0,0.88,},
},
	}
	--河豚鮟鱇
	fish_shoal[1010] = {
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,16,-18},{0,-18,0},},
t={0,0.85,},
},
	}
	--射水鱼
	fish_shoal[1011] = {
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,-6,41},{0,57,-28},},
t={0,0.75,},
},
	}
	--乌龟
	fish_shoal[1012] = {
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,18,-58},{0,51,56},},
t={0,0.28,},
},
	}
	--金乌龟
	fish_shoal[1021] = {
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,9,-32},{0,33,-58},},
t={0,1.53,},
},
	}
	--彩虹鱼
	fish_shoal[1013] = {
{
pos = {{0,0,0},},
t={0,},
},
{
pos = {{0,-16,8},{0,-26,44},},
t={0,1.8,},
},
	}


local room_main_award_times = 1

local form_list = {
-- 6,
------------测试↑↓正式----------------
		1,--左右来往
		2,--旋转螺旋
		--3,--远处过来
		4,--双层包
		5,--半圈包
		--6,--全鱼展示
		7,--4方缺角方阵
		8,--4角小丑中蝙蝠/火焰蓝鲸
		9,--固定螺旋
		-- 11,--一网打尽
		-- 12,--电鳗
		13,--回旋
	}

local g300_chance=0.1


fishCtrl[10] = function ()
	local group = 10
	local players = GetPlayerCount()
	local T = math.random(cfg_time_rand[group].rmin,cfg_time_rand[group].rmax)
	local limitMax
	local limitMin
	if players > 2 then
		limitMax = cfg_count_limit[group].lmax  --不刷上限
		limitMin = cfg_count_limit[group].lmin   --立刻刷N条
	else
		limitMax = cfg_count_limit[group].lmax*0.8  --不刷上限
		limitMin = cfg_count_limit[group].lmin*0.5   --立刻刷N条
	end
	local N = cfg_count_limit[group].n --立即补充
	local count = GetFishCountByGroup(group)
	local fishList = fishListAll.group10
	local pathList = GetFishPathByGroup(10)
	local redFishList = {} --用来记录这批鱼中是否有已经刷过红鱼

	-- warn("当前鱼的数目:"..count)

	local function createAll(path, fishes)
		local path = pathList[math.random(#pathList)]
		local fishType = fishList[math.random(#fishList)]
		local cfg = fish_shoal[fishType]
		cfg = cfg[math.random(#cfg)]
		local redRandom = cfg.redRandom or 0.1--红鱼
		local time

		local parent
		local fish
		local t
		local parameter_list = { --parameter_list[math.random(#parameter_list)]
			{1,1,1},
			{-1,1,1},
			{1,-1,1},
			{-1,-1,1},
		}
		parameter_list = parameter_list[math.random(#parameter_list)]

		for k,v in pairs(cfg.t) do
			t = GetPathTime(path)

			parent = MakeFish(0, 0, nil, nil, cfg.pos[k], nil, t + v)
			fish = MakeFish(fishType, v, parent, {path}, nil, nil,nil,"*",parameter_list)  --parameter_list[math.random(#parameter_list)]
			table.insert(fishes, parent)
			table.insert(fishes, fish)
			time = v
		end
		return time
	end

	if 	count > limitMax then
		-- LOG_DEBUG("不用创建")
		SetTimeout(T, fishCtrl[group])
	elseif count > limitMin then
		-- LOG_DEBUG("创建1个单位")
		-- warn("创建1个单位")
		-- SetTimeout(createAll(path) + T, fishCtrl[group])
		local path = pathList[math.random(#pathList)]
		local fishes = {}
		local time = createAll(path, fishes)
		AddFish(fishes)
		SetTimeout(T, fishCtrl[group])
	else
		-- LOG_DEBUG("创建3个单位")
		-- warn("创建5个单位")
		local time
		local fishes = {}
		for i=1,N do
			local path = pathList[math.random(#pathList)]
			table.removebyvalue(pathList, path)
			time = T + createAll(path, fishes)
		end
		AddFish(fishes)
		SetTimeout(time, fishCtrl[group])
	end
end


fishCtrl[20] = function ()
	local group = 20
	local players = GetPlayerCount()
	local T = math.random(cfg_time_rand[group].rmin,cfg_time_rand[group].rmax)
	local limitMax = 20
	local limitMin = 4
	if players > 2 then
		limitMax = cfg_count_limit[group].lmax  --不刷上限
		limitMin = cfg_count_limit[group].lmin   --立刻刷N条
	else
		limitMax = cfg_count_limit[group].lmax*0.8  --不刷上限
		limitMin = cfg_count_limit[group].lmin*0.5   --立刻刷N条
	end

	local N = cfg_count_limit[group].n
	local count = GetFishCountByGroup(group)
	local fishList = fishListAll.group20
	local pathList = GetFishPathByGroup(20)
	local redFishList = {} --用来记录这批鱼中是否有已经刷过红鱼


	-- warn("当前鱼的数目:"..count)



	local function createAll(path, fishes)
		local path = pathList[math.random(#pathList)]
		local fishType = fishList[math.random(#fishList)]
		local cfg = fish_shoal[fishType]
		cfg = cfg[math.random(#cfg)]
		local redRandom = cfg.redRandom or 0.1
		local time

		local parent
		local fish
		local t
		local parameter_list = {
			{1,1,1},
			{-1,1,1},
			{1,-1,1},
			{-1,-1,1},
		}
		parameter_list = parameter_list[math.random(#parameter_list)]

		for k,v in pairs(cfg.t) do
			t = GetPathTime(path)

			parent = MakeFish(0, 0, nil, nil, cfg.pos[k], nil, t + v)
			fish = MakeFish(fishType, v, parent, {path}, nil, nil,nil,"*",parameter_list)
			table.insert(fishes, parent)
			table.insert(fishes, fish)
			time = v
		end
		return time
	end

	if 	count > limitMax then
		-- LOG_DEBUG("不用创建")
		SetTimeout(T, fishCtrl[group])
	elseif count > limitMin then
		-- LOG_DEBUG("创建1个单位")
		-- warn("创建1个单位")
		-- SetTimeout(createAll(path) + T, fishCtrl[group])
		local path = pathList[math.random(#pathList)]
		local fishes = {}
		local time = createAll(path, fishes)
		AddFish(fishes)
		SetTimeout(T, fishCtrl[group])
	else
		-- LOG_DEBUG("创建3个单位")
		-- warn("创建5个单位")
		local time
		local fishes = {}
		for i=1,N do
			local path = pathList[math.random(#pathList)]
			table.removebyvalue(pathList, path)
			time = T + createAll(path, fishes)
		end
		AddFish(fishes)
		SetTimeout(time, fishCtrl[group])
	end
end




fishCtrl[30] = function ()
	local group = 30
	local T = math.random(cfg_time_rand[group].rmin,cfg_time_rand[group].rmax)
	local fishList = fishListAll.group30
	local pathList = GetFishPathByGroup(30)
	local count = GetFishCountByGroup(30)
	local limitMax= cfg_count_limit[group].lmax
	local players = GetPlayerCount()
	local parameter_list = {
		{1,1,1},
		{-1,1,1},
		{1,-1,1},
		{-1,-1,1},
	}
	parameter_list = parameter_list[math.random(#parameter_list)]--镜像
	if count < limitMax then
		local fishType = fishList[math.random(#fishList)]
		local path = pathList[math.random(#pathList)]
		-- CreatFish(fishType, nil, nil, {path})
		AddFish({MakeFish(fishType, 0, nil, {path}, nil, nil,nil,"*",parameter_list)})
		SetTimeout(T, fishCtrl[group])
	else
		SetTimeout(T, fishCtrl[group])
	end
end


fishCtrl[40] = function ()
	local group = 40
	local T = math.random(cfg_time_rand[group].rmin,cfg_time_rand[group].rmax)
	local fishList = fishListAll.group40
	local pathList = GetFishPathByGroup(group)
	local count = GetFishCountByGroup(group)
	local players = GetPlayerCount()
	local limitMax--= 2
	local limitMin--= 1

	if players > 2 then
		limitMax = cfg_count_limit[group].lmax  --不刷上限
		limitMin = cfg_count_limit[group].lmin   --立刻刷N条
	else
		limitMax = cfg_count_limit[group].lmax*0.8  --不刷上限
		limitMin = cfg_count_limit[group].lmin*0.5   --立刻刷N条
	end

	local parameter_list = {
		{1,1,1},
		{-1,1,1},
		{1,-1,1},
		{-1,-1,1},
	}
	parameter_list = parameter_list[math.random(#parameter_list)]--镜像
	if count < limitMax then
		local fishType = fishList[math.random(#fishList)]
		if fishType == 1025 then
			pathList = GetFishPathByGroup(41)
		end			
		local path = pathList[math.random(#pathList)]
		-- CreatFish(fishType, nil, nil, {path})
		AddFish({MakeFish(fishType, 0, nil, {path}, nil, nil,nil,"*",parameter_list)})
		SetTimeout(T,fishCtrl[group])
	else
		SetTimeout(T, fishCtrl[group])
	end
end

fishCtrl[60] = function ()
	local group = 60
	local T = math.random(cfg_time_rand[group].rmin,cfg_time_rand[group].rmax)
	local fishList = fishListAll.group60
	local pathList = GetFishPathByGroup(60)
	local count = GetFishCountByGroup(group)
	local players = GetPlayerCount()
	local limitMax--= 2
	local limitMin--= 1

	if players > 2 then
		limitMax = cfg_count_limit[group].lmax  --不刷上限
		limitMin = cfg_count_limit[group].lmin   --立刻刷N条
	else
		limitMax = cfg_count_limit[group].lmax*0.8  --不刷上限
		limitMin = cfg_count_limit[group].lmin*0.5   --立刻刷N条
	end

	local parameter_list = {
		{1,1,1},
		{-1,1,1},
		{1,-1,1},
		{-1,-1,1},
	}
	parameter_list = parameter_list[math.random(#parameter_list)]--镜像
	if count < limitMax then
		local fishType = fishList[math.random(#fishList)]
		local path = pathList[math.random(#pathList)]
		-- CreatFish(fishType, nil, nil, {path})
		AddFish({MakeFish(fishType, 0, nil, {path}, nil, nil,nil,"*",parameter_list)})
		SetTimeout(T,fishCtrl[group])
	else
		SetTimeout(T,fishCtrl[group])
	end
end

fishCtrl[200] = function ()
	local group = 200
	local players = GetPlayerCount()
	local T = math.random(cfg_time_rand[group].rmin,cfg_time_rand[group].rmax)
	local count = GetFishCountByGroup(group) + GetFishCountByGroup(110)
	local limitMax = cfg_count_limit[group].lmax  --不刷上限
	local limitMin = cfg_count_limit[group].lmin   --立刻刷N条

	local fishList = GetFishTypeByGroup(group)
	local pathList = GetFishPathByGroup(200)
	local parameter_list = {
		{1,1,1},
		{-1,1,1},
		{1,-1,1},
		{-1,-1,1},
	}
	parameter_list = parameter_list[math.random(#parameter_list)]
	local path = pathList[math.random(#pathList)]

	main_award_chance=main_award_chance_list[room_main_award_times]
	local rate_random=math.random()
              
	local pool_value=GetPoolGold()--获得奖池金额
	local room_player_count=GetRoomPlayerCount()--此处缺获取该场次总人数方法
	if room_player_count <=0 then --人数不能为负数和0
		room_player_count=99999
	end
	local award_rate
	local main_award_rate	
	local room_pool_value=pool_value/room_player_count*4

	if room_pool_value <= award_rate_list[0].room_pool_value then--池里面没水
		award_rate=award_rate_list[0].award_rate
		main_award_rate=award_rate_list[0].main_award_rate
	elseif room_pool_value < award_rate_list[1].room_pool_value then--池里面有水
		award_rate=award_rate_list[1].award_rate
		main_award_rate=award_rate_list[1].main_award_rate
	else--池里面有超过的水
		award_rate=award_rate_list[2].award_rate
		main_award_rate=award_rate_list[2].main_award_rate
	end

	local function get_node_by_weight(info, key)
	  -- {{weight=50},{weight=25},{weight=25}},
	  local total = 0
	  for _,v in pairs(info) do
	    total = total + v.weight
	  end
	  local k = math.random(1, total)
	  local sum = 1
	  for _,v in pairs(info) do
	    sum = v.weight + sum
	    if k < sum then
	      if key then
	        return v[key]
	      end
	      return v
	    end
	  end
	  return nil
	end

	local function 	one_strike(if_award,award_rate)
		local one_strike_path = {}
		local id
		local pathList = GetFishPathByGroup(111)
		local parameter_list = {
			{1,1,1},
			{-1,1,1},
			{1,-1,1},
			{-1,-1,1},
		}
		parameter_list = parameter_list[math.random(#parameter_list)]

		id=math.random(#pathList)
		one_strike_path[1]=pathList[id]
		table.remove(pathList,id)
		id=math.random(#pathList)
		one_strike_path[2]=pathList[id]
		table.remove(pathList,id)
		id=math.random(#pathList)
		one_strike_path[3]=pathList[id]

		pathList = GetFishPathByGroup(112)

		id=math.random(#pathList)
		one_strike_path[4]=pathList[id]
		table.remove(pathList,id)
		id=math.random(#pathList)
		one_strike_path[5]=pathList[id]
		table.remove(pathList,id)
		id=math.random(#pathList)
		one_strike_path[6]=pathList[id]
		table.remove(pathList,id)
		id=math.random(#pathList)
		one_strike_path[7]=pathList[id]
		table.remove(pathList,id)
		id=math.random(#pathList)
		one_strike_path[8]=pathList[id]
		
		local fishes = {}
		table.insert(fishes, MakeFish(2004,0.1,nil,{one_strike_path[1]},nil,nil,nil,"*",parameter_list))--111
		table.insert(fishes, MakeFish(2005,0.1,nil,{one_strike_path[2]},nil,nil,nil,"*",parameter_list))
		table.insert(fishes, MakeFish(2006,0.1,nil,{one_strike_path[3]},nil,nil,nil,"*",parameter_list))
		table.insert(fishes, MakeFish(2008,0.1,nil,{one_strike_path[4]},nil,nil,nil,"*",parameter_list))--112
		table.insert(fishes, MakeFish(2009,0.1,nil,{one_strike_path[5]},nil,nil,nil,"*",parameter_list))
		table.insert(fishes, MakeFish(2010,0.1,nil,{one_strike_path[6]},nil,nil,nil,"*",parameter_list))
		table.insert(fishes, MakeFish(2012,0.1,nil,{one_strike_path[7]},nil,nil,nil,"*",parameter_list))
		table.insert(fishes, MakeFish(2014,0.1,nil,{one_strike_path[8]},nil,nil,nil,"*",parameter_list))
		if if_award == 1 then
			AddAwardFish(fishes,award_rate)
		else	
			AddFish(fishes)
		end
	end


	local function fish_200()
		if count < limitMax then
			if rate_random > main_award_chance then
				--不刷主力
				local cfg=get_node_by_weight(award_weight_list)

				if cfg.if_award==0 then --刷普通
					if cfg.typeid == 2010 then --一网打尽
						one_strike(0,award_rate)
					else
						if cfg.typeid == 3003 then --电鳗
							pathList = GetFishPathByGroup(201)
							path = pathList[math.random(#pathList)]
						elseif cfg.typeid < 2000 then --鱼类
							pathList = GetFishPathByGroup(40)
							path = pathList[math.random(#pathList)]
						end
						AddAwardFish({MakeFish(cfg.typeid, 0.1, nil, {path}, nil, nil,nil,"*",parameter_list)},1)
					end
				elseif cfg.if_award==1 then --刷辅助
					local if_pass_award = 1
					if award_rate<=1 then --是否过了这轮放水
						if_pass_award = 0
					end
					if cfg.typeid == 2010 then --开刷
						one_strike(if_pass_award,award_rate)
					else
						if cfg.typeid == 3003 then --各种目标所用路径不同
							pathList = GetFishPathByGroup(201)
							path = pathList[math.random(#pathList)]
						elseif cfg.typeid < 2000 then
							pathList = GetFishPathByGroup(40)
							path = pathList[math.random(#pathList)]						
						end
						if if_pass_award == 1 then
							AddAwardFish({MakeFish(cfg.typeid, 0.1, nil, {path}, nil, nil,nil,"*",parameter_list)},award_rate)--增加奖励鱼AddAwardFish(fishes, rate)
						else
							AddAwardFish({MakeFish(cfg.typeid, 0.1, nil, {path}, nil, nil,nil,"*",parameter_list)},1)
						end
					end
				else
					SetTimeout(5, fishCtrl[group])
				end

				room_main_award_times=room_main_award_times+1
				SetTimeout(5, fishCtrl[group])
			else
				--刷主力Award易爆
				fishList = get_node_by_weight(main_award_weight_list)
				fishType = fishList.typeid 
				pathList = GetFishPathByGroup(40)

				if fishType > 2000 then
					pathList = GetFishPathByGroup(200)
				end
				if fishType == 1025 then
					pathList = GetFishPathByGroup(41)
				end
				if fishType == 3003 then
					pathList = GetFishPathByGroup(201)
				end

				path = pathList[math.random(#pathList)]
	
				AddAwardFish({MakeFish(fishType, 0.1, nil, {path}, nil, nil,nil,"*",parameter_list)},main_award_rate)--增加奖励鱼AddAwardFish(fishes, rate)
				room_main_award_times=1
				SetTimeout(5, fishCtrl[group])
			end
		else 
			SetTimeout(5, fishCtrl[group])
		end
	end
	SetTimeout(T, fish_200)
end


local function stopForm()
	-- body
	FishFormStop()
	SetTimeout(3,addFish)
end

local function fishForm1() --左右来往
	local fishes = {}

	for i=0,50 do
		local fish = MakeFish(1006,i,nil,{5001})
		table.insert(fishes, fish)
	end

table.insert(fishes, MakeFish(1015,0,nil,{5002}))
table.insert(fishes, MakeFish(1016,5,nil,{5002}))
table.insert(fishes, MakeFish(1017,11,nil,{5002}))
table.insert(fishes, MakeFish(1018,19,nil,{5002}))
table.insert(fishes, MakeFish(1019,26,nil,{5005}))
table.insert(fishes, MakeFish(1020,35,nil,{5005}))

table.insert(fishes, MakeFish(1015,0,nil,{5003}))
table.insert(fishes, MakeFish(1016,5,nil,{5003}))
table.insert(fishes, MakeFish(1017,11,nil,{5003}))
table.insert(fishes, MakeFish(1018,19,nil,{5003}))
table.insert(fishes, MakeFish(1019,26,nil,{5006}))
table.insert(fishes, MakeFish(1020,35,nil,{5006}))

	for i=0,50 do
		local fish = MakeFish(1006,i,nil,{5004})
		table.insert(fishes, fish)
	end

	AddFish(fishes)
	SetFormFinishTime(50)
	SetTimeout(65,addFish)
end


local function fishForm2() --滚筒从左到右
	-- body
	local fishes = {}
	table.insert(fishes, MakeFish(1010,0,nil,{5119}))
	table.insert(fishes, MakeFish(1005,0,nil,{5123}))
	table.insert(fishes, MakeFish(1010,0,nil,{5127}))
	table.insert(fishes, MakeFish(1005,0,nil,{5131}))
	table.insert(fishes, MakeFish(1005,1.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,1.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,2.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,2.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,2.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,2.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,3.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,3.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,6.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,6.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,7.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,7.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,7.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,7.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,8.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,8.75,nil,{5131}))

	table.insert(fishes, MakeFish(1016,0,nil,{5135}))

	table.insert(fishes, MakeFish(1010,10,nil,{5119}))
	table.insert(fishes, MakeFish(1005,10,nil,{5123}))
	table.insert(fishes, MakeFish(1010,10,nil,{5127}))
	table.insert(fishes, MakeFish(1005,10,nil,{5131}))
	table.insert(fishes, MakeFish(1005,11.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,11.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,12.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,12.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,12.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,12.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,13.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,13.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,15,nil,{5119}))
	table.insert(fishes, MakeFish(1005,15,nil,{5123}))
	table.insert(fishes, MakeFish(1010,15,nil,{5127}))
	table.insert(fishes, MakeFish(1005,15,nil,{5131}))
	table.insert(fishes, MakeFish(1005,16.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,16.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,17.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,17.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,17.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,17.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,18.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,18.75,nil,{5131}))

	table.insert(fishes, MakeFish(1018,15,nil,{5135}))

	table.insert(fishes, MakeFish(1010,20,nil,{5119}))
	table.insert(fishes, MakeFish(1005,20,nil,{5123}))
	table.insert(fishes, MakeFish(1010,20,nil,{5127}))
	table.insert(fishes, MakeFish(1005,20,nil,{5131}))
	table.insert(fishes, MakeFish(1005,21.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,21.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,22.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,22.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,22.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,22.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,23.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,23.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,25,nil,{5119}))
	table.insert(fishes, MakeFish(1005,25,nil,{5123}))
	table.insert(fishes, MakeFish(1010,25,nil,{5127}))
	table.insert(fishes, MakeFish(1005,25,nil,{5131}))
	table.insert(fishes, MakeFish(1005,26.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,26.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,27.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,27.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,27.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,27.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,28.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,28.75,nil,{5131}))

	table.insert(fishes, MakeFish(1019,30,nil,{5135}))

	table.insert(fishes, MakeFish(1010,30,nil,{5119}))
	table.insert(fishes, MakeFish(1005,30,nil,{5123}))
	table.insert(fishes, MakeFish(1010,30,nil,{5127}))
	table.insert(fishes, MakeFish(1005,30,nil,{5131}))
	table.insert(fishes, MakeFish(1005,31.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,31.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,32.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,32.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,32.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,32.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,33.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,33.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,35,nil,{5119}))
	table.insert(fishes, MakeFish(1005,35,nil,{5123}))
	table.insert(fishes, MakeFish(1010,35,nil,{5127}))
	table.insert(fishes, MakeFish(1005,35,nil,{5131}))
	table.insert(fishes, MakeFish(1005,36.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,36.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,37.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,37.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,37.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,37.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,38.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,38.75,nil,{5131}))

	table.insert(fishes, MakeFish(1020,45,nil,{5135}))

	table.insert(fishes, MakeFish(1010,40,nil,{5119}))
	table.insert(fishes, MakeFish(1005,40,nil,{5123}))
	table.insert(fishes, MakeFish(1010,40,nil,{5127}))
	table.insert(fishes, MakeFish(1005,40,nil,{5131}))
	table.insert(fishes, MakeFish(1005,41.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,41.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,42.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,42.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,42.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,42.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,43.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,43.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,45,nil,{5119}))
	table.insert(fishes, MakeFish(1005,45,nil,{5123}))
	table.insert(fishes, MakeFish(1010,45,nil,{5127}))
	table.insert(fishes, MakeFish(1005,45,nil,{5131}))
	table.insert(fishes, MakeFish(1005,46.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,46.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,47.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,47.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,47.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,47.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,48.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,48.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,50,nil,{5119}))
	table.insert(fishes, MakeFish(1005,50,nil,{5123}))
	table.insert(fishes, MakeFish(1010,50,nil,{5127}))
	table.insert(fishes, MakeFish(1005,50,nil,{5131}))
	table.insert(fishes, MakeFish(1005,51.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,51.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,52.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,52.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,52.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,52.5,nil,{5131}))
	table.insert(fishes, MakeFish(1005,53.75,nil,{5123}))
	table.insert(fishes, MakeFish(1005,53.75,nil,{5131}))
	table.insert(fishes, MakeFish(1010,55,nil,{5119}))
	table.insert(fishes, MakeFish(1005,55,nil,{5123}))
	table.insert(fishes, MakeFish(1010,55,nil,{5127}))
	table.insert(fishes, MakeFish(1005,55,nil,{5131}))
	table.insert(fishes, MakeFish(1005,56.25,nil,{5123}))
	table.insert(fishes, MakeFish(1005,56.25,nil,{5131}))
	table.insert(fishes, MakeFish(1010,57.5,nil,{5119}))
	table.insert(fishes, MakeFish(1005,57.5,nil,{5123}))
	table.insert(fishes, MakeFish(1010,57.5,nil,{5127}))
	table.insert(fishes, MakeFish(1005,57.5,nil,{5131}))

	AddFish(fishes)
	SetFormFinishTime(56)
	SetTimeout(89, stopForm)
end

local function fishForm3() --交错阵型
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
	local fishes = {}
	local p = MakeFish(0,0,nil,nil,{0,-150,300}, {0,0,0},30.5)
	table.insert(fishes, p)
	table.insert(fishes, MakeFish(1001,0,p,{5201}))
	table.insert(fishes, MakeFish(1001,0,p,{5202}))
	table.insert(fishes, MakeFish(1001,0,p,{5203}))
	table.insert(fishes, MakeFish(1001,0,p,{5204}))
	table.insert(fishes, MakeFish(1001,0,p,{5205}))
	table.insert(fishes, MakeFish(1001,0,p,{5206}))
	table.insert(fishes, MakeFish(1001,0,p,{5207}))
	table.insert(fishes, MakeFish(1001,0,p,{5208}))
	table.insert(fishes, MakeFish(1001,0,p,{5209}))
	table.insert(fishes, MakeFish(1001,0,p,{5210}))
	AddFish(fishes)
	SetTimeout(27, stopForm)
end

local function fishForm4() --双层小鱼包大鱼
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
	local fishes = {}
	for i=0,50 do
		local fish = MakeFish(1002,i,nil,{5301})
		table.insert(fishes, fish)
		fish = MakeFish(1005,i+0.5,nil,{5302})
		table.insert(fishes, fish)
		fish = MakeFish(1005,i+0.5,nil,{5304})
		table.insert(fishes, fish)
		fish = MakeFish(1002,i,nil,{5305})
		table.insert(fishes, fish)
	end

	table.insert(fishes, MakeFish(1015,0,p,{5303}))
	table.insert(fishes, MakeFish(1015,4,p,{5306}))
	table.insert(fishes, MakeFish(1015,4,p,{5307}))
	table.insert(fishes, MakeFish(1015,8,p,{5303}))
	table.insert(fishes, MakeFish(1016,13,p,{5303}))
	table.insert(fishes, MakeFish(1017,18,p,{5308}))
	table.insert(fishes, MakeFish(1018,26,p,{5308}))
	table.insert(fishes, MakeFish(1019,33,p,{5308}))

	AddFish(fishes)
	SetFormFinishTime(56)
	SetTimeout(65, stopForm)
end

local function fishForm5() --半圈包围大鱼
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
	local fishes = {}
	for i=0,50 do
		local fish = MakeFish(1009,i,nil,{5401})
		table.insert(fishes, fish)
		fish = MakeFish(1009,i,nil,{5402})
		table.insert(fishes, fish)
	end
	table.insert(fishes, MakeFish(1020,0,p,{5403,5404,5405}))
	table.insert(fishes, MakeFish(1020,0,p,{5406,5407,5408}))


	AddFish(fishes)
	SetFormFinishTime(56)
	SetTimeout(65, stopForm)
end

local function fishForm6()
	local fishes = {}
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
	table.insert(fishes, MakeFish(1001,0,nil,{1}))
	table.insert(fishes, MakeFish(1002,3,nil,{2}))
	table.insert(fishes, MakeFish(1003,6,nil,{3}))
	table.insert(fishes, MakeFish(1004,0,nil,{4}))
	table.insert(fishes, MakeFish(1005,3,nil,{5}))
	table.insert(fishes, MakeFish(1006,6,nil,{6}))
	table.insert(fishes, MakeFish(1007,9,nil,{7}))
	table.insert(fishes, MakeFish(1008,12,nil,{8}))
	table.insert(fishes, MakeFish(1009,15,nil,{9}))
	table.insert(fishes, MakeFish(1010,0,nil,{10}))
	table.insert(fishes, MakeFish(1011,3,nil,{11}))
	table.insert(fishes, MakeFish(1012,6,nil,{12}))
	table.insert(fishes, MakeFish(1013,9,nil,{13}))
	table.insert(fishes, MakeFish(1014,12,nil,{14}))
	table.insert(fishes, MakeFish(1015,15,nil,{15}))
	table.insert(fishes, MakeFish(1016,0,nil,{16}))
	table.insert(fishes, MakeFish(1017,4,nil,{17}))
	table.insert(fishes, MakeFish(1018,8,nil,{18}))
	table.insert(fishes, MakeFish(1019,12,nil,{19}))
	table.insert(fishes, MakeFish(1020,16,nil,{20}))
	table.insert(fishes, MakeFish(1021,18,nil,{21}))
	table.insert(fishes, MakeFish(1022,20,nil,{22}))
	table.insert(fishes, MakeFish(1023,22,nil,{23}))
	table.insert(fishes, MakeFish(1024,24,nil,{24}))
	table.insert(fishes, MakeFish(1025,26,nil,{25}))
	table.insert(fishes, MakeFish(1026,28,nil,{26}))
	table.insert(fishes, MakeFish(1027,30,nil,{27}))
	table.insert(fishes, MakeFish(1028,32,nil,{28}))
	table.insert(fishes, MakeFish(1029,34,nil,{29}))
	table.insert(fishes, MakeFish(1030,36,nil,{30}))
	table.insert(fishes, MakeFish(1031,38,nil,{31}))
	table.insert(fishes, MakeFish(1032,40,nil,{32}))
	table.insert(fishes, MakeFish(1033,42,nil,{33}))
	AddFish(fishes)

	SetTimeout(50, stopForm)
end

local function fishForm7() --4方缺角方阵
	local fishes = {}

	table.insert(fishes, MakeFish(1016,1.0,nil,{5708}))
	table.insert(fishes, MakeFish(1020,8.0,nil,{5708}))
	table.insert(fishes, MakeFish(1016,1.0,nil,{5709}))
	table.insert(fishes, MakeFish(1020,8.0,nil,{5709}))

table.insert(fishes, MakeFish(1005,3.4,nil,{5701}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5701}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5701}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5701}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5701}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5701}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5701}))

table.insert(fishes, MakeFish(1005,1.7,nil,{5702}))
table.insert(fishes, MakeFish(1005,3.4,nil,{5702}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5702}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5702}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5702}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5702}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5702}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5702}))
table.insert(fishes, MakeFish(1005,15.3,nil,{5702}))

table.insert(fishes, MakeFish(1005,0,nil,{5703}))
table.insert(fishes, MakeFish(1005,1.7,nil,{5703}))
table.insert(fishes, MakeFish(1005,3.4,nil,{5703}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5703}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5703}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5703}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5703}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5703}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5703}))
table.insert(fishes, MakeFish(1005,15.3,nil,{5703}))
table.insert(fishes, MakeFish(1005,17,nil,{5703}))
table.insert(fishes, MakeFish(1005,0,nil,{5704}))
table.insert(fishes, MakeFish(1005,1.7,nil,{5704}))
table.insert(fishes, MakeFish(1005,3.4,nil,{5704}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5704}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5704}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5704}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5704}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5704}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5704}))
table.insert(fishes, MakeFish(1005,15.3,nil,{5704}))
table.insert(fishes, MakeFish(1005,17,nil,{5704}))
table.insert(fishes, MakeFish(1005,0,nil,{5705}))
table.insert(fishes, MakeFish(1005,1.7,nil,{5705}))
table.insert(fishes, MakeFish(1005,3.4,nil,{5705}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5705}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5705}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5705}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5705}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5705}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5705}))
table.insert(fishes, MakeFish(1005,15.3,nil,{5705}))
table.insert(fishes, MakeFish(1005,17,nil,{5705}))

table.insert(fishes, MakeFish(1005,1.7,nil,{5706}))
table.insert(fishes, MakeFish(1005,3.4,nil,{5706}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5706}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5706}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5706}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5706}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5706}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5706}))
table.insert(fishes, MakeFish(1005,15.3,nil,{5706}))

table.insert(fishes, MakeFish(1005,3.4,nil,{5707}))
table.insert(fishes, MakeFish(1005,5.1,nil,{5707}))
table.insert(fishes, MakeFish(1005,6.8,nil,{5707}))
table.insert(fishes, MakeFish(1005,8.5,nil,{5707}))
table.insert(fishes, MakeFish(1005,10.2,nil,{5707}))
table.insert(fishes, MakeFish(1005,11.9,nil,{5707}))
table.insert(fishes, MakeFish(1005,13.6,nil,{5707}))

	AddFish(fishes)
	SetFormFinishTime(16)
	SetTimeout(40, stopForm)
end


local function fishForm8() --4角小丑中蝙蝠
	local fishes = {}
	table.insert(fishes, MakeFish(1008,0,nil,{5801}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,7.5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,10,nil,{5801}))
	table.insert(fishes, MakeFish(1008,12.5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,15,nil,{5801}))
	table.insert(fishes, MakeFish(1008,17.5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,20,nil,{5801}))
	table.insert(fishes, MakeFish(1008,22.5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,25,nil,{5801}))
	table.insert(fishes, MakeFish(1008,27.5,nil,{5801}))
	table.insert(fishes, MakeFish(1008,30,nil,{5801}))

	table.insert(fishes, MakeFish(1008,0,nil,{5802}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,7.5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,10,nil,{5802}))
	table.insert(fishes, MakeFish(1008,12.5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,15,nil,{5802}))
	table.insert(fishes, MakeFish(1008,17.5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,20,nil,{5802}))
	table.insert(fishes, MakeFish(1008,22.5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,25,nil,{5802}))
	table.insert(fishes, MakeFish(1008,27.5,nil,{5802}))
	table.insert(fishes, MakeFish(1008,30,nil,{5802}))

	table.insert(fishes, MakeFish(1008,0,nil,{5803}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,7.5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,10,nil,{5803}))
	table.insert(fishes, MakeFish(1008,12.5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,15,nil,{5803}))
	table.insert(fishes, MakeFish(1008,17.5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,20,nil,{5803}))
	table.insert(fishes, MakeFish(1008,22.5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,25,nil,{5803}))
	table.insert(fishes, MakeFish(1008,27.5,nil,{5803}))
	table.insert(fishes, MakeFish(1008,30,nil,{5803}))

	table.insert(fishes, MakeFish(1008,0,nil,{5804}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,7.5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,10,nil,{5804}))
	table.insert(fishes, MakeFish(1008,12.5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,15,nil,{5804}))
	table.insert(fishes, MakeFish(1008,17.5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,20,nil,{5804}))
	table.insert(fishes, MakeFish(1008,22.5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,25,nil,{5804}))
	table.insert(fishes, MakeFish(1008,27.5,nil,{5804}))
	table.insert(fishes, MakeFish(1008,30,nil,{5804}))

	table.insert(fishes, MakeFish(1018,0,nil,{5805}))
	table.insert(fishes, MakeFish(1018,10,nil,{5805}))
	table.insert(fishes, MakeFish(1018,20,nil,{5805}))

	AddFish(fishes)
	SetFormFinishTime(31)
	SetTimeout(50, stopForm)
end

local function fishForm9() --固定螺旋
	local fishes = {}
	table.insert(fishes, MakeFish(1006,0,nil,{5901}))
	table.insert(fishes, MakeFish(1006,1.5,nil,{5902}))
	table.insert(fishes, MakeFish(1006,3,nil,{5903}))
	table.insert(fishes, MakeFish(1006,4.5,nil,{5904}))
	table.insert(fishes, MakeFish(1006,6,nil,{5905}))
	table.insert(fishes, MakeFish(1006,7.5,nil,{5906}))
	table.insert(fishes, MakeFish(1006,9,nil,{5907}))
	table.insert(fishes, MakeFish(1006,10.5,nil,{5908}))
	table.insert(fishes, MakeFish(1006,12,nil,{5909}))
	table.insert(fishes, MakeFish(1006,13.5,nil,{5910}))
	table.insert(fishes, MakeFish(1006,15,nil,{5911}))
	table.insert(fishes, MakeFish(1006,16.5,nil,{5912}))
	table.insert(fishes, MakeFish(1006,18,nil,{5913}))
	table.insert(fishes, MakeFish(1006,19.5,nil,{5914}))
	table.insert(fishes, MakeFish(1006,21,nil,{5915}))
	table.insert(fishes, MakeFish(1006,22.5,nil,{5916}))
	table.insert(fishes, MakeFish(1006,24,nil,{5901}))
	table.insert(fishes, MakeFish(1006,25.5,nil,{5902}))
	table.insert(fishes, MakeFish(1006,27,nil,{5903}))
	table.insert(fishes, MakeFish(1006,28.5,nil,{5904}))
	table.insert(fishes, MakeFish(1006,30,nil,{5905}))
	table.insert(fishes, MakeFish(1006,31.5,nil,{5906}))
	table.insert(fishes, MakeFish(1006,33,nil,{5907}))
	table.insert(fishes, MakeFish(1006,34.5,nil,{5908}))
	table.insert(fishes, MakeFish(1006,36,nil,{5901}))

	table.insert(fishes, MakeFish(1006,0,nil,{5909}))
	table.insert(fishes, MakeFish(1006,1.5,nil,{5910}))
	table.insert(fishes, MakeFish(1006,3,nil,{5911}))
	table.insert(fishes, MakeFish(1006,4.5,nil,{5912}))
	table.insert(fishes, MakeFish(1006,6,nil,{5913}))
	table.insert(fishes, MakeFish(1006,7.5,nil,{5914}))
	table.insert(fishes, MakeFish(1006,9,nil,{5915}))
	table.insert(fishes, MakeFish(1006,10.5,nil,{5916}))
	table.insert(fishes, MakeFish(1006,12,nil,{5901}))
	table.insert(fishes, MakeFish(1006,13.5,nil,{5902}))
	table.insert(fishes, MakeFish(1006,15,nil,{5903}))
	table.insert(fishes, MakeFish(1006,16.5,nil,{5904}))
	table.insert(fishes, MakeFish(1006,18,nil,{5905}))
	table.insert(fishes, MakeFish(1006,19.5,nil,{5906}))
	table.insert(fishes, MakeFish(1006,21,nil,{5907}))
	table.insert(fishes, MakeFish(1006,22.5,nil,{5908}))
	table.insert(fishes, MakeFish(1006,24,nil,{5909}))
	table.insert(fishes, MakeFish(1006,25.5,nil,{5910}))
	table.insert(fishes, MakeFish(1006,27,nil,{5911}))
	table.insert(fishes, MakeFish(1006,28.5,nil,{5912}))
	table.insert(fishes, MakeFish(1006,30,nil,{5913}))
	table.insert(fishes, MakeFish(1006,31.5,nil,{5914}))
	table.insert(fishes, MakeFish(1006,33,nil,{5915}))
	table.insert(fishes, MakeFish(1006,34.5,nil,{5916}))
	table.insert(fishes, MakeFish(1006,36,nil,{5909}))

	table.insert(fishes, MakeFish(1020,6,nil,{5917}))
	table.insert(fishes, MakeFish(1020,18,nil,{5917}))
	table.insert(fishes, MakeFish(1020,30,nil,{5917}))

	AddFish(fishes)
	SetFormFinishTime(37)
	SetTimeout(50, stopForm)
end



local function fishForm11()
	--驾立测试一网打尽
	local fishes = {}
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
 table.insert(fishes, MakeFish(2004,0,nil,{11101}))	
 table.insert(fishes, MakeFish(2005,0,nil,{11102}))	
 table.insert(fishes, MakeFish(2006,0,nil,{11103}))	
 table.insert(fishes, MakeFish(2008,0,nil,{11104}))	
 table.insert(fishes, MakeFish(2009,0,nil,{11105}))	
 table.insert(fishes, MakeFish(2010,0,nil,{11106}))	
 table.insert(fishes, MakeFish(2012,0,nil,{11107}))	
 table.insert(fishes, MakeFish(2014,0,nil,{11208}))	
 table.insert(fishes, MakeFish(2016,0,nil,{11209}))	

	AddFish(fishes)
	SetTimeout(200, stopForm)
end


local function fishForm12()
	--驾立测试电鳗
	local fishes = {}
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
 table.insert(fishes, MakeFish(1001,0,nil,{3001}))	
 table.insert(fishes, MakeFish(1001,2,nil,{3001}))	
 table.insert(fishes, MakeFish(1001,4,nil,{3001}))	
 table.insert(fishes, MakeFish(1002,1,nil,{3002}))	
 table.insert(fishes, MakeFish(1002,4,nil,{3002}))	
 table.insert(fishes, MakeFish(1003,2,nil,{3003}))	
 table.insert(fishes, MakeFish(1003,5,nil,{3003}))	
 table.insert(fishes, MakeFish(1004,3,nil,{3004}))	
 table.insert(fishes, MakeFish(1005,4,nil,{3005}))	
 table.insert(fishes, MakeFish(1006,5,nil,{3006}))	
 table.insert(fishes, MakeFish(1007,6,nil,{3007}))	
 table.insert(fishes, MakeFish(1008,7,nil,{3008}))	
 table.insert(fishes, MakeFish(1009,8,nil,{3009}))	
 table.insert(fishes, MakeFish(1010,9,nil,{3010}))	
 table.insert(fishes, MakeFish(1012,10,nil,{3011}))	
 table.insert(fishes, MakeFish(1021,11,nil,{3012}))	
 table.insert(fishes, MakeFish(1013,12,nil,{3013}))	
 table.insert(fishes, MakeFish(3003,4,nil,{3013}))	



	AddFish(fishes)

	SetTimeout(200, stopForm)
end

local function fishForm13() --回旋鱼潮
	local fishes = {}
	-- MakeFish(type, delay, parent, path, pos, rot, lifeTime)
	-- local p = MakeFish(0,0,nil,{5003,5001,5002},nil,nil)
	-- table.insert(fishes, p)
	table.insert(fishes, MakeFish(1016,0,nil,{6218,6208,6238,6228}))
	table.insert(fishes, MakeFish(1016,2.5,nil,{6218,6208,6238,6228}))
	table.insert(fishes, MakeFish(1016,5,nil,{6218,6208,6238,6228}))
	table.insert(fishes, MakeFish(1016,7.5,nil,{6218,6208,6238,6228}))
	table.insert(fishes, MakeFish(1016,0,nil,{6219,6209,6239,6229}))
	table.insert(fishes, MakeFish(1016,2.5,nil,{6219,6209,6239,6229}))
	table.insert(fishes, MakeFish(1016,5,nil,{6219,6209,6239,6229}))
	table.insert(fishes, MakeFish(1016,7.5,nil,{6219,6209,6239,6229}))

	table.insert(fishes, MakeFish(1008,0,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,1,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,2,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,3,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,3.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,4,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,4.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,5.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,6,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,6.5,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,7,nil,{6211,6201,6231,6221}))
	table.insert(fishes, MakeFish(1008,7.5,nil,{6211,6201,6231,6221}))

	table.insert(fishes, MakeFish(1008,0,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,1,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,2,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,3,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,3.5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,4,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,4.5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,5.5,nil,{6212,6202,6232,6222}))
	table.insert(fishes, MakeFish(1008,6,nil,{6212,6202,6232,6222}))

	table.insert(fishes, MakeFish(1008,0,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,1,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,2,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,3,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,3.5,nil,{6213,6203,6233,6223}))
	table.insert(fishes, MakeFish(1008,4,nil,{6213,6203,6233,6223}))

	table.insert(fishes, MakeFish(1008,0,nil,{6214,6204,6234,6224}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6214,6204,6234,6224}))
	table.insert(fishes, MakeFish(1008,1,nil,{6214,6204,6234,6224}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6214,6204,6234,6224}))
	table.insert(fishes, MakeFish(1008,2,nil,{6214,6204,6234,6224}))

	table.insert(fishes, MakeFish(1008,0,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,1,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,2,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,3,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,3.5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,4,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,4.5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,5.5,nil,{6215,6205,6235,6225}))
	table.insert(fishes, MakeFish(1008,6,nil,{6215,6205,6235,6225}))

	table.insert(fishes, MakeFish(1008,0,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,1,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,2,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,2.5,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,3,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,3.5,nil,{6216,6206,6236,6226}))
	table.insert(fishes, MakeFish(1008,4,nil,{6216,6206,6236,6226}))

	table.insert(fishes, MakeFish(1008,0,nil,{6217,6207,6237,6227}))
	table.insert(fishes, MakeFish(1008,0.5,nil,{6217,6207,6237,6227}))
	table.insert(fishes, MakeFish(1008,1,nil,{6217,6207,6237,6227}))
	table.insert(fishes, MakeFish(1008,1.5,nil,{6217,6207,6237,6227}))
	table.insert(fishes, MakeFish(1008,2,nil,{6217,6207,6237,6227}))

	AddFish(fishes)
	SetFormFinishTime(10)
	SetTimeout(65, stopForm)
end

local usedFormList

local FishFormList = {
	fishForm1,--左右来往
	fishForm2,--旋转螺旋
	fishForm3,--远处过来
	fishForm4,--双层包
	fishForm5,--半圈包
	fishForm6,--全鱼展示
	fishForm7,--4方缺角方阵
	fishForm8,--4角小丑中蝙蝠/火焰蓝鲸
	fishForm9,--固定螺旋
	fishForm10,--无
	fishForm11,--一网打尽
	fishForm12,--电鳗
	fishForm13,--回旋
}

local function relashFishGroup()
	-- local list = {
	-- fishForm11,
	-- }
	
	local list = {}
	for i=1,#form_list do
		table.insert(list, FishFormList[form_list[i]])
	end

	local list2 = {}
	for i,v in ipairs(list) do
		if not table.indexof(usedFormList, v) then
			--如果使用过的list里面不存在v
			table.insert(list2, v)
		end
	end

	--从未使用过的鱼阵数组里面随机出一个鱼阵
	local form = list2[math.random(#list2)]

	--将即将要刷新的鱼阵放入已经使用过的list里面(放入队列末尾)，标记为已经使用
	table.insert(usedFormList, form)
	if #usedFormList > 4 then
		--如果已经使用过的鱼阵list长度超过4，那么删除队列中的第一个元素
		table.remove(usedFormList, 1)
	end

	SetTimeout(3, form)

	UnlockShoot()
	FishFormStart()--执行鱼潮
end

local function startFishForm()
	LockShoot(refDTime)
	SetTimeout(refDTime, relashFishGroup)
end

local function reflashFishHandler()
	-- body
	if refreshing then return end
	refreshing = true
	--这里做惊吓处理

	FormWillStart()

	SetTimeout(waitTime, startFishForm)
end

addFish = function ()
	-- body
	refreshing = nil
	
	for k,v in pairs(fishCtrl) do
		v()
	end
	-- fishForm7()
	SetTimeout(refTime, reflashFishHandler)
	-- CreatFish(1001,nil,nil,{5002})
	-- fishForm2()
end

function this.FishDestroy(type)
	table.removebyvalue(fishTypeList,type)
end

function this.ChanageCount(count)
	-- body
	-- if count >= refCount and not refreshing then
	-- 	SetTimeout(0.1,reflashFishHandler)
		-- reflashFishHandler()
	-- end
end

function this.SetCtrl(c)
	-- body
	ctrl = c
	SetTimeout = ctrl.SetTimeout                    --(duration, handler, ...)duration:时间间隔，handler:待执行函数，...：待执行函数的参数
	GetFishTypeByGroup = ctrl.GetFishTypeByGroup 	--根据group取到该group下的所有的鱼type的一个数组。
	LockShoot = ctrl.LockShoot                   	--锁定子弹，锁定后子弹就不能被打中鱼（刷鱼潮的时候使用）
	UnlockShoot  = ctrl.UnlockShoot              	--解锁子弹
	GetFishCountByGroup = ctrl.GetFishCountByGroup	--根据group取到当前场景中该group的所有的鱼的数量
	FishFormStart = ctrl.FishFormStart              --开始刷鱼阵了
	FishFormStop = ctrl.FishFormStop                --结束刷鱼阵了
	GetFishPathByGroup = ctrl.GetFishPathByGroup    --根据group获得鱼路径
	MakeFish = ctrl.MakeFish                        --生成一个鱼/父级  MakeFish(type, delay, parent, path, pos, rot, time(没有就取path的时间), operation, parameter)  operation："+-*/" parameter：{x,y,z}
	AddFish = ctrl.AddFish                          --将鱼/父级的生成指令发送出去AddFish({p,p,f,f,p,p,f})
	GetPathTime = ctrl.GetPathTime                  --根据路径获得路径所需时间
	SetFormFinishTime = ctrl.SetFormFinishTime      --设置鱼阵刷鱼的结束时间，SetFormFinishTime(time)
	CheckHasType = ctrl.CheckHasType                --检查是否包含某type的鱼存在
	GetPlayerCount = ctrl.GetPlayerCount            --获得玩家个数
	FormWillStart = ctrl.FormWillStart              --通知逻辑，鱼阵即将开始
	GetRoomPlayerCount = ctrl.GetRoomPlayerCount	--共享同个场次池的玩家个数
	AddAwardFish = ctrl.AddAwardFish                --增加奖励鱼AddAwardFish(fishes, rate)--函数里面的makefish时间必须＞0
	GetPoolGold = ctrl.GetPoolGold                  --获得奖池金额end
end

function this.Start()
	-- body

	-- CreatFish(3001,)
	usedFormList = {}
	fishTypeList = {}
	addFish()
end
function this.Destroy()
	-- body
end

function this.Update(time)
	-- body
end
return this
