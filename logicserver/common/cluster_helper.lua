local skynet = require "skynet"
local datacenter = require "skynet.datacenter"
local cluster

local function read_file(url)
	-- body
	local f = io.open(url)
	if f then
		local data = f:read("*a")
		f:close()
		return data
	end
	LOG_INFO("open file:%s fail. ", url or "")
	return false
end

function load_servermap()
	LOG_INFO("load_servermap...")
	local config_name = skynet.getenv "cluster"

	-- local f = io.open(config_name)
	-- if not f then 
	-- 	LOG_INFO("load_servermap fail, open file:%s fail. ", config_name or "")
	-- 	return 
	-- end

	-- local source = f:read "*a"
	-- f:close()
	local source = read_file(config_name)
	if source == false then return end

	local tmp = {}
	local server_list = {}

	local func = load(source, "@"..config_name, "t", tmp)
	if func then
		func()
	else
		LOG_INFO("load_servermap fail, load file fail. ")
		return 
	end

	local stype
	for name,address in pairs(tmp) do
		stype = string.gsub(name, "%d+", "")
		server_list[stype] = server_list[stype] or {}
		table.insert(server_list[stype], name)
	end

	datacenter.set("server_list", tmp)

	for k,v in pairs(server_list) do
		datacenter.set(k,v)
	end
end

function get_server_by_type(stype)
	local v = datacenter.get(stype)
	if not v then 
		LOG_ERROR("server type:%s no record in datacenter", stype)
	end
	return v or {}
end

-- local ntfs_map = {}
local ntf_list

-- 通过uid散列用户获得消息推送服务器
function get_ntf_node_addr_by_uid(uid)
	uid = tonumber(uid)
	if not uid then return end
	if not ntf_list then
		ntf_list = get_server_by_type("notify")
	end
	if not ntf_list or #ntf_list < 1 then
		LOG_DEBUG("消息推送服务没有开!!!!")
		return
	end

	local ntfs_cnt = #ntf_list
	local name = ntf_list[uid%ntfs_cnt+1]

	if name then
		cluster = cluster or require "cluster"
		local ok,addr = pcall(cluster.query, name, "notify")
		if ok and addr then
			return name, addr
		end
	end
end

local dbs_map = {}
local dbs_list
function get_dbs_by_uid(uid, mcluster)
	uid = tonumber(uid)
	if not uid then return end

	if not dbs_list then
		dbs_list = get_server_by_type("dbs")
	end
	if not dbs_list or #dbs_list <= 0 then
		LOG_ERROR("!!!!!!!!!!!!!!======no dbs ")
		return
	end

	local dbs_cnt = #dbs_list
	local name = dbs_list[uid%dbs_cnt+1]
	if not name then return false end

	local db = dbs_map[name]
	local ok
	if not db then 
		cluster = cluster or mcluster or require "cluster"
		ok,db = pcall(cluster.snax, name, "dbmgr")
		if ok then
			dbs_map[name] = db
		else
			db = nil
		end
	end
	return db
end

function get_all_dbs()
	if not dbs_list then
		dbs_list = get_server_by_type("dbs")
	end
	if not dbs_list or #dbs_list <= 0 then
		LOG_ERROR("!!!!!!!!!!!!!!======no dbs ")
		return
	end

	cluster = cluster or require "cluster"
	local db = dbs_map[i]
	local ok
	for i = 1, #dbs_list do
		db = dbs_map[i]
		if not db then 
			ok,db = pcall(cluster.snax, name, "dbmgr")
			if ok then
				dbs_map[i] = db
			else
				db = nil
			end
		end
	end
	
	return dbs_map
end

function get_dbs_name_uid(uid)
	if not dbs_list then
		dbs_list = get_server_by_type("dbs")
	end
	if not dbs_list or #dbs_list <= 0 then
		LOG_ERROR("!!!!!!!!!!!!!!======no dbs ")
		return
	end

	uid = tonumber(uid)
	if not uid then return end
	local dbs_cnt = #dbs_list
	return dbs_list[uid%dbs_cnt+1]
end


local gate_map = {}
function get_gate_by_name(name)
	local gt = gate_map[name]
	if not gt then
		cluster = cluster or require "cluster"
		local ok,id = pcall(cluster.query, name, "gate")

		if ok and id then
			gt = cluster.proxy(name, id)
			gate_map[name] = gt
		end
	end

	return gt
end

local server_map = {}
function get_server_by_node_name(node, name)
	local addr = node..name
	local s = server_map[addr]
	if not s then
		cluster = cluster or require "cluster"
		local ok,id = pcall(cluster.query, node, name)
		if ok and id then
			s = cluster.proxy(node, id)
			server_map[addr] = s
		end
	end
	return s
end

--
function call_dbs(uid, method, ...)
	local db = get_dbs_by_uid(uid)

	if not db then return false end

	local f = db.req[method]
	if not f then return false end

	local params = table.pack(pcall(f, ...))
	local ok = table.remove(params, 1)

	if ok then
		return table.unpack(params)
	end
	return false
end

function call_dbs_with_cluster(uid, method, cluster, ...)
	local db = get_dbs_by_uid(uid, cluster)

	if not db then return false end

	local f = db.req[method]
	if not f then return false end

	local params = table.pack(pcall(f, ...))
	local ok = table.remove(params, 1)

	if ok then
		return table.unpack(params)
	end
	return false
end

function call_all_dbs(funcname, ...)
	-- body
	if not dbs_list then
		dbs_list = get_server_by_type("dbs")
	end
	if not dbs_list or #dbs_list <= 0 then
		LOG_ERROR("!!!!!!!!!!!!!!======no dbs ")
		return
	end
	cluster = cluster or require "cluster"

	local db,ok,f
	for _,name in pairs(dbs_list) do
		db = dbs_map[name]
		if not db then
			ok, db = pcall(cluster.snax, name, "dbmgr")
		end
		if db then
			f = db.req[funcname]
			if f then
				f(...)
			end
		end
	end
end

function call_all_gate(funcname, ...)
	local list = get_server_by_type("gate")
	cluster = cluster or require "cluster"
	local ok, addr, ret, result = _,_,_,{}
	for _,name in pairs(list) do
		ok,addr = pcall(cluster.query, name, "gate")
		if ok and addr then
			ret = cluster.call(name, addr, funcname, ...)
			if ret then
				result[name] = ret
			end
		end
	end
	return result
end

local game_server_set 		-- 存储所有游戏服务器的节点名称，用于游戏广播
--local match_server_set	-- 存储所有竞赛服务器的节点名称
local game_proxy_set = {} 	-- 存储游戏服务器的代理

-- 将各个节点的名字缓存到servers_set_nodename中
local function init_server_set()
	if not game_server_set then
		game_server_set = {}
		local nodelist = get_server_by_type("game")
		if nodelist then
			for _, name in pairs(nodelist) do
				table.insert(game_server_set, name)
			end
		else
			game_server_set = nil
		end
	end
end

local aggregate_server_set 		-- 存储所有游戏服务器的节点名称，用于游戏广播
local aggregate_proxy_set = {} 	-- 存储游戏服务器的代理

-- 将各个节点的名字缓存到servers_set_nodename中
local function init_aggregate_server_set()
	if not aggregate_server_set then
		aggregate_server_set = {}
		local nodelist = get_server_by_type("aggregate")
		if nodelist then
			for _, name in pairs(nodelist) do
				table.insert(aggregate_server_set, name)
			end
		else
			aggregate_server_set = nil
		end
	end
end



-- 通过节点索引获取节点的代理
function get_gs_by_index(index)
	if index then
		local nodename = "game" .. tostring(index)
		local gs = game_proxy_set[nodename]
		if not gs then
			cluster = cluster or require "cluster"
			local done, id = pcall(cluster.query, nodename, "game")
			if done and id then
				gs = cluster.proxy(nodename, id)
				game_proxy_set[nodename] = gs
			end
		end
		return gs
	end
	return nil
end

-- 获取一个空桌子并尝试加入进入
-- 0    成功获取
-- 1000 参数错误
-- 1001 内部错误，room_conf里面配置了不存在的matchCtrl
-- 1002 内部错误，连接管理服务失败
-- 1003 玩家不在比赛中，需要从比赛入口进入
-- 1004 比赛时间未到
-- 1005 可用次数不够
-- 1006 内部错误，redis读取或者写入失败
-- 1007 内部错误，room配置的ticket错误
-- 1008 门票不够
-- 1009 已经在比赛中了
-- 1010 房间不够
-- 1011 用户信息请求不到
-- 1020 秘境进入途径错误

function get_table_join(roomid, node, addr, uid, clientid, gold, isrobot, session, srcroomid)
	init_server_set()
	local gameType = "game"
	if not game_server_set then return 1010 end

	local proxy, ok, id, result, status
	cluster = cluster or (require "cluster")

	for _, name in pairs(game_server_set) do
		if name then
			proxy = game_proxy_set[name]
			if not proxy then
				ok, id = pcall(cluster.query, name, gameType)
				if ok and id then
					proxy = cluster.proxy(name, id)
					game_proxy_set[name] = proxy
				end
			end

			if proxy then
				ok, result, status = pcall(skynet.call, proxy, "lua", "quick_join", node, addr, uid, roomid, isrobot, session, srcroomid)
				if ok then
					if result == 0 then
						return proxy, 0, status
					else
						return nil, result, status
					end
				end
			end
		end
	end
	return nil, tonumber(result), status
end

-- 以下针对发发发
-- 2000 服务器已经关闭
-- 2001 获取用户数据失败
-- 2    鱼币不够
-- 2003 炮台倍数不够
-- 2004 roomtype配置错误
-- 2005 没有找到相应的服务
-- 2006 manager调用失败
-- 2007 没有找到配置
-- 2008 系统亏损超过阈值
-- 2009 玩家已经在比赛中
-- 2010 获取桌子失败
-- 2011 用户信息获取失败
-- 2012 加入桌子失败
-- 2013 时间未到

function aggregate_get_table_join(roomid, node, addr, uid)
	init_aggregate_server_set()
	local gameType = "aggregate"
	if not aggregate_server_set then return 1010 end

	local proxy, ok, id, result
	cluster = cluster or (require "cluster")
	for _, name in pairs(aggregate_server_set) do
		if name then
			proxy = aggregate_proxy_set[name]
			if not proxy then
				ok, id = pcall(cluster.query, name, gameType)
				if ok and id then
					proxy = cluster.proxy(name, id)
					aggregate_proxy_set[name] = proxy
				end
			end

			if proxy then
				ok, result = pcall(skynet.call, proxy, "lua", "quick_join", node, addr, uid, roomid)
				if ok then
					if result == 0 then
						return proxy, 0
					else
						return nil, result
					end
				end
			end
		end
	end
	return nil, tonumber(result)
end

-- 1599 不允许退出排队
-- 1600 成功退出
-- 1601 用户没有在排队
-- 1602 退出参数错误
-- 1603 matchCtrl错误
-- 1604 没有找到相应游戏服
-- 放弃八人快速赛的排队
function giveup_match_eight_queue(uid, roomid)
	init_server_set()
	local gameType = "game"
	if not game_server_set then return 1010 end

	local proxy, ok, id, result
	cluster = cluster or (require "cluster")

	for _, name in pairs(game_server_set) do
		if name then
			proxy = game_proxy_set[name]
			if not proxy then
				ok, id = pcall(cluster.query, name, gameType)
				if ok and id then
					proxy = cluster.proxy(name, id)
					game_proxy_set[name] = proxy
				end
			end

			if proxy then
				ok, result = pcall(skynet.call, proxy, "lua", "giveup_match_queue", uid, roomid)
				if ok then
					return proxy, result
				end
			end
		end
	end
	return nil, tonumber(result) 
end

--给所有的GS根服务发送消息
function call_all_gs(funcname, ...)
	-- body
	init_server_set()
	local gs, done, id
	if game_server_set then
		for _,name in pairs(game_server_set) do
			gs = game_proxy_set[name]
			if not gs then
				cluster = cluster or (require "cluster")
				done, id = pcall(cluster.query, name, "game")
				if done and id then
					gs = cluster.proxy(name, id)
					game_proxy_set[name] = gs
				end
			end

			if gs then
				done, id = pcall(skynet.call, gs, "lua", funcname, ...)
			end
		end
	end

	init_aggregate_server_set()
	if aggregate_server_set then
		
		for _,name in pairs(aggregate_server_set) do
			gs = aggregate_proxy_set[name]
			if not gs then
				cluster = cluster or (require "cluster")
				done, id = pcall(cluster.query, name, "aggregate")
				if done and id then
					gs = cluster.proxy(name, id)
					aggregate_proxy_set[name] = gs
				end
			end

			if gs then
				done, id = pcall(skynet.call, gs, "lua", funcname, ...)
			end
		end
	end
end

-- 广播给所有在线客户端消息，一个不会落下，但是会有延迟
function notify_all_client(name, msg, time)
	if not ntf_list then
		ntf_list = get_server_by_type("notify")
	end

	if not ntf_list or #ntf_list < 1 then
		LOG_ERROR("消息推送服务没有开!!!!!!!!!!!!!")
		return
	end
	local server
	cluster = cluster or require "cluster"
	for _,nodename in pairs(ntf_list) do
		local ok,addr = pcall(cluster.query, nodename, "notify")
		if ok and addr then
			pcall(cluster.call, nodename, addr, "dispatch", name, msg, time)
		end
	end
end

-- 一些不重要的post消息上报推送method=post/get notret=是否需要返回值 times尝试次数，默认1次
function notify_report(method, url, fields, notret, times)
	-- 废弃不用
-- 	times = times or 1
-- 	if not ntf_list then
-- 		ntf_list = get_server_by_type("notify")
-- 	end

-- 	if not ntf_list or #ntf_list < 1 then
-- 		LOG_ERROR("消息推送服务没有开!!!!!!!!!!!!!")
-- 		return
-- 	end
-- 	local server
-- 	cluster = cluster or require "cluster"

-- 	local nodename,ok,addr,ret

-- 	-- 随机到其中一个节点做处理，以后如果要改 改就是了
-- 	for i=1,times do
-- 		nodename = ntf_list[math.random(1, #ntf_list)]
-- 		ok,addr = pcall(cluster.query, nodename, "notify")
-- 		if ok and addr then
-- 			ok, ret = pcall(cluster.call, nodename, addr, method, url, fields, notret)
-- 			if ok and not notret and ret then
-- 				return ret
-- 			end
-- 		end
-- 	end
end

function login_from_ntfs(uid, node, addr)
	local snode, saddr = get_ntf_node_addr_by_uid(uid)
	if snode and saddr then
		cluster = cluster or require "cluster"
		pcall(cluster.call, snode, saddr, "user_online", uid, node, addr)
	end
end

function logout_from_ntfs(uid)
	local node, addr = get_ntf_node_addr_by_uid(uid)
	if node and addr then
		cluster = cluster or require "cluster"
		pcall(cluster.call, node, addr, "user_offline", uid, node, addr)
	end
end

function call_ntfs(uid, func, ...)
	local node, addr = get_ntf_node_addr_by_uid(uid)
	if node and addr then
		cluster = cluster or require "cluster"

		local params = table.pack(pcall(cluster.call, node, addr, func, ...))
		local ok = table.remove(params, 1)
		if ok then
			return table.unpack(params)
		end
	end
	return false
end

local robot_map = {}
local robot_index = 0
function get_robot_by_game_type(gametype, roomid)
	-- body
	local list = get_server_by_type("robot")
	if list and #list > 0 then
		for i=1, #list do
			robot_index = robot_index + 1
			if robot_index < 1 or robot_index  > #list then robot_index = 1 end
			local name = list[robot_index]
			if name then
				local fd = robot_map[name]
				if not fd then
					cluster = cluster or require "cluster"
					local done, id = pcall(cluster.query, name, "robot")
					if done and id then
						fd = cluster.proxy(name, id)
						robot_map[name] = fd
					end
				end
				if fd then
					--{node = node, addr = addr, uid = uid, isrobot = true}这是result的值
					local ok, result = pcall(skynet.call, fd, "lua", "get", gametype, roomid)
					if ok and result then
						result.robot_index = robot_index
						return result
					end
				end
			end
		end
	end
end

-- 释放机器人，将机器人还给机器人池
function back_robot_to_pool(robot)
	local list = get_server_by_type("robot")
	if list and #list > 0 then
		if not robot.robot_index then return end
		local robot_index = robot.robot_index
		if robot_index < 1 or robot_index  > #list then return end			
		local name = list[robot_index]
		if name then
			local fd = robot_map[name]
			if not fd then
				cluster = cluster or require "cluster"
				local done, id = pcall(cluster.query, name, "robot")
				if done and id then
					fd = cluster.proxy(name, id)
					robot_map[name] = fd
				end
			end
			if fd then
				--{node = node, addr = addr, uid = uid, isrobot = true}这是result的值
				local ok, result = pcall(skynet.call, fd, "lua", "free", robot)
				if ok and result then
					return result
				end
			end
		end
	end
end



-- wjx,操作日志服务器,先注释掉
function send_data_by_type(uid, datatype, id)
	-- local cluster = require "cluster"
	-- local done, fd = pcall(cluster.query, "logcenter", "datacollection")
	-- if done and fd then
	-- 	local ok, result = pcall(cluster.call, "logcenter", fd, "send_data", uid, datatype, id)
	-- 	if ok and result then
	-- 		return result
	-- 	else
	-- 		return 0
	-- 	end
	-- end
end

-- wjx,操作日志服务器，先注释掉
function get_data_by_type(starttime, endtime, datatype)
	-- local cluster = require "cluster"
	-- local done, fd = pcall(cluster.query, "logcenter", "datacollection")
	-- if done and fd then
	-- 	local ok, result = pcall(cluster.call, "logcenter", fd, "get_data", starttime, endtime, datatype)
	-- 	if ok and result then
	-- 		return result
	-- 	else
	-- 		return 0
	-- 	end
	-- end
end
