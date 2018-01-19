local skynet = require "skynet"
local cluster = require "skynet.cluster"
local dbs_count = skynet.getenv "dbs_count"
local nodename = skynet.getenv "nodename"
dbs_count = tonumber(dbs_count)

local CMD = {}
local api = {}
local logic
local code
local players = {}  --uid==>player
local count
local config
local manager
local pay
local creater

local redis

local function call_datamanager(uid, func, ...)
	local index = uid % dbs_count
	index = index + 1
	local node = "dbs"..index
	local ok,id = pcall(cluster.query, node, "manager")
	assert(ok, id)
	if ok and id then
		return cluster.call(node, id, func, ...)
	end
end


local function decode_data(data)
	return skynet.unpack(data)
end

local function encode_data(info)
	return skynet.packstring(info)
end

function tick_tick()
	while true do
		if logic then
			logic.update()
			-- LOG_DEBUG("tick_tick")
		end
		skynet.sleep(10)
	end
end

local function send_msg(self, name, msg)
	if self.online ~= 1 then return end
--	LOG_DEBUG("send msg:"..name..","..self.uid)
	local ok, result = pcall(cluster.send, self.agnode, self.agaddr, "send_to_client", self.uid, name, msg)
	if not ok then
		LOG_ERROR("send_msg error:"..tostring(result))
		LOG_ERROR("name:"..name..",node:"..tostring(self.agnode)..",addr="..tostring(self.agaddr))
	end
end

local function call_userdata(self, func, ...)
	return cluster.call(self.datnode, self.dataddr, func, self.uid, ...)
end


-- local function kick(self)
-- 	self:send_msg()
-- end

-- 1006 房间已满
-- 1008 加入房间失败
function CMD.init(conf, gameid, times, score, paytype, co, p, mgr)
	code = co
	config = conf
	logic = require("logic_"..conf.logic)
	count = 0
	players = {}
	manager = mgr
	pay = paytype
	creater = p.uid
	
	logic.init(players, api, conf, times, score, paytype, code, gameid, p.uid)

	-- 将数据保存到redis
	local time = os.time()
	-- luadump({time,time+config.wait_time,paytype,times,score,gameid,code})
	local info = encode_data({time,time+config.wait_time,paytype,times,score,gameid,code})
	pcall(skynet.send, redis, "lua", "execute", "RPUSH", "tablelist->"..p.uid, info)
	return CMD.join(p)
end

function CMD.join(p)
	-- 返回nil表示成功
	if not logic then return 101 end

	if count > config.max_player then
		return 1006
	end

	p.send_msg = send_msg
	p.call_userdata = call_userdata
	local result = logic.join(p)
	if result then
		-- "user.QuickJoinResonpse", {result=0}
		p.seatid = p.seatid or 0
		p.ready = p.ready or 0
		p.online = 1 --0不在线，1在线
		p.score = p.score or 0
		players[p.uid] = p
		count = count + 1

		-- 给客户端发送加入成功的协议
		p:send_msg("user.QuickJoinResonpse", {result=0})

		logic.send_tableinfo(p)
		api.send_except("game.EnterTable", {uid=p.uid, nickname=p.nickname, sex = p.sex or 1}, p.uid)
		logic.resume(p)
	else
		return 1008
	end
end

function CMD.dispatch(uid, name, msg)
	local p = players[uid]

	if name == "ChatNtf" then
		if msg.type == 1 or msg.type == 2 then
			if msg.msg and msg.msg >= 0 and msg.msg < 50 then
				api.send_to_all("game.ChatNtf", {type=msg.type,to=0,msg=msg.msg,uid=uid})
			end
		end

		if msg.type == 3 then
			local expression_cfg = require "special_expression_conf"
			
			if msg.msg and expression_cfg[msg.msg] and expression_cfg[msg.msg].cost then
				local p = players[uid]
				if p then
					local sub_gold_ret = p:call_userdata("sub_gold", p.uid, expression_cfg[msg.msg].cost, 1002)
					if sub_gold_ret then
						api.send_to_all("game.ChatNtf", {type=msg.type,to=to,msg=msg.msg,uid=uid})
					else
						p:send_msg("game.ChatNtfResult", {result = 1})
					end
				end
			end
		end
		return 
	elseif name == "Resume" then
		if p then
			p.online = 1
			logic.send_tableinfo(p)
			logic.resume(p)
		end 
	else
		if p then
			return logic.dispatch(p, name, msg)
		end
	end
end

function CMD.offline(uid)
	-- luadump(players)
	local p = players[uid]
	if p then
		local result = logic.leave_game(p)
		if result then
			players[uid] = nil
			p.send_msg = nil
			p.call_userdata = nil
			LOG_DEBUG("用户离开桌子:"..uid)
			api.send_to_all("game.LeaveTableNtf", {uid=uid})
		else
			LOG_DEBUG("用户离线:"..uid)
			p.online = 0
			api.send_to_all("game.UserOffline", {uid=uid})
		end
		return result
	else
		-- 如果玩家不在此桌子内，直接返回离开成功
		return true
	end
end

-- 检测玩家是否在房间中
function CMD.check_player(uid, agnode, agaddr)
	if players and players[uid] then
		luadump(players)
		players[uid].agaddr = agaddr
		players[uid].agnode = agnode
		return true
	end
end

-----------------------------------------------------------------------------------------

function api.send_to_all(name, msg)
	LOG_DEBUG("===============  send_to_all name ".. name)
	for uid,p in pairs(players) do
		p:send_msg(name, msg)
	end
end

function api.send_except(name, msg, except_uid)
	for uid,p in pairs(players) do
		if uid ~= except_uid then
			p:send_msg(name, msg)
		end
	end
end

function api.game_start()
	for uid,p in pairs(players) do
		pcall(skynet.send, redis, "lua", "execute", "set", "tableinfo->"..tostring(uid), nodename..":"..skynet.self())
	end
end

-- reason 1001表示解散，1002表示游戏完成了
function api.free_table(histroy, reason)
	-- luadump(players)
	for uid,p in pairs(players) do
		if p.online == 1 then
			p:send_msg("game.LeaveTableNtf", {uid=uid, result = reason or 1001})
			-- p:call_userdata("add_histroy", histroy)
			-- pcall(skynet.send, redis, "lua", "execute", "LPUSH", "tablelist->"..p.uid, info)
			p:call_userdata("leave_game")
		end
		histroy = histroy or {}
		-- LOG_DEBUG("============================histroy===========================")
		-- luadump(histroy)
		local ok, data = pcall(encode_data, histroy)
		if ok and data then
			local ok, len = pcall(skynet.call, redis, "lua", "execute", "RPUSH", "histroy->"..uid, data)
			if ok and len then
				LOG_DEBUG(uid.."历史记录长度:"..len)
				len = tonumber(len)
				if len and len > 50 then
					for i=51,len do
						pcall(skynet.send, redis, "lua", "execute", "LPOP", "histroy->"..uid)
					end
				end
			end
		end

		pcall(skynet.send, redis, "lua", "execute", "del", "tableinfo->"..tostring(uid))
	end
	if reason == 1001 and pay == 2 then
		local price = tonumber(config.price[2])
		if price then
			call_datamanager(creater, "add_gold", creater, price, 1003)
		end
		-- uid, gold, reason)
		-- p:call_userdata("add_gold", p.uid, price, 1003)
	end
	logic.free()
	for uid,p in pairs(players) do
		p.send_msg = nil
		p.call_userdata = nil
		players[uid] = nil
	end

	skynet.call(manager,"lua", "free", code)
	skynet.exit()
end

-----------------------------------------------------------------------------------------

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		-- LOG_DEBUG("需要执行:"..command)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
	skynet.fork(tick_tick)

	redis = skynet.uniqueservice("redispool")

	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
end)
