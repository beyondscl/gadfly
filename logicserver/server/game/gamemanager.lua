local skynet = require "skynet"
local cluster = require "skynet.cluster"

local game_conf = require "game_conf"
local nodename = skynet.getenv("nodename")

local tables = {}
local code_index = 1000
local CMD = {}

-- 100  已经在房间中了
-- 101  未知错误
-- 200  参数错误
-- 1000 游戏服务器链接不上
-- 1001 请再试一次
-- 1002 gameid错误
-- 1003 score参数错误
-- 1004 times参数错误
-- 1005 房间不存在
-- 1006 房间已满
-- 1007 创建房间失败
-- 1008 加入房间失败
-- 1009 房间不存在
-- 1010 钱不够
function CMD.create(gameid, pay, score, times, player)
	local conf = game_conf[gameid]
	-- luadump(conf)
	if not conf then return 1002 end
	if pay ~= 1 and pay ~= 2 then
		pay = 2
	end
	if pay == 2 then
		local price = tonumber(conf.price[2])
		if not price then return 1002 end
		local ok, result = pcall(cluster.call, player.datnode, player.dataddr, "sub_gold", player.uid, price, 1001)
		if not ok then
			return 1000
		end
		if not result then
			return 1010
		end
	end
	code_index = code_index + 1
	if code_index > 9999 then
		code_index = 1000
	end
	local a,b = math.modf(code_index/100)
	b=math.modf(b*100)
	if b < 10 then
		b = "0"..b
	end
	if a < 10 then
		a = "0"..a
	end
	local code = tostring(math.random(9))..tostring(b)..tostring(math.random(9))..tostring(a)
	code = tonumber(code)
	
	if tables[code] then
		return 1001
	end

	if not table.indexof(conf.score, score) then return 1003 end
	if not table.indexof(conf.times, times) then return 1004 end
-- price = {40,160}
	local t = skynet.newservice("table")
	tables[code] = t
	-- function CMD.init(conf, gameid, times, score, paytype, code)
	local ok, result = pcall(skynet.call, t, "lua", "init", conf, gameid, times, score, pay, code, player, skynet.self())
	if not ok then
		LOG_DEBUG(result);
		return 1007
	end
	if result then return result end

	return nodename, t
end

-- 1000 游戏服务器链接不上
-- 1001 请再试一次
-- 1002 gameid错误
-- 1003 score参数错误
-- 1004 times参数错误
-- 1005 房间不存在
-- 1006 房间已满
-- 1007 创建房间失败
-- 1008 加入房间失败
-- 1009 房间不存在
function CMD.join(code, player)
	local t = tables[code]
	if not t then
		return 1009
	end

	local ok, result = pcall(skynet.call, t, "lua", "join", player)
	if not ok then
		return 1007
	end
	
	if result then return result end

	return nodename, t
end

function CMD.free(code)
	tables[code] = nil
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
