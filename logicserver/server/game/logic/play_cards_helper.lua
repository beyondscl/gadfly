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


--
-- Created by IntelliJ IDEA.
-- User: 冷廷学
-- Date: 2017/12/1
-- Time: 11:17
-- doc:1.默认出最小的单牌，对子，...2压过农民的牌
--

--i need more time
--二叉树...
--数组|hash...

--可以不出，但是不能出错
local cardsHelp = {}
--转换我的牌到指定数据结构
function cardsHelp.structure(cards)
    local new = {}
    for i = 1, 22 do -->王最大值522
        new[i] = { cal_value = i, count = 0, cards = {} }
    end
    for k, v in pairs(cards) do
        local r = v % 100
        new[r].count = new[r].count + 1
        table.insert(new[r].cards, v)
    end
    return new
end

--向一个数组中添加牌
function cardsHelp.insert(tarCrads, origCards)
    for i = 1, #origCards do
        table.insert(tarCrads, origCards[i])
    end
end

--压牌：直接获取单，双，三的牌
function cardsHelp.cards_normal(cards, type, max)
    for k, v in pairs(cards) do
        if type == v.count and v.cal_value > max then
            return v.cards
        end
    end
end

--压牌：直接获取炸弹的牌
function cardsHelp.cards_bomb(cards, type, max, leng)
    for k, v in pairs(cards) do
        if type == 8
                and ((v.cal_value >= max and v.count >= leng)
                or (v.cal_value < max and v.count > leng)) then
            return v.cards
        end
    end
end

--三代一对
function cardsHelp.getSanDaiyi(cards, type, max)
    local returnCards = {}
    local c = {}
    returnCards.c = c

    for i = 1, #cards do -- 获取三--[[]]
        local v = cards[i]
        if v.count == 3 and v.cal_value > max then
            returnCards.max = v.cal_value
            returnCards.type = type
            returnCards.len = 1
            cardsHelp.insert(c, v.cards)
            break
        end
    end
    for i = 1, #cards do --获取2
        local v = cards[i]
        if v.count == 2 then
            cardsHelp.insert(c, v.cards)
            break
        end
    end
    if #returnCards.c == 5 then
        return returnCards
    end
end

--提供递归 type == 2 | 3
function cardsHelp.recursion(cards, type, startIndex, len)
    local r = {}
    if startIndex > #cards - len then return nil end
    for i = startIndex, startIndex + len - 1 do
        if cards[i].count == type then
            cardsHelp.insert(r, cards[i].cards)
        else
            r = {}
            break
        end
    end
    return r or cardsHelp.recursion(cards, type, startIndex + 1, len)
end

--连队
function cardsHelp.getLianDui(cards, type, max, len)
    for i = 1, #cards do
        local v = cards[i]
        if v.count == 2 and v.cal_value > max then
            local r = cardsHelp.recursion(cards, 2, i, len)
            return r
        end
    end
end

--三顺
function cardsHelp.getSanShun(cards, type, max, len)
    for i = 1, #cards do
        local v = cards[i]
        if v.count == 3 and v.cal_value > max then
            local r = cardsHelp.recursion(cards, 3, i, len)
            return r
        end
    end
end

--三顺+连队
function cardsHelp.getHuDie(cards, type, max, len)
    local three = cardsHelp.getSanShun(cards, type, max, len)
    if three then
        local two = cardsHelp.getLianDui(cards, type, 0, len)
        if two then
            cardsHelp.insert(three, two)
            return three
        end
    end
end

--炸弹
function cardsHelp.getbomb(cards, type, max, len)
    for i = 1, #cards do
        local v = cards[i]
        if (v.count == len and v.cal_value > max) or v.count >= len then
            v.type = 8
            return v
        end
    end
end

--四个王
function cardsHelp.getBiggest(my_cards)
end



--自己出牌
function cardsHelp.get_cards(cards)
    --    local cards = cardsHelp.structure(cards)
    --优先出单 -> 双 -> 三,顺序不固定，不考虑连队,飞机
    --    for k, v in pairs(cards) do
    --        if v.count >= 1 and v.count <= 3 then
    --            v.type = v.count
    --            return v
    --        end
    --    end
    for i = 1, #cards do
        local v = cards[i]
        if v.count >= 1 and v.count <= 3 then
            v.type = v.count
            return v
        end
    end
    --只有炸弹
    for k, v in pairs(cards) do
        if v.count ~= 0 then
            v.type = 8
            return v
        end
    end
end

--压牌
function cardsHelp.press_cards(cards, pre_cards)
    local type, max, len = pre_cards[1], pre_cards[4], pre_cards[5]
    if type == 1 or type == 2 or type == 3 then
        return cardsHelp.cards_normal(cards, type, max)
    elseif type == 4 then
        return cardsHelp.getSanDaiyi(cards, type, max)
    elseif type == 5 then
        return cardsHelp.getLianDui(cards, type, max, len)
    elseif type == 6 then
        return cardsHelp.getSanShun(cards, type, max, len)
    elseif type == 7 then
        return cardsHelp.getHuDie(cards, type, max, len)
    elseif type == 8 then
        return cardsHelp.getbomb(cards, type, max, len)
    end
end

local cards = {
    --    103, 103, 103, 103, --测试炸弹
    --    404, --测试单排
    --    310, 410, --测试对子
    --    109, 209, 309, --测试3个
    --    113, 113, 111, 111, 112, 112, --测试连队
    --    113, 113, 113, 111, 111, 111, 112, 112, 112 --测试三顺
    --    113, 113, 113, 111, 111, 111, 112, 112, 112, 103, 103, 104, 104, 105, 105 --三顺+连队
    --    113, 113, 113, 113, 113,
    112, 112, 112, 112,
}
local new = cardsHelp.structure(cards)
--print_r(cardsHelp.get_cards(new))
--print_r(cardsHelp.getbomb(new))
--local pre_cards = {
--    [1] = 4,
--    [2] = nil,
--    [3] = nil,
--    [4] = 8,
--    [5] = 1,
--    [6] = nil
--}
--print_r(cardsHelp.press_cards(new, pre_cards))
--print_r(cardsHelp.press_cards(new, pre_cards))
--local pre_cards = {
--    [1] = 5,
--    [2] = nil,
--    [3] = nil,
--    [4] = 5,
--    [5] = 3,
--    [6] = nil
--}
--print_r(cardsHelp.press_cards(new, pre_cards))
--local pre_cards = {
--    [1] = 6,
--    [2] = nil,
--    [3] = nil,
--    [4] = 5,
--    [5] = 3,
--    [6] = nil
--}
--print_r(cardsHelp.press_cards(new, pre_cards))
--local pre_cards = {
--    [1] = 7,
--    [2] = nil,
--    [3] = nil,
--    [4] = 5,
--    [5] = 3,
--    [6] = nil
--}
--print_r(cardsHelp.press_cards(new, pre_cards))
local pre_cards = {
    [1] = 8,
    [2] = nil,
    [3] = nil,
    [4] = 5,
    [5] = 4,
    [6] = nil
}
print_r(cardsHelp.press_cards(new, pre_cards))
return cardsHelp