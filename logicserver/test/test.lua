--冷廷学
--2017年11月10日11:50:07
--doc 牛牛判定
--[[
牌说明:
1.共52张牌 
2.个位和十位表示牌大小：1,2,3,4,j j=11... 
3.百位表示颜色：4,3,2,1 黑，红，梅，方
没牛0<有牛[0-9]<牛牛10<顺子11<葫芦21<五小牛31<五花牛41<炸弹51<同花顺61
]]
--[[
外部调用niuniuCompare(table1,table2) 
table1 > table2 -> true
table1|tble2 -> {101,102,103,104,105}
]]

local cardTool = {}

--比较:a > b 返回true
function cardTool.compare(a, b)  
    if a > b then  
        return true  
    end  
    return false
end  

--当装闲牌一样大比如都是牛7：比较最大的一张牌
function cardTool.compareMax(m,c)
    local mvalue = m%100
    local cvalue = c%100
    if mvalue == cvalue then        
        return cardTool.compare(m, c)
    else
        return cardTool.compare(mvalue, cvalue)
    end
end

--排序{1,5,2} -> {5,2,1}
function cardTool.sort(cards)  
 table.sort(cards, cardTool.compare)
 return cards
end  

--转换牌值:? -> ?%100 ;? >10  -> ? = 10
--根据需要调用
function cardTool.getCardChgVal(card)  
    card = card % 100
    if card > 10 then
        return 10
    end
    return card
end  

--获取牌的个位和十位: {?} -> {?%100}
function cardTool.getCardRealVal(cards)  
    cardsnew = {}
    for i=1,#cards do
        cardsnew[i] = cards[i]%100
    end
    return cardsnew
end

--获取最大的一张牌
function cardTool.getCardsMax(cards)  
    cardsT = cardTool.getCardRealVal(cards)
    CardMaxRealVal = cardTool.sort(cardsT)[1]       --最大的十位个位位数
    CardMaxlVal = {}                                --牌面最大的数
    for i=1,#cards do
        if cards[i]%100 >= CardMaxRealVal then
            CardMaxlVal[#CardMaxlVal+1] =  cards[i]
        end
    end
    return cardTool.sort(CardMaxlVal)[1]
end


--牛牛判定：无牛 ->0，牛几 -> 1-9,牛牛 -> 10
--大于10的牌算10
--先算出五张牌总值除以十的余数，然后再枚举两张牌，
--若存在两张牌之和除以十的余数等于五张牌除以十的余数，那么其他三张牌必然总和为十的倍数。
--那么这个余数就是牛数
function cardTool.getNiu(cards)  
    local lave = 0                 
    for i = 1,#cards do  
            lave = lave + cardTool.getCardChgVal(cards[i]) --余数  
        end  
        lave = lave % 10  
        for i = 1,#cards - 1 do  
            for j = i + 1,#cards do  
            if(cardTool.getCardChgVal(cards[i])+cardTool.getCardChgVal(cards[j]))%10 == lave then  --枚举2张
                if lave == 0 then  
                    return 10     --牛牛
                else  
                    return lave   --牛几
                end  
            end  
        end  
    end  
    return 0                      --没牛
end  

--小牛判定:五张总和小于10
function cardTool.isSmallNiu(cards)  
    local sum = 0       
    for i = 1,#cards do  
        sum = sum + cards[i]%100
    end  
    if sum <= 10 then  
        return 31  
    else  
        return -1  
    end  
end  

--五花牛判定: ? -> {j|q|k}
function cardTool.isColourNiu(cards)  
    for i=1,#cards do
        if cards[i]%100 < 10 then
            return -1
        end
    end
    return 41
end  

--炸弹判定：需要去掉百位
function cardTool.isBomb(cards)  
    cards = cardTool.getCardRealVal(cards)
    cards = cardTool.sort(cards)
    if cards[1] == cards[4] then  
        return 51  
        elseif cards[2] == cards[5] then  
            return 51  
        else  
            return -1  
        end  
    end  

--顺子判定：
function cardTool.isStraight(cards)  
    cards = cardTool.getCardRealVal(cards)
    cards = cardTool.sort(cards)
    for i=2,#cards do
        if cards[i] ~= cards[1] -i + 1 then
            return -1
        end
    end
    return 11
end  

--同花顺子判定：
function cardTool.isFlush(cards)
    if cardTool.isStraight(cards)==11 then
        for i=2,#cards do
            if math.floor(cards[i]/100) ~= math.floor(cards[1]/100) then
                return -1
            end
        end
        return 61
    end
    return -1
end

--葫芦判定：3+2
function cardTool.isCucurbit(cards)
    cards = cardTool.getCardRealVal(cards)
    cards = cardTool.sort(cards)
    if (cards[1] == cards[2] and cards[4] == cards[5] and (cards[3]==cards[2] or cards[3]==cards[4])) then
        return 21
    end
    return -1    
end

--方法封装
function cardTool.doGetNiu(cards)
    local cardCalculate = 
    {
    cardTool.getNiu(cards),
    cardTool.isStraight(cards),
    cardTool.isCucurbit(cards),
    cardTool.isSmallNiu(cards),
    cardTool.isColourNiu(cards),
    cardTool.isBomb(cards),
    cardTool.isFlush(cards)
}
t = cardTool.sort(cardCalculate)
return  t
end

--提供外部接口判断
function cardTool.niuniuCompare(master,client)
    tMaster = cardTool.doGetNiu(master)
    tClient = cardTool.doGetNiu(client)
    print(table.concat(tMaster,','))
    print(table.concat(tClient,','))

    m = tMaster[1]
    c = tClient[1]

    if m == c then 
        local masterMax = cardTool.getCardsMax(master)
        local clientMax = cardTool.getCardsMax(client)
        print(masterMax)
        print(clientMax)
        return cardTool.compareMax(masterMax,clientMax)
    else
        return cardTool.compare(m,c)
    end
end



--接口测试
--葫芦对比没牛
-- master = {411,311,211,402,302}
-- client = {404,304,401,412,413}

-- 问题牌，牛一赢了牛二?
-- master = {403,307,112,304,107}
-- client = {402,302,306,303,309}

--问题牌，葫芦小于没牛
-- master = {411,402,211,202,111}
-- client = {404,301,212,204,113}

-- 牛q 小于牛j
master = {403,207,211,305,312}
client = {302,408,411,105,111}
print("接口测试",cardTool.niuniuCompare(master,client))


if 1==1 then
    print(1)
    elseif 1~=1 then
         print(2)
end



-- array 必须用1开始,有序的，table是hash的不能保证有序
t1 = {}
t1[1] = 1
t1[2] = 2

print("=-=========",#t1)
table.remove(t1,1)
print("=-=========",#t1)
print(type (t1[2]) == nil)

--array
--array[1]
--pairs
--ipairs  性能高



-- return cardTool

-- --测试
-- cards = {401,402,303,204,111}
-- cards = cardTool.sort(cards)
-- print(table.concat(cards,',')," 排序结果是 ",table.concat(cards,','),"\n")
-- cards = {401,402,303,204,111}
-- print(table.concat(cards,',')," 牛牛结果是 ",cardTool.getNiu(cards),"\n")
-- cards = {401,402,107,212,113} 
-- print(table.concat(cards,',')," 牛牛结果是 ",cardTool.getNiu(cards),"\n")
-- cards = {401,301,201,102,202} 
-- print(table.concat(cards,',')," 小牛结果是 ",cardTool.isSmallNiu(cards),"\n")
-- cards = {401,301,201,102,212} 
-- print(table.concat(cards,',')," 小牛结果是 ",cardTool.isSmallNiu(cards),"\n")
-- cards = {411,412,313,211,111}
-- print(table.concat(cards,',')," 五花牛结果是 ",cardTool.isColourNiu(cards),"\n")
-- cards = {401,402,303,204,111}
-- print(table.concat(cards,',')," 五花牛结果是 ",cardTool.isColourNiu(cards),"\n")
-- cards = {401,301,201,101,111}
-- print(table.concat(client,',')," 炸弹结果是 ",cardTool.isBomb(client),"\n")
-- cards = {401,301,201,111,112}
-- print(table.concat(cards,',')," 炸弹结果是 ",cardTool.isBomb(cards),"\n")
-- cards = {401,402,403,404,305}
-- print(table.concat(cards,',')," 顺子结果是 ",cardTool.isStraight(cards),"\n")
-- cards = {401,402,403,404,306}
-- print(table.concat(cards,',')," 顺子结果是 ",cardTool.isStraight(cards),"\n")
-- cards = {401,402,403,404,405} --
-- print(table.concat(cards,',')," 同花顺结果是 ",cardTool.isFlush(cards),"\n")
-- cards = {401,402,403,404,305} --
-- print(table.concat(cards,',')," 同花顺结果是 ",cardTool.isFlush(cards),"\n")
-- cards = {101,201,301,404,104} --
-- print(table.concat(master,',')," 葫芦结果是 ",cardTool.isCucurbit(master),"\n")
-- cards = {101,201,301,404,105} --
-- print(table.concat(cards,',')," 葫芦结果是 ",cardTool.isCucurbit(cards),"\n")