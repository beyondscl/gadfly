function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end


player = {}
player[1] = { abc = "" }

print_r(player)
table.remove(player, 2)
print_r(player)


-- 发牌
local function add_cards()
    local list = {}
    local dice = 4
    for i = 1, 5 do
        local t = {}
        for j = 1, 5 do
            table.insert(t, j)
        end
        local ismaster = false
        if dice == i then
            ismaster = true
        end
        list[i] = { ismaster = ismaster, cards = t }
    end
    return list
end

for k, v in ipairs(add_cards()) do
    print(k)
    print_r(v)
end
print("记录用户下注信息测试---------------------------------------------------------------------------------------------------")
--记录用户下注信息
local user_bet_table = {}
local function record_bet(p, msg)
    local ubt = user_bet_table[p.uid]
    local temp = {}
    if ubt == nil then
        temp[msg.seatid] = msg.bet_num
        user_bet_table[p.uid] = temp
        ubt = temp
    end
    if nil == ubt[msg.seatid] then
        ubt[msg.seatid] = msg.bet_num
    else
        ubt[msg.seatid] = msg.bet_num + ubt[msg.seatid]
    end
end

local p = { uid = '123456' }
local msg = { seatid = 1, bet_num = 99 }
record_bet(p, msg)
local msg = { seatid = 1, bet_num = 99 }
record_bet(p, msg)
local msg = { seatid = 9, bet_num = 440 }
record_bet(p, msg)
print_r(user_bet_table)
print_r(user_bet_table[p.uid])

for index, bets in pairs(user_bet_table) do
    for a, b in pairs(bets) do
        print(a, b)
    end
end
print("结算测试---------------------------------------------------------------------------------------------------")
--牌型对应的倍率
local cardtype_2_rate = {
    [1] = 1, -- 1-10 牛1-牛10
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
    [10] = 10,
    [11] = 12, -- 顺子
    [14] = 13, -- 同花
    [21] = 14, -- 葫芦
    [31] = 16, -- 小牛
    [41] = 18, -- 花牛
    [51] = 20, -- 炸弹
    [61] = 25, -- 同花顺
}
print(cardtype_2_rate[14])
-- 结算
local current_cards = {}
current_cards[1] = { ismaster = true, seatid = 5, cards = { 1, 2, 3, 4, 9 } }
current_cards[2] = { ismaster = false, seatid = 1, cards = { 1, 2, 3, 4, 5 } }
current_cards[3] = { ismaster = false, seatid = 2, cards = { 1, 2, 3, 4, 5 } }
current_cards[4] = { ismaster = false, seatid = 3, cards = { 1, 2, 3, 4, 5 } }
current_cards[5] = { ismaster = false, seatid = 4, cards = { 1, 2, 3, 4, 5 } }


local user_bet_table = {}
user_bet_table['123'] = { [1] = 10 }
user_bet_table['234'] = { [1] = 30, [2] = 20 }

local function calculate()
    local temp_master
    for index, v in ipairs(current_cards) do
        if v.ismaster == true then
            temp_master = v.cards
            break
        end
    end
    local temp_cal = {}
    for index, v in ipairs(current_cards) do
        if not v.ismaster then
            local result, calMaster, calClient = false, temp_master, v.cards
            --niuniu_deal.doCompare(temp_master, v.cards)
            temp_cal[v.seatid] = { result, calMaster, calClient }
        end
    end
    -- print_r(temp_master)
    -- print_r(temp_cal)
    local masterWin = 0
    for uid, seats_bet in pairs(user_bet_table) do
        for seatid, bet_num in pairs(seats_bet) do
            local isWin = temp_cal[seatid][0]
            local temp_user_count = 0
            local masterType = temp_cal[seatid][2][1]
            local clientType = temp_cal[seatid][3][1]
            if isWin then --庄赢
                temp_user_count = temp_user_count - (cardtype_2_rate[masterType] or 1) * bet_num
            else
                temp_user_count = temp_user_count + (cardtype_2_rate[clientType] or 1) * bet_num
            end
            masterWin = masterWin - temp_user_count
        end
        --cmd?
    end
    print(masterWin)
    --cmd?庄信息
end

calculate()


print(#({ 1, 2, 3 }))

-- local   cards = {9,2,3,4,5}
-- for i, v in ipairs(cards) do
--     print(i,v)
-- end


--获取下一次叫分
local function getScore(score)
    local s = {}
    for i = 1, 3 do
        if score < i then
            table.insert(s, i)
        end
    end
    return s
end

print_r(getScore(0))


math.randomseed(os.time());
print(initMaster)

--定义数据结构，但是不好迭代
local t = { a = 1, b = 2, c = 3 }
print(t.b, #t)
print(os.time(), '=========================')

local t = { 1, 2, 2, 2, 2 }
table.insert(t, { 4, 4, 4, 4, 4 })
print_r(t)
local s = 1, 2, 3, 4
print(s)

print(false or 2)


------------------------------
local seats = {}
seats[4] = { "4444444444" }
seats[4] = nil
seats[4] = { "4444444444.444" }

print_r(seats)

local user
print(user ~= nil and 1 or 2)




