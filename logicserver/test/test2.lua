function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end


local t = {13123,nil,34343,nil}
    for k,v in pairs(t) do
    	print("过滤空数据",k,v)
    end


print( false or false)
local first_Master_Card = math.random(100)
print(first_Master_Card)

local seats = {}
seats[4]  = {"4444444444"}
seats[4]  = nil
seats[4]  = {"4444444444.444" }

local nor_cards = seats[99]
if not nor_cards then
    print(111111111)
end
local t
print(t and t or {})



--获取真实牌组合：比如普通+王
local nbTool = {}
function nbTool.copyTable(t)
    local a = {}
    for i = 1, #t do
        a[i] = t[i]
    end
    return a
end
function nbTool.geRealCards(cards)
    local t = nbTool.copyTable(cards[2])
    for i = 1, #cards[3] do
        if i % 2 == 1 then
            t[#t + 1] = cards[3][i]
        end
    end
    return t
end

--获取变换后牌组合:比如普通牌+王变换后的牌
function nbTool.getChangeCards(cards)
    local t = nbTool.copyTable(cards[2])
    for i = 1, #cards[3] do
        if i % 2 == 0 then
            t[#t + 1] = cards[3][i]
        end
    end
    return t
end

--test
--注意牌的数据结构
local cards = {
    [1] = 1, --牌行
    [2] = {1,2,3}, --普通牌
    [3] = { 501, 103 }
}
print(table.concat(nbTool.geRealCards(cards),','))
print(table.concat(nbTool.getChangeCards(cards),','))


--函数调用有顺序关系
------
---table取值方式
local t = {}
t[123] = 1
print_r(t[123])
t['a'] = 1
print_r(t['a'])
--------------
--print(math.pow(2, 3)) -->2^3

--设置用户输赢局数
local master = {uid =1}
local players = {{uid = 1},{uid = 2},{uid = 3},{uid = 4} }
for k, v in pairs(players) do
end
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
set_user_win_count(true)
set_user_win_count(true)
--set_user_win_count(false)
--set_user_win_count(false)
for k, v in pairs(players) do
    print_r(v)
end
print("------------------------->")
local t = {}
t[123] = {a = 1,b =2}
t[124] = {a = 1,b =2}
t[125] = {a = 1,b =2}
t[125] = {a = 1,b =2}
for k, v in pairs(t) do
    print_r(k)
    print_r(v)
end
print("------------------------->")
print("--------------------------->>>>>>>>>>>>>>>>>>>>>>>>")
local new = {}
local cardsHelp = {}
--我当前的牌
function cardsHelp.structure(cards)
    for i = 1, 22 do
        new[i] = { cal_value = i, count = 0, cards = {} }
    end
    for k, v in pairs(cards) do
        local r = v % 100
        new[r].count = new[r].count + 1
        table.insert(new[r].cards, v)
    end
end

cardsHelp.structure({ 103, 203, 204, 205 })
print_r(new)
print_r(new.cards)

