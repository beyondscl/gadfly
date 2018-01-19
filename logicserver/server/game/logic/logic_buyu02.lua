local fishingGrounds = require "fishingGrounds01"

local this = {}
local players
local code
local handlerId = 0
local fishID = 0

local tinsert = table.insert
local timerHandlers = {}
local helper = {}


local function updateHandler()
	local nowTime = skynet.now()
	for k,v in pairs(timerHandlers) do
		if v and nowTime - v.startTime >= v.duration then
			v.handler(table.unpack(v.params))
			v.times = v.times + 1
			if v.loop > 0 and v.times >= v.loop then
				timerHandlers[k] = nil
			else
				v.startTime = nowTime
			end
		end
	end
end

--区别于timer:此处实现的timer是可以暂停的。
local function SetTimer(duration, loop, handler, ...)
	assert(handler)
	duration = duration * 100
	handlerId = handlerId + 1
	local info = {
					startTime = skynet.now(),
					duration = duration, 
					loop = loop,
					handler = handler,
					params = table.pack(...),
					times = 0,
				}
	timerHandlers[handlerId] = info
	return handlerId, info
end

local function ClearTimer(id)
	-- body
	if not id then return end
	timerHandlers[id] = nil
end
local function ClearAllTimer()
	-- body
	for k,v in pairs(timerHandlers) do
		timerHandlers[k] = nil
	end
	handlerId = 0
end


function helper.SetTimeout(duration, handler, ...)
	-- body
	-- LOG_DEBUG("---------------SetTimeout")
	if duration == 0 then
		handler(...)
		return
	end
	return SetTimer(duration, 1, handler, ...)
end
function helper.SetFormFinishTime(time)
	-- helper.SetTimeout(time, setCanFinish)
end
function helper.ClearTimer(id)
	ClearTimer(id)
end
function helper.PauseAll(time)
	-- body
	for k,v in pairs(timerHandlers) do
		if v and v.startTime then
			v.startTime = v.startTime + time * 100
		end
	end
end
function helper.PauseByID(id, time)
	-- body
	local timer = timerHandlers[id]
	if timer and timer.startTime then
		timer.startTime = timer.startTime + time * 100
	end
end

function helper.AddFish(fishes, award, rightnow)
	local delay
	if rightnow then
		delay = 0
	else
		-- 三秒后再出鱼，用于消除网络延迟带来的鱼不同步问题，客户端也是三秒后出鱼
		delay = 3
	end
	local addtime = os.time() + delay
	local fish
	local shortFishes = {}
	for k,f in pairs(fishes) do
		-- LOG_DEBUG("准备增加类型:"..f.type)
		-- LOG_DEBUG("delay="..f.delay)
		-- 三秒后再出鱼，用于消除网络延迟带来的鱼不同步问题，客户端也是三秒后出鱼
		f.addtime = skynet.now() + delay*100
		fishinfoList[f.id] = f
		if f.delay and f.delay > 0 then
			helper.SetTimeout(f.delay/100+delay, m_createFish, f, award)
			-- tinsert(fishinfoList, f)
		else
			helper.SetTimeout(delay, m_createFish, f, award)
		end
		
		tinsert(shortFishes, f)
		if #shortFishes > 10 then
			sent_msg(0, "game.AddFish", {fishes = shortFishes})
			shortFishes = {}
		end
	end

	if #shortFishes > 0 then
		sent_msg(0, "game.AddFish", {fishes = shortFishes})
	end
	-- LOG_DEBUG("加鱼")
end

function helper.MakeFish(type, delay, parent, path, pos, rot, time, operation, parameter)
	fishID = fishID + 1
	if operation == "+" then
		operation = 1
	elseif operation == "-" then
		operation = 2
	elseif operation == "*" then
		operation = 3
	elseif operation == "/" then
		operation = 4
	else
		operation = nil
	end
	
	if parent then parent = parent.id end
	if time then time = time * 100 end
	if delay then delay = delay * 100 end
	return {type = type, id = fishID, delay = delay or 0, parent = parent, 
	path = path, pos = pos, rot = rot, time = time, pathOperation = operation, pathParams = parameter}
end

------------------------------------------------------------------------------------------------

function this.free()
	
end

function this.update()
	
end

function this.join(p)
	p.seatid = 0
	p.ready = 0
	p.score = 0
	return true
end

function this.dispatch(p, name, msg)
	LOG_DEBUG(p.uid..":"..name)
end

-- 发送房间信息
function this.send_tableinfo(p)
	local msg = {}
	local list = {}
	for uid,v in pairs(players) do
		tinsert(list, { uid = v.uid, 
						nickname=v.nickname,
						seatid=v.seatid or 0,
						ready=v.ready or 0,
						online=v.online or 1,
						score=v.score or 0,
						sex = v.sex or 1})
	end
	msg.owner = 1
	msg.endtime = 0
	msg.gameid = 0
	msg.times = 0
	msg.playedtimes = 0
	msg.score = 0
	msg.paytype = 1
	msg.code = code
	msg.players = list
 --   luadump(msg)
	p:send_msg("game.TableInfo", msg)
end

function this.resume(p)

end

-- 尝试离开游戏，如果能离开，返回true，并且调用该函数的地方继续处理离开逻辑
function this.leave_game(p)
	return true
end

function this.init(ps, api, m_conf, m_times, m_score, m_pay, m_code, m_gameid, uid)
	players = ps
	code = m_code

-- 	function this.SetCtrl(c)
-- 	-- body
-- 	ctrl = c
-- 	SetTimeout = ctrl.SetTimeout                    --(duration, handler, ...)duration:时间间隔，handler:待执行函数，...：待执行函数的参数
-- 	GetFishTypeByGroup = ctrl.GetFishTypeByGroup 	--根据group取到该group下的所有的鱼type的一个数组。
-- 	LockShoot = ctrl.LockShoot                   	--锁定子弹，锁定后子弹就不能被打中鱼（刷鱼潮的时候使用）
-- 	UnlockShoot  = ctrl.UnlockShoot              	--解锁子弹
-- 	GetFishCountByGroup = ctrl.GetFishCountByGroup	--根据group取到当前场景中该group的所有的鱼的数量
-- 	FishFormStart = ctrl.FishFormStart              --开始刷鱼阵了
-- 	FishFormStop = ctrl.FishFormStop                --结束刷鱼阵了
-- 	GetFishPathByGroup = ctrl.GetFishPathByGroup    --根据group获得鱼路径
-- 	MakeFish = ctrl.MakeFish                        --生成一个鱼/父级  MakeFish(type, delay, parent, path, pos, rot, time(没有就取path的时间), operation, parameter)  operation："+-*/" parameter：{x,y,z}
-- 	AddFish = ctrl.AddFish                          --将鱼/父级的生成指令发送出去AddFish({p,p,f,f,p,p,f})
-- 	GetPathTime = ctrl.GetPathTime                  --根据路径获得路径所需时间
-- 	SetFormFinishTime = ctrl.SetFormFinishTime      --设置鱼阵刷鱼的结束时间，SetFormFinishTime(time)
-- 	CheckHasType = ctrl.CheckHasType                --检查是否包含某type的鱼存在
-- 	GetPlayerCount = ctrl.GetPlayerCount            --获得玩家个数
-- 	FormWillStart = ctrl.FormWillStart              --通知逻辑，鱼阵即将开始
-- 	GetRoomPlayerCount = ctrl.GetRoomPlayerCount	--共享同个场次池的玩家个数
-- 	AddAwardFish = ctrl.AddAwardFish                --增加奖励鱼AddAwardFish(fishes, rate)--函数里面的makefish时间必须＞0
-- 	GetPoolGold = ctrl.GetPoolGold                  --获得奖池金额end
-- end

end

return this