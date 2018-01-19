--
-- Created by IntelliJ IDEA.
-- User: 冷廷学
-- time: 2017/11/22
-- Time: 10:39
-- To change this template use File | Settings | File Templates.
--
--注意user_cards和used_cards不要使用错了
local nbUtil = require "fight_landlord_nb_util"
local cardsHelp = require "play_cards_helper"

local this = {}

--房间信息
local seats = {} --座位,数组,[1,4] -> [p...]，前台也需要在[1,4]
local leave_seats = {} --离开用户，当前牌局结束清除该用户
local owner --房主
local endtime --结束时间
local gameid --gameid
local total_times --游戏最多次数
local played_times = 0 --当前游戏局数
local rule_score
local score
local paytype --支付方式
local code

local histroy --历史记录
local players --所有用户,不需要手动维护
local config --启动配置
local init_params --启动配置参数
local game_status --游戏状态 ，0未开始，1开始，2叫分，2.3显示地主牌，3出牌，4当前牌局结束,8总牌局结束
local next_status_time --下一个状态执行时间
local cards --洗牌后的牌

local user_cards --用户初始牌,数组,注意长度为6
local used_cards = {} --已出的所有牌
local dipai --八张底牌

local first_master_card --第一次的明牌id,第二次由上次地主开始
local master --抢分后设置的地主：结束之后不要立即清除，下局由他开始叫分
local pre_play_user --上一次出牌人

local rate_pre_player --上一次叫分人
local rate_max = 0 --最大叫分
local rate_max_player --最大叫分人
local rate_count = 0 --叫分次数

local per_gold = 1 --暂定每一局1

local users_score = {} --记录用户每局输赢信息

--时间间隔
local time_ask_rate = 20
local time_show_master_cards = 8
local time_paly_card = 20
local time_game_end = 10
local time_game_stop = 10


------------------------------------
local tinsert = table.insert
local tremove = table.remove
local tindexof = table.indexof
local tconcat = table.concat
------------------------------------
local send_to_all
local free_table
------------------------------------

-- 初始化位置,数组
local function initSeats()
    for i = 1, 4 do
        seats[i] = 0
    end
end

--检查座位是否已满;true ->未满
local function checkSeatsFull()
    local c = 0
    for k, v in pairs(players) do
        c = c + 1
    end
    return c < 4 or false
end

--检查是否可以开始游戏;ture -> 可以开始
local function checkAllReady()
    local ps_count = 0
    for uid, p in pairs(players) do
        if p.ready == 0 or not p.ready then
            return false
        end
        ps_count = ps_count + 1
    end
    return ps_count == 4 or false
end

--获取下一次叫的分
local function getScore(score)
    local s = {}
    for i = 1, 3 do
        if score < i then
            table.insert(s, i)
        end
    end
    return s
end


--获取叫分人
local function getUserRate()
    local asktime = time_ask_rate
    if not rate_pre_player then
        --注意第一把游戏这时候master还没有值
        if not master then
            local seatid = first_master_card % 4 + 1
            local p = seats[seatid]
            rate_pre_player = p
            send_to_all("game.AskRate", { time = asktime, seatid = p.seatid, opt = getScore(0) })
        else
            rate_pre_player = master
            send_to_all("game.AskRate", { time = asktime, seatid = master.seatid, opt = getScore(0) })
        end
    else
        local p = seats[rate_pre_player.seatid % 4 + 1]
        rate_pre_player = p
        send_to_all("game.AskRate", { time = asktime, seatid = p.seatid, opt = getScore(rate_max) })
    end
    next_status_time = os.time() + asktime
end

--设置地主
local function set_master(p, score)
    local asktime = 20
    master = p
    send_to_all("game.SetMaster", { uid = p.uid, score = score })
    send_to_all("game.ShowCard", { uid = p.uid, seatid = p.seatid, cards = user_cards[5] })
    send_to_all("game.AddCard", { uid = p.uid, seatid = p.seatid, count = 8, cards = user_cards[5] })
    for i = 1, #user_cards[5] do
        table.insert(user_cards[p.seatid], user_cards[5][i]) --地主牌给玩家
    end
    game_status = 2.3
    next_status_time = os.time() + 5
end

local function first_ask_play()
    local p, asktime = master, time_paly_card
    send_to_all("game.AskPlayCard", { seatid = p.seatid, time = asktime, cardtype = 0, cards = {}, avatarCards = {} })
    game_status = 3
    next_status_time = os.time() + asktime
end

--设置赔率
local function setUserRate(p, msg)
    if msg.rate > rate_max then
        rate_max = msg.rate
        rate_max_player = p
    end
    rate_count = rate_count + 1
    send_to_all("game.SetRate", { uid = p.uid, rate = msg.rate })
    if msg.rate == 3 then
        set_master(p, msg.rate)
    elseif rate_count == 4 then
        rate_max_player = rate_max_player or rate_pre_player
        set_master(rate_max_player, rate_max)
    else
        getUserRate()
    end
end

--------------------------------------
math.randomseed(os.time());

--注意牌值
--A -> *14
--2 -> *16
--小王 -> 521
--大王 -> 522
local static_cards = {
    114, 116, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113,
    214, 216, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213,
    314, 316, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313,
    414, 416, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413,
    521, 522,
    114, 116, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113,
    214, 216, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213,
    314, 316, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313,
    414, 416, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413,
    521, 522
}

-- 洗牌
local function shuffle()
    cards = {}
    local tmp = {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
        27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
        40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52,
        53, 54, 54,
        55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67,
        68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
        81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93,
        94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106,
        107, 108
    }
    local index
    for i = 108, 1, -1 do
        --测试发牌
        --        index = tremove(tmp, math.random(i))
        index = tremove(tmp, 1)
        tinsert(cards, static_cards[index])
    end
end

--发牌
local function add_cards()
    shuffle()
    --获取第一次的明牌
    if not master then
        first_master_card = math.random(100)
    end
    local mingCard
    user_cards = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {}
    }
    for j = 1, 100, 1 do
        local index = j % 4 + 1
        local t = user_cards[index]
        table.insert(t, cards[j])
        if first_master_card == j then
            mingCard = cards[j]
            user_cards[6] = { first_master_card, mingCard }
        end
    end
    for uid, p in pairs(players) do
        for u, v in pairs(players) do
            if u == uid then
                v:send_msg("game.AddCard", { uid = uid, seatid = p.seatid, count = 25, cards = user_cards[v.seatid] })
            else
                v:send_msg("game.AddCard", { uid = uid, seatid = p.seatid, count = 25 })
            end
        end
    end

    --    --第一个叫分人,可以考虑不要
    --    if not master then
    --        local seatid = first_master_card % 4 + 1
    --        local tMaster = seats[seatid]
    --        send_to_all("game.ShowCard", { uid = tMaster.uid, seatid = seatid, cards = user_cards[6] })
    --    end

    --底牌赋值
    dipai = user_cards[5]
    for i = 101, 108, 1 do
        table.insert(dipai, cards[i])
    end
end

--获取用户总得分
local function get_user_scores(uid)
    local t = { cur_socre = 0, score = 0, bomb_count = 0, remain_cards = {} }
    if not users_score or #users_score == 0 then
        return t
    end
    local uid_scors = users_score[#users_score].uid_scores
    for m, n in pairs(uid_scors) do
        if uid == n.uid then
            return n
        end
    end
    return t
end

--获取用户得分最高的一次
local function get_biggest_scores(uid)
    local b = { cur_socre = 0, bomb_count = 0 }
    for i = 1, #users_score do --总局数
        local uid_scors = users_score[i].uid_scores
        for m, n in pairs(uid_scors) do
            if uid == n.uid then
                b = n
                break
            end
        end
    end
    return b
end

--设置用户每局得分
local function set_user_scores(gold, isMasterWin)
    local uid_score = {}
    for i = 1, #seats do
        local p = seats[i]
        local scores = get_user_scores(p.uid)
        local uscores = scores.score
        local temp_score = {}
        if isMasterWin then --地主赢
            if p.uid == master.uid then
                temp_score.cur_socre = 3 * gold
                temp_score.score = uscores + 3 * gold
            else
                temp_score.cur_socre = -gold
                temp_score.score = uscores - gold
            end
        else
            if p.uid == master.uid then
                temp_score.cur_socre = -3 * gold
                temp_score.score = uscores - 3 * gold
            else
                temp_score.cur_socre = gold
                temp_score.score = uscores + gold
            end
        end
        local t = {}
        t.uid = p.uid
        t.cur_socre = temp_score.cur_socre
        t.score = temp_score.score
        t.bomb_count = p.bomb_count or 0
        t.remain_cards = user_cards[i]
        table.insert(uid_score, t)
    end
    --这里可以设置用户金币消息?
    table.insert(users_score, {
        master = master.uid,
        rate_max = rate_max,
        uid_scores = uid_score
    })
end

--当前游戏结束:
local function broadcast_win()
    luadump("broadcast_win----->")
    local uid_cards = {}
    local uid_score = {}
    for i = 1, #seats do
        local p = seats[i]
        local uscores = get_user_scores(p.uid)
        local t_cards = user_cards[i]
        table.insert(uid_score, p.uid) --uid
        table.insert(uid_score, #t_cards) --剩余牌数量
        table.insert(uid_score, p.bomb_count or 0) --出牌炸弹数量
        table.insert(uid_score, uscores.cur_socre) --当局积分胜负
        table.insert(uid_score, uscores.score) --总积分胜负
        p.score = uscores.score --设置用户分数
    end
    local result = {
        master = master.uid,
        count = 4,
        infos = uid_score,
        cards = {} --按照当前文档是不需要的
    }
    luadump(result)
    for k, v in pairs(players) do
        send_to_all("game.ShowCard", { uid = v.uid, seatid = v.seatid, cards = user_cards[v.seatid] })
    end
    send_to_all("game.GameResult", result)
    histroy.recording = histroy.recording or {}
    tinsert(histroy.recording, {
        master = master,
        count = 4,
        round = played_times,
        infos = result.infos,
        cards = result.cards
    })
end

--记录炸弹数据
local function do_bomb_count(type, p)
    if type == nbUtil.ZHADAN or type == nbUtil.WANGZHA then
        p.bomb_count = p.bomb_count and p.bomb_count + 1 or 1
    end
end

--获取炸弹总数
local function get_bomb_count()
    local total = 0
    for k, v in pairs(players) do
        local c = v.bomb_count or 0
        total = total + c
    end
    return total
end

--设置用户输赢局数
local function set_user_win_count(isMasterWin)
    for k, v in pairs(players) do
        if isMasterWin then
            if master.uid == v.uid then
                v.win_count = v.win_count and v.win_count + 1 or 1
            else
                v.lose_count = v.lose_count and v.lose_count + 1 or 1
            end
        else
            if master.uid == v.uid then
                v.lose_count = v.lose_count and v.lose_count + 1 or 1
            else
                v.win_count = v.win_count and v.win_count + 1 or 1
            end
        end
    end
end

--结算
local function calculate(p)
    local bomb_count = get_bomb_count()
    local gold = rate_max * per_gold * (2 ^ bomb_count)
    if p.uid == master.uid then
        set_user_scores(gold, true)
        set_user_win_count(true)
    else
        set_user_scores(gold, false)
        set_user_win_count(false)
    end
    broadcast_win()
end

--获取当前出牌用户
local function get_play_user()
    if nil == pre_play_user then --由地主开始出牌
        return master
    else
        local seatid = pre_play_user.seatid
        return seats[seatid % 4 + 1]
    end
end

--获取最后一个人出的牌，除开过的牌,p是当前操作人
local function get_last_player(p)
    if used_cards and #used_cards > 0 then
        local t = used_cards[#used_cards]
        local p1 = get_play_user(p)
        if p1.uid == t[6] then
            return false --是自己
        else
            return t
        end
    end
    return false --首次出牌
end

--通知下一个出牌人,p是当前操作人 p = player
local function notify_to_paly(p)
    pre_play_user = p
    --千万注意顺序
    local type, cards, avatarCards = 0, {}, {}
    local last_u_cards = get_last_player(p)
    if last_u_cards then
        type = last_u_cards[1]
        cards = last_u_cards[2]
        avatarCards = last_u_cards[3]
    end --------
    p = get_play_user()
    local asktime = time_paly_card
    send_to_all("game.AskPlayCard", { seatid = p.seatid, time = asktime, cardtype = type, cards = cards, avatarCards = avatarCards })
    next_status_time = os.time() + asktime
end

--从自己的牌中删除已经出的牌
--p -> player
--cards 封装好的数据结构，包含6个长度的数组
local function do_delete_cards(p, cards)
    local cur_cards = user_cards[p.seatid]
    local nor_cards = cards[2] --普通牌
    local cha_cards = cards[3] --王牌
    if nor_cards then
        for j = 1, #nor_cards do
            for i = 1, #cur_cards do
                if cur_cards[i] == nor_cards[j] then
                    table.remove(cur_cards, i)
                    break
                end
            end
        end
    end
    if cha_cards then
        for j = 1, #cha_cards do
            for i = 1, #cur_cards do
                if j % 2 == 1 and cur_cards[i] == cha_cards[j] then
                    table.remove(cur_cards, i)
                    break
                end
            end
        end
    end
end

--用户:检查当前操作是否有操作牌
--cards
local function check_pass_to_play(cards)
    if #cards[2] == 0 and #cards[3] == 0 then
        return true
    end
    return false
end

--用户离开
local function do_clear_player(p)
    seats[p.seatid] = 0
    p.seatid = nil
    p.ready = 0
    send_to_all("game.LeaveTableNtf", { uid = p.uid })
end

--清除待离开用户:房卡模式
local function check_leave_player()
    if not leave_seats and played_times == total_times then
        for k, v in pairs(leave_seats) do
            do_clear_player(v)
        end
    end
end

local function game_stop()
    game_status = 8
    next_status_time = os.time() + time_game_stop
    luadump("game_stop-------->")
    histroy.endtime = os.time()
    histroy.players = histroy.players or {}
    local info
    local infos = {}
    for uid, p in pairs(players) do
        if p.ready == 1 and p.seatid and p.seatid > 0 then
            local totalscore = get_user_scores(p.uid).score
            local biggestscore = get_biggest_scores(p.uid) --获取用户赢得最多的一局
            info = {
                uid = p.uid,
                nickname = p.nickname,
                wincount = p.win_count or 0,
                losecount = p.lose_count or 0,
                totalscore = totalscore,
                maxscore = biggestscore.cur_socre,
                bombcount = biggestscore.bomb_count,
            }
            tinsert(histroy.players, info)
            tinsert(infos, info)
        end
    end
    luadump(infos)
    --发送总牌局结束消息
    send_to_all("game.GameLandlordEnd", { round = total_times, infos = infos })
    --发送历史牌局消息??
    --    send_to_all("game.NiuNiuHistroy", {list = histroy.recording})
    check_leave_player()
end

--检测总牌局是否结束
local function check_to_end()
    if played_times == total_times then
        game_stop()
    end
end




--用户：检测当前牌局结束
local function check_to_win(p)
    if not user_cards[p.seatid] or #user_cards[p.seatid] == 0 then
        game_status = 4
        next_status_time = os.time() + time_game_end
        calculate(p)
        check_to_end()
        return true
    end
    return false
end

--统一出牌函数:
-- -- 现在不出牌，那么在出牌记录中不保存
-- -- 在这里对空做了处理
-- -- 这里还需要做必出判断?
--max 最大牌值
--leng 组合牌行最大长度334455 -> 3
--uid
--cards = { [1] = msg.cardtype, [2] = msg.cards, [3] = msg.avatarCards }
local function do_play_cards(max, leng, uid, cards)
    luadump("user do play cards---->")
    luadump(uid)
    luadump(cards)
    local i_type, i_cards, i_avatar = cards[1], cards[2], cards[3]
    cards[1] = i_type
    cards[2] = i_cards or {}
    cards[3] = i_avatar or {}
    cards[4] = max
    cards[5] = leng
    cards[6] = uid
    if not check_pass_to_play(cards) then --不是过,插入出牌记录
        table.insert(used_cards, cards)
    end
    local p = players[uid]
    send_to_all("game.PlayCard", { uid = p.uid, cards = cards[2], avatarCards = cards[3], cardtype = cards[1] })
    do_bomb_count(i_type, p)
    do_delete_cards(p, cards)
    if not check_to_win(p) then
        notify_to_paly(p)
    end
end


--允许出牌：统一出牌函数,test
local function do_play_cards_test(p, msg)
    do_play_cards(0, 0, p.uid, { 1, msg.cards, msg.avatarCards })
end

--获取必须出牌人
local function get_must_player()
    if #used_cards == 0 or nil == used_cards then
        return master
    end
    local last_playerid = used_cards[#used_cards][6]
    local p = get_play_user()
    if p.uid == last_playerid then
        return p
    end
    return nil
end

--用户出牌：检查 ->出牌
--p ->player
--msg
local function check_cards_to_play(p, msg)
    if get_play_user().uid == p.uid then
        local cards = {
            msg.cardtype and msg.cardtype or 1,
            msg.cards and msg.cards or {},
            msg.avatarCards and msg.avatarCards or {}
        }
        local flag, max, leng = nbUtil.check(cards, user_cards[p.seatid], used_cards, p.uid)
        if flag then
            do_play_cards(max, leng, p.uid, cards)
        else
            luadump("error cards--->")
            luadump(msg)
        end
    end
end

--用户:出牌超时,一手牌必须出,默认最小的一张,其他不要
local function cancel_to_play()
    local p = get_must_player()
    if not p then
        p = get_play_user()
        do_play_cards(0, 0, p.uid, { 0, {}, {} })
    else --必出
        local cards = nbUtil.sort(user_cards[p.seatid])
        local card = cards[#cards]
        do_play_cards(nbUtil.getCardRealVal(card), 1, p.uid, { 1, { card }, {} })

        --自己出牌测试
        --        local card = user_cards[p.seatid]
        --        local palycards = cardsHelp.get_cards(card)
        --        local max, len, type, tCards = palycards.cal_value, palycards.count, palycards.type, palycards.cards
        --        do_play_cards(max, len, p.uid, { type, { tCards }, {} })
    end
    notify_to_paly(p)
end

--用户:托管
local function check_mandate(p)
end

--用户:掉线
local function check_user_lost(p)
end

--用户:听牌
local function check_ready_hand(p)
end

--初始化
function this.init(ps, api, m_conf, m_times, m_score, m_pay, m_code, m_gameid, uid)
    math.randomseed(os.time(), "进入房间成功!");
    players = ps
    config = m_conf
    init_params = config.init_params
    game_status = 0
    initSeats() --数组
    owner = uid
    gameid = m_gameid
    --    total_times = m_times
    total_times = 2 --测试协议
    code = m_code
    paytype = m_pay
    rule_score = m_score
    endtime = os.time() + m_conf.wait_time
    score = m_score

    send_to_all = api.send_to_all
    free_table = api.free_table

    histroy = {}
    histroy.owner = uid
    histroy.time = os.time()
    histroy.code = m_code
    histroy.times = total_times
    histroy.gameid = gameid
end

--接收客户端消息,player,cmd,msg
function this.dispatch(p, name, msg)
    if game_status == 0 then
        if name == "SitdownNtf" then --坐下
            local seatid = tonumber(msg.seatid)
            if seatid > 0 and p.seatid == 0 and seats[seatid] == 0 then
                seats[seatid] = p
                p.seatid = seatid
                p.ready = 0
                send_to_all("game.SitdownNtf", { uid = p.uid, seatid = seatid, nickname = p.nickname, headimg = "null" })
            elseif seatid > 0 and p.seatid ~= 0 and seats[seatid] == 0 then
                seats[p.seatid] = 0
                seats[seatid] = p
                p.seatid = seatid
                p.ready = 0
                send_to_all("game.SitdownNtf", { uid = p.uid, seatid = seatid, nickname = p.nickname, headimg = "null" })
            end
        elseif name == "GetReadyNtf" then --准备
            if not p.ready or p.ready == 0 then
                if p.seatid and p.seatid > 0 then
                    p.ready = 1
                    send_to_all("game.GetReadyNtf", { uid = p.uid, seatid = p.seatid })
                    if checkAllReady() then this.game_start() end
                end
            end
        end
    end
    if game_status == 2 then --叫分
        if name == "SetRate" then
            setUserRate(p, msg)
        end
    end
    if game_status == 3 then
        if name == "PlayCard" then --出牌
            --do_play_cards_test(p, msg)
            check_cards_to_play(p, msg)
        elseif name == "game.托管？" then
            --??
        end
    end
end

-- 发送房间信息
function this.send_tableinfo(p)
    local msg = {}
    local list = {}
    for uid, v in pairs(players) do
        tinsert(list, {
            uid = v.uid,
            nickname = v.nickname,
            sex = 1,
            seatid = v.seatid or 0,
            ready = v.ready or 0,
            online = v.online or 1,
            score = v.score or 0
        })
    end
    msg.owner = owner
    msg.endtime = endtime
    msg.gameid = gameid
    msg.times = total_times
    msg.playedtimes = played_times
    msg.score = score
    msg.paytype = paytype
    msg.code = code
    msg.players = list
    p:send_msg("game.TableInfo", msg)
end

--必须返回
function this.join(p)
    if checkSeatsFull() then
        return true
    end
    return false
end

function this.game_end()
end

--只要游戏未开始都允许离开
--开房模式整个牌局结束允许离开
--单局模式，当前牌局结束允许离开
function this.leave_game(p)
    if game_status == 0 or game_status == 4 then
        do_clear_player(p)
        return true
    end
    leave_seats[p.uid] = p
    return false
end


--断线重连调用
function this.resume(p)
end

function this.game_start()
    played_times = played_times + 1
    send_to_all("game.GameStart", {})
    send_to_all("game.StartRound", { round = played_times, total = total_times })
    game_status = 1
    next_status_time = os.time() + 1
    add_cards()
end

function this.free()
    for seatid, v in pairs(seats) do
        seats[seatid] = nil
    end

    free_table = nil
    send_to_all = nil
    histroy = nil
    static_cards = nil
    cards = nil

    for uid, p in pairs(players) do
        for k, v in pairs(p) do
            p[k] = nil
        end
    end
end

local function game_restart()
    --检测用户是否离开，金钱等等
    rate_pre_player = nil
    rate_max = 0
    rate_max_player = nil
    rate_count = 0

    used_cards = {}

    pre_play_user = nil
    played_times = played_times + 1

    send_to_all("game.GameStart", {})
    send_to_all("game.StartRound", { round = played_times, total = total_times })
    game_status = 1
    next_status_time = os.time() + 1
    add_cards()
end

--检查必须抢地主
local function check_must_be_master_hock()
end

function this.update()
    if game_status == 0 and os.time() > endtime then
        game_stop()
    elseif game_status == 1 and os.time() > next_status_time then --开始游戏状态
        game_status = 2
        getUserRate()
    elseif game_status == 2 and os.time() > next_status_time then --超时取消叫分
        check_must_be_master_hock()
        setUserRate(rate_pre_player, { rate = 0 })
    elseif game_status == 2.3 and os.time() > next_status_time then --显示地主牌
        first_ask_play()
    elseif game_status == 3 and os.time() > next_status_time then --出牌超时
        cancel_to_play()
    elseif game_status == 4 and os.time() > next_status_time then --给出结算时间
        if checkAllReady() then game_restart() end
    elseif game_status == 8 and os.time() > next_status_time then --给出结算时间
        free_table(histroy, 3001)
    end
end

return this