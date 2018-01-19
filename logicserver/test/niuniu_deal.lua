--冷廷学
--2017年11月10日11:50:07
--doc 牛牛判定
--[[
牌说明:
1.共52张牌 
2.个位和十位表示牌大小：1,2,3,4,j j=11... 
3.百位表示颜色：4,3,2,1 黑，红，梅，方
没牛0<有牛[0-9]<牛牛10<顺子11<同花14<葫芦21<五小牛31<五花牛41<炸弹51<同花顺61
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
            t = cardTool.getCardChgVal(cards[i]) --余数  
            lave = lave + t
        end  
        lave = lave % 10  
        for i = 1,#cards - 1 do  
            for j = i + 1,#cards do  
            if(cardTool.getCardChgVal(cards[i])+cardTool.getCardChgVal(cards[j]))%10 == lave
            then  --枚举2张
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

--同花判定：
function cardTool.isTonghua(cards)
    card = cards[1]
    for i=2,#cards do
        if math.floor(cards[i]/100) ~= math.floor(card/100) then
            return -1
        end
    end
    return 14
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
    cardTool.isTonghua(cards),
    cardTool.isFlush(cards)
}
t = cardTool.sort(cardCalculate)
print(table.concat(t,','),"\n")
return  t
end

--提供外部接口判断
function cardTool.niuniuCompare(master,client)
    tMaster = cardTool.doGetNiu(master)
    tClient = cardTool.doGetNiu(client)

    m = tMaster[1]
    c = tClient[1]

    if m == c then 
        local masterMax = cardTool.getCardsMax(master)
        local clientMax = cardTool.getCardsMax(client)
        return cardTool.compareMax(masterMax,clientMax)
    else
        return cardTool.compare(m,c)
    end
end

--接口测试
-- master = {401,301,201,404,304}
-- client = {401,402,403,404,409}
-- master = {304,307,109,306,108}
-- client = {102,203,205,407,410}
-- print(table.concat(master,',')," 牛牛结果是 ",cardTool.getNiu(master),"\n")
-- print(table.concat(client,',')," 牛牛结果是 ",cardTool.getNiu(client),"\n")
-- print("接口测试",cardTool.niuniuCompare(master,client),'----------------------------------','\n')



--测试获取牌
math.randomseed(os.time())
local static_cards = {
    101,102,103,104,105,106,107,108,109,110,111,112,113,      --方
    201,202,203,204,205,206,207,208,209,210,211,212,213,      --梅
    301,302,303,304,305,306,307,308,309,310,311,312,313,      --红
    401,402,403,404,405,406,407,408,409,410,411,412,413,      --黑
}

local function shuffle()
    cards = {}
    local tmp = {1,2,3,4,5,6,7,8,9,10,11,12,13,
                14,15,16,17,18,19,20,21,22,23,24,25,26,
                27,28,29,30,31,32,33,34,35,36,37,38,39,
                40,41,42,43,44,45,46,47,48,49,50,51,52}
    local index
    for i=52,1,-1 do
        index = table.remove(tmp, math.random(i))
        table.insert(cards, static_cards[index])
    end
    return cards
end

for i=1,1000 do
    master = {shuffle()[2],shuffle()[3],shuffle()[4],shuffle()[5],shuffle()[6]}
    client = {shuffle()[21],shuffle()[22],shuffle()[23],shuffle()[24],shuffle()[25]}
    print(table.concat(master,','),"master(庄) 牛牛结果是 ",cardTool.getNiu(master),"\n")
    print(table.concat(client,','),"client(闲) 牛牛结果是 ",cardTool.getNiu(client),"\n")
    print("接口测试",cardTool.niuniuCompare(master,client),'----------------------------------','\n')
end



