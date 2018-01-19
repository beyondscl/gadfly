--
-- Created by IntelliJ IDEA.
-- User: 冷廷学
-- Date: 2017/11/28
-- Time: 10:40
--
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


----删除测试
local table_t = {}
table.insert(table_t,"a")
table.insert(table_t,"b")
table.insert(table_t,"c")
print_r(table_t)
table.remove(table_t,1)
print_r(table_t)



----求差集

local function do_delete_cards()
    local cur_cards = {1,2,3,4,5,6,9}
    local nor_cards = {1,2,3} --普通牌
    local cha_cards = {{6,0},{9,0}} --王牌
    for j = 1, #nor_cards do
        for i = 1, #cur_cards do
            if cur_cards[i] == nor_cards[j] then
                table.remove(cur_cards, i)
            end
        end
    end
    for j = 1, #cha_cards do
        for i = 1, #cur_cards do
            if cur_cards[i] == cha_cards[j][1] then
                table.remove(cur_cards, i)
            end
        end
    end
end
print_r(do_delete_cards())


--
print("-------------------------->")
local t1 = {1}
table.remove(t1,1)
print_r(t1 == nil)





















