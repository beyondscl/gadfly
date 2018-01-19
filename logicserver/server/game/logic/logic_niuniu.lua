local niuniu_deal = require "niuniu_deal"

local this = {}
local players

local played_times
local total_times
--local score
local rule_score
local code
local endtime
local owner
local gameid
local paytype
local config
local tinsert = table.insert
local tremove = table.remove
local tindexof = table.indexof
local seats
local hasstart
local master
local histroy
local BASE_SCORE = 1     -- 基础分

local game_status --游戏状态，0表示还在等人开始中,1表示准备开始阶段,2是发牌阶段,3抢庄阶段，4设置庄家阶段

--[[
gamestatus     last_time     desc
	1             2          gamestart
	101           0          游戏开始，还未发送startround
	2 			             游戏开始，已发送startround 还未洗牌 发牌
	3             3          发完4张牌，抢庄牛牛特有状态 等待抢庄
	4                        发完4张牌，此时已知庄家 set_master
	5             4          庄闲确定，闲家加倍阶段
	100                      show_rate阶段，给前段发送倍率结果
	6                        add_last_card 发最后一张牌
	7             4          confirm_cards  给前段发送askconfirmcards 询问牌型选择？
	8             3          showcard阶段
	9                        game_end一局结束,结算,给前段发送结果
	10            4          应该是客户端播放结算动画阶段(此阶段结束后会判断该进入101还是200)
	200                      游戏结束
]]

local next_status_time --切换到下个状态的时间

--需要替换的牌
--[[
	{uid = num,
	cards = {101,...}}
]]
local replaced_cards

--测试用 延长状态时间
local DUBUG_TIME = 0

------------------------------------
local send_to_all
local free_table
local api_game_start
------------------------------------

local static_cards = {
	101,102,103,104,105,106,107,108,109,110,111,112,113,	  --方
	201,202,203,204,205,206,207,208,209,210,211,212,213,	  --梅
	301,302,303,304,305,306,307,308,309,310,311,312,313,	  --红
	401,402,403,404,405,406,407,408,409,410,411,412,413,      --黑
}

local cards = {}

--牌型对应的倍率
local cardtype_2_rate = {
	[1] = 1,					-- 1-10 牛1-牛10
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,
	[9] = 9,
	[10] = 10,
	[11] = 12,					-- 顺子
	[14] = 13,					-- 同花
	[21] = 14,					-- 葫芦
	[31] = 16,					-- 小牛
	[41] = 18,					-- 花牛
	[51] = 20,					-- 炸弹
	[61] = 25,					-- 同花顺
}

local function shuffle()
	discards = {}
	cards = {}
	local tmp = {1,2,3,4,5,6,7,8,9,10,11,12,13,
				14,15,16,17,18,19,20,21,22,23,24,25,26,
				27,28,29,30,31,32,33,34,35,36,37,38,39,
				40,41,42,43,44,45,46,47,48,49,50,51,52}
	local index
	for i=52,1,-1 do
		index = tremove(tmp, math.random(i))
		tinsert(cards, static_cards[index])
	end
end

local function add_cards(count)
	local list, cardid
	for uid,p in pairs(players) do
		if p and p.ready == 1 and p.seatid and p.seatid > 0 then
			p.cards = p.cards or {}
			list = {}
			for i=1,count do
				--for gm
				if replaced_cards and uid == replaced_cards.uid and #replaced_cards.cards > 0 then
					cardid = tremove(replaced_cards.cards)
				else
					cardid = tremove(cards)
				end
				tinsert(list, cardid)
				tinsert(p.cards, cardid)
			end
			for u,v in pairs(players) do
				if u == uid then
					v:send_msg("game.AddCard", {uid=uid, seatid=p.seatid, count=count, cards=list})
				else
					v:send_msg("game.AddCard", {uid=uid, seatid=p.seatid, count=count})
				end
			end
		end
	end
	if replaced_cards and #replaced_cards.cards < 1 then
		replaced_cards = nil
	end
--	PRINT_T(players)
end

local function get_next_master()
	local i
	if not master or not players[master] then
		i = 0
	else
		i = players[master].seatid
	end
	local p
	for j=1,10 do
		i = i + 1
		p = seats[i]
		if p then break end
		if i > config.max_player then
			i = 1
		end
	end
	if not p then
		return 0
	end

	return p.uid
end

local function get_card_rate(cards)
	local card_type_t = niuniu_deal.doGetNiu(cards)
	-- LOG_DEBUG("card type:%d", card_type_t[1])
	-- if card_type_t[1] == 14 then
	-- 	luadump(cards)
	-- 	luadump(card_type_t)
	-- end
	return cardtype_2_rate[card_type_t[1]] or 1
end

local function game_stop()
	game_status = 200
	LOG_DEBUG("游戏结束了！！！")
	
	histroy.endtime = os.time()
	histroy.players = histroy.players or {}
	local info
	local infos = {}
	for uid,p in pairs(players) do
		if p.ready == 1 and p.seatid and p.seatid > 0 then
			info={tongsha=p.tongsha or 0, tongpei=p.tongpei or 0, niuniu=p.niuniu or 0,
			 wuniu=p.wuniu or 0, shengli=p.shengli or 0, score=p.score or 0, uid=p.uid, nickname=p.nickname}
			tinsert(histroy.players, info)
			tinsert(infos, info)
		end
	end

	send_to_all("game.GameEnd", {round=total_times, infos=infos})
	send_to_all("game.NiuNiuHistroy", {list = histroy.recording})

	free_table(histroy, 1002)
end

local function game_end()
	game_status = 9
	local mp = players[master]
	mp.shengli = mp.shengli or 0
	-- if not mp.cards then
	-- 	luadump(mp)
	-- end
	local mp_card_rate = get_card_rate(mp.cards)
--	local mp_card_rate = 1
	for uid,p in pairs(players) do
		if p.seatid and p.seatid > 0 and p.ready == 1 and p.uid ~= master then
			-- send_to_all("game.ShowCard", {uid = p.uid, seatid = p.seatid, cards = p.cards})
			p.rate = p.rate or 1
			--牌型倍率
			local p_card_rate = get_card_rate(p.cards)
		--	local p_card_rate = 1
			-- luadump(mp.cards)
			-- luadump(p.cards)
			-- LOG_DEBUG("===============================================")
		--	LOG_DEBUG("befroe p.add_score:%d,   mp.add_socre:%d", p.add_score, mp.add_score)
			if niuniu_deal.niuniuCompare(mp.cards,p.cards) then
				mp.add_score = mp.add_score + BASE_SCORE * p.rate * mp_card_rate
				p.add_score = p.add_score - BASE_SCORE * p.rate * mp_card_rate
				mp.shengli = mp.shengli + 1
			else
				mp.add_score = mp.add_score - BASE_SCORE * p.rate * p_card_rate
				p.add_score = p.add_score + BASE_SCORE * p.rate * p_card_rate
				p.shengli = p.shengli or 0
				p.shengli = p.shengli + 1
			end
		--	LOG_DEBUG("p.add_score:%d,   mp.add_socre:%d", p.add_score, mp.add_score)
		end
	end
	local count = 0
	local info = {}
	local cds = {}
	for uid,p in pairs(players) do
		if p.seatid and p.seatid > 0 and p.ready == 1 and p.add_score then
			count = count + 1
			p.score = p.score + p.add_score
			tinsert(info, p.uid)
			tinsert(info, p.add_score)
			tinsert(info, p.score)
			p.add_score = 0
			for i,cardid in ipairs(p.cards) do
				tinsert(cds, cardid)
			end
		end
	end
--	PRINT_T(players)
	send_to_all("game.GameResult", {master=master,count=count, infos = info, cards=cds})

	histroy.recording = histroy.recording or {}
	tinsert(histroy.recording, {master=master, count=count, round = played_times+1, infos=info, cards=cds})

	game_status = 10
	next_status_time = os.time() + 4 + DUBUG_TIME
	played_times = played_times + 1
end

local function show_cards()
	game_status = 8
	next_status_time = os.time() + 3 + DUBUG_TIME
	for uid,p in pairs(players) do
		if p.seatid and p.seatid > 0 and p.ready == 1 then
			p.add_score = 0
			send_to_all("game.ShowCard", {uid = p.uid, seatid = p.seatid, cards = p.cards})
		end
	end
end

local function confirm_cards()
	game_status = 7
	for uid,p in pairs(players) do
		p.confirm = nil
	end
	next_status_time = os.time() + 4 + DUBUG_TIME
	send_to_all("game.AskConfirmCards", {time = 4})
	-- 询问牌型选择
end

local function add_last_card()
	game_status = 6
	add_cards(1)
	confirm_cards()
end

local function show_rate()
	game_status = 100
	for uid,p in pairs(players) do
		if not p.rate and p.seatid and p.seatid > 0 then
			p.rate = 1
			send_to_all("game.SetRate", {rate=p.rate, uid=p.uid})
		end
	end

	add_last_card()
end

local function ask_rate()
	game_status = 5
	for uid,p in pairs(players) do
		p.rate = nil
	end
	next_status_time = os.time() + 4 + DUBUG_TIME
	send_to_all("game.AskRate", {time = 4, master = master})
end

local function set_master()
	game_status = 4

	LOG_DEBUG(master.."叫到了庄")
	send_to_all("game.SetMaster", {uid = master})

	ask_rate()
end

local function new_game()
	for uid,p in pairs(players) do
		if p.seatid and p.seatid > 0 and p.beready then
			p.ready = 1
		end
	end
	game_status = 101
	send_to_all("game.StartRound", {round = played_times + 1, total = total_times})
	game_status = 2
	shuffle()  --洗牌
	for uid,p in pairs(players) do
		if p.ready == 1 then
			p.cards = nil
		end
	end
	add_cards(4) --发4张牌
	if gametype == 1 then
		-- 抢庄牛牛
		game_status = 3
		for uid,p in pairs(players) do
			p.ask_master = nil
		end
		next_status_time = os.time() + 3 + DUBUG_TIME
		send_to_all("game.AskMaster", {time = 3})
	elseif gametype == 2 then
		-- 轮庄
		-- game_status = 4
		master = get_next_master()
		set_master()
	else
		-- 固定庄
		game_status = 4
		set_master()
	end
end

local function game_start()
	if hasstart then return end
	hasstart = true
	game_status = 1
	played_times = 0
	next_status_time = os.time() + 2
	api_game_start()
	send_to_all("game.GameStart", {})
end

local function check_start()
	if hasstart then return end
	LOG_DEBUG("检查游戏是否能开始")
	--准备的人
	local readyCount = 0
	--坐下的人
	local seat_count = 0
	for uid,p in pairs(players) do
		if p.seatid and p.seatid > 0 then
			if p.ready == 1 then
				readyCount = readyCount + 1
			end
			seat_count = seat_count + 1
		end
	end
	LOG_DEBUG("在坐的玩家个数:%d, 准备的玩家个数:%d,", seat_count, readyCount)
	if readyCount >= 2 and readyCount == seat_count then
		game_start()
	end
end

local function random_master()
	local total = {}
	local asked = {}
	for uid,p in pairs(players) do
		if p.ask_master == 1 then
			LOG_DEBUG(p.uid.."是庄")
			tinsert(asked, uid)
		end
		if p.seatid and p.seatid > 0 and p.ready then
			tinsert(total, uid)
		end
	end

--	luadump(players)
	if #asked > 0 then
		master = asked[math.random(#asked)]
	else
		master = total[math.random(#total)]
	end

	set_master()
end

--GM:更换手牌
local function gm_change_cards(p, msg)
	if #msg.cards ~= 5 then
		LOG_WARNING("illegal param cards num:%d", #msg.cards)
		return
	end

	if replaced_cards then
		replaced_cards = nil
	end

	replaced_cards = {
		uid = msg.uid,
		cards = {},
	}

	for i=1,#msg.cards do
		tinsert(replaced_cards.cards, msg.cards[i])
	end
end

--简单的测试服务端接口函数
local function test_interface( ... )
	-- LOG_DEBUG("=======================  test interface  ======================")
	-- local t = {107,103,111,113,313}
	-- luadump(niuniu_deal.isTonghua(t))
end

function this.free()
	for seatid,v in pairs(seats) do
		seats[seatid] = nil
	end

	free_table = nil
	send_to_all = nil
	histroy = nil
	static_cards = nil
	cards = nil
	replaced_cards = nil

	for uid,p in pairs(players) do
		for k,v in pairs(p) do
			p[k] = nil
		end
	end
end

function this.update()
	if not hasstart and endtime then
		if os.time() >= endtime then
			free_table(histroy, 1001)
			return
		end
	end

	if hasstart and next_status_time and next_status_time > 0 then
		if game_status == 1 then
			-- 2秒后就开始了
			if os.time() >= next_status_time then
				new_game()
			end
		elseif game_status == 3 then
			-- 抢庄阶段
			if os.time() >= next_status_time then
				random_master()
			end
		elseif game_status == 5 then
			if os.time() >= next_status_time then
				-- add_last_card()
				show_rate()
			end
		elseif game_status == 7 then
			if os.time() >= next_status_time then
				show_cards()
			end
		elseif game_status == 8 then
			if os.time() >= next_status_time then
				game_end()
			end
		elseif game_status == 10 then
			if os.time() >= next_status_time then
				if played_times >= total_times then
					game_stop()					
				else
					new_game()
				end
				-- new_game()
			end
		end
	end
end

function this.join(p)
--	local reconn = false
	-- for uid, v in pairs(players) do
	-- 	if uid == p.uid then
	-- 		p.seatid = v.seatid
	-- 		p.ready = v.ready
	-- 		p.score = v.score
	-- 		-- p.agaddr = v.agaddr
	-- 		-- p.datadrr = v.datadrr
	-- 		p.add_score = v.add_score
	-- 		p.rate = v.rate
	-- 		p.cards = v.cards
	-- 		p.shengli = v.shengli or 0
	-- 		players[uid] = p
	-- 		reconn = true
	-- 		break
	-- 	end
	-- end
	p.seatid = 0
	p.ready = 0
	p.score = 0
	return true
end

function this.dispatch(p, name, msg)
	-- LOG_DEBUG(p.uid..":"..name)
	if name == "SitdownNtf" then
		-- msg.seatid
		local seatid = tonumber(msg.seatid)
		if seatid and not seats[seatid] and seatid > 0 and seatid <= config.max_player then
			if p.seatid and p.seatid > 0 and hasstart then
				-- 已经坐下，且已经开局不能换座位
				LOG_DEBUG("已经坐下，且已经开局不能换座位:"..p.uid)
				return
			end
			if p.seatid then
				seats[p.seatid] = nil
			elseif paytype == 1 then
				-- 需要扣费
				local price = tonumber(config.price[1])

				if not price then
					return "game.SitdownNtf", {uid=p.uid, seatid=-1}
				end

				local ok, result = pcall(p:call_userdata("sub_gold", p.uid, price, 1001))
				if not ok or not result then
					return "game.SitdownNtf", {uid=p.uid, seatid=-1}
				end
				p.hascost = true
			end
			seats[seatid] = p
			p.seatid = seatid
			p.ready = 0
			if not owner then
				owner = p.uid
			end

			if hasstart then
				p.beready = true
				-- p.ready = 1 --游戏开始之后，玩家坐下就准备了
			end

			send_to_all("game.SitdownNtf", {uid=p.uid, seatid=seatid, nickname=p.nickname, headimg="null"})
		end
	elseif name == "GetReadyNtf" then
		if hasstart then return end --游戏开始之后，玩家坐下就准备了
		if not p.ready or p.ready == 0 then
			if p.seatid and p.seatid > 0 then
				p.ready = 1
				send_to_all("game.GetReadyNtf", {uid=p.uid, seatid=p.seatid})
				check_start()
			end
		end
	elseif name == "LeaveTableNtf" then
		LOG_DEBUG("请求离开")
		if this.leave_game(p) then
			LOG_DEBUG("离开成功")
			players[p.uid] = nil
			p:call_userdata("leave_game")
			p.call_userdata = nil
			p.send_msg = nil
			send_to_all("game.LeaveTableNtf", {uid=p.uid})

			return "game.LeaveTableNtf", {uid=p.uid}
		end
		return "game.LeaveTableNtf", {uid=p.uid, result=1000}
	elseif name == "GetMaster" then
		if game_status == 3 and hasstart and not p.ask_master and p.seatid and p.seatid > 0 and p.ready == 1 then
			if msg.result > 1 then msg.result = 0 end
			p.ask_master = msg.result
			LOG_DEBUG(p.uid.."叫庄:"..p.ask_master)
			send_to_all("game.GetMaster", {result=p.ask_master,uid=p.uid})
			local done = true
			for uid,p in pairs(players) do
				if p.seatid and p.seatid > 0 and p.ready == 1 then
					if not p.ask_master then
						done = false
						break
					end
				end
			end
			if done then
				next_status_time = 0
				random_master()
			end
		end
	elseif name == "SetRate" then
		if game_status == 5 and hasstart and not p.rate and p.seatid and p.seatid > 0 and p.ready == 1 then
			if p.uid == master then return end
			if config.rate[rule_score] and tindexof(config.rate[rule_score], msg.rate) then
				p.rate = msg.rate
				send_to_all("game.SetRate", {rate = p.rate, uid = p.uid})

				local done = true
				for uid,p in pairs(players) do
					if p.seatid and p.seatid > 0 and p.ready == 1 then
						if not p.rate then
							done = false
							break
						end
					end
				end

				if done then
					next_status_time = 0
					-- add_last_card()
					show_rate()
				end
			end
		end
	elseif name == "ConfirmCards" then
		if game_status == 7 and hasstart and not p.confirm and p.seatid and p.seatid > 0 and p.ready == 1 then
			p.confirm = true
			send_to_all("game.ConfirmCards", {uid=p.uid})
			local done = true
			for uid,p in pairs(players) do
				if p.seatid and p.seatid > 0 and p.ready == 1 then
					if not p.confirm then
						done = false
						break
					end
				end
			end

			if done then
				next_status_time = 0
				show_cards()
			end
		end
	elseif name == "GmChangeCards" then
		gm_change_cards(p, msg)
		test_interface()
	end
end

-- 发送房间信息
function this.send_tableinfo(p)
	local msg = {}
	local list = {}
	local cur_status = game_status
	for uid,v in pairs(players) do
		tinsert(list, { uid = v.uid, 
						nickname=v.nickname,
						seatid=v.seatid or 0,
						ready=v.ready or 0,
						online=v.online or 1,
						score=v.score or 0,
						sex = v.sex or 1})
	end
	msg.owner = owner
	msg.endtime = hasstart and 0 or endtime
	msg.gameid = gameid
	msg.times = total_times
	msg.playedtimes = played_times
	msg.score = rule_score
	msg.paytype = paytype
	msg.code = code
	msg.players = list
 --   luadump(msg)
	p:send_msg("game.TableInfo", msg)
end

function this.resume(p)
	-- 恢复游戏
	-- 状态
	-- 当前状态剩余时间
	-- 玩家的牌
	local msg = {}
	local info = {}
	local cur_status = game_status
	
	for uid, v in pairs(players) do
		local count = 0
		if v.cards then 
			count = #v.cards
		end
		if p.uid == uid or cur_status == 8 or cur_status == 9 or cur_status == 10 then
			tinsert(info, {uid = uid, cards = v.cards or {}, count = count})
		else	
			tinsert(info, {uid = uid, cards = {}, count = count})
		end
	end

	msg.info = info
	msg.status = cur_status
	msg.time = (next_status_time and next_status_time - os.time() > 0) and next_status_time - os.time() or 0 
	p:send_msg("game.NiuNiuResume", msg)
end

-- 尝试离开游戏，如果能离开，返回true，并且调用该函数的地方继续处理离开逻辑
function this.leave_game(p)
	if not hasstart or not p.ready or p.ready == 0 then
		if p.seatid and p.seatid ~= 0 then
			if p.hascost and paytype == 1 then
				p.hascost = nil
				local price = tonumber(config.price[1]) or 0
				p:call_userdata("add_gold", p.uid, price, 1003)
			end
			seats[p.seatid] = nil
		end
		return true
	end
end

function this.init(ps, api, m_conf, m_times, m_score, m_pay, m_code, m_gameid, uid)
	seats = {}
	players = ps
	config = m_conf
	played_times = 0
	total_times = m_times
	rule_score = m_score
	code = m_code
	endtime = os.time() + m_conf.wait_time
	owner = 0
	gameid = m_gameid
	paytype = m_pay
	hasstart = false
	gametype = config.init_params
	game_status = 0

	send_to_all = api.send_to_all
	free_table = api.free_table
	api_game_start = api.game_start

	if gametype == 3 then
		-- 固定庄是房间创建者
		master = uid
	end
	histroy = {}
	histroy.owner = uid
	histroy.time = os.time()
	histroy.code = code
	histroy.times = total_times
	histroy.gameid = gameid
--	luadump(histroy)
end

return this