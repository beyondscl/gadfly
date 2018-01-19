local this = {}

this[1001] = {
    name = "牛牛", --游戏名称
    logic = "niuniu", --加载的逻辑
    init_params = 1, --加载逻辑的时候用到的参数, 1是抢庄牛牛，2是轮庄，3是固定庄
    min_player = 2,
    max_player = 5,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { 3, 5 },
    times = { 10, 20, 30 },
    usegold = nil,
    rate = { [3] = { 1, 2, 3 }, [5] = { 1, 2, 3, 5 } }
}

this[1002] = {
    name = "牛牛", --游戏名称
    logic = "niuniu", --加载的逻辑
    init_params = 2, --加载逻辑的时候用到的参数, 1是抢庄牛牛，2是轮庄，3是固定庄
    min_player = 2,
    max_player = 5,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { 3, 5 },
    times = { 3, 10, 20 },
    usegold = nil,
    rate = { [3] = { 1, 2, 3 }, [5] = { 1, 2, 3, 5 } }
}

this[1003] = {
    name = "牛牛", --游戏名称
    logic = "niuniu", --加载的逻辑
    init_params = 3, --加载逻辑的时候用到的参数, 1是抢庄牛牛，2是轮庄，3是固定庄
    min_player = 2,
    max_player = 5,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { 3, 5 },
    times = { 10, 20, 30 },
    usegold = nil,
    rate = { [3] = { 1, 2, 3 }, [5] = { 1, 2, 3, 5 } }
}

this[2001] = {
    name = "斗地主", --游戏名称
    logic = "land", --加载的逻辑
    init_params = 1, --加载逻辑的时候用到的参数, 1是抢地主，2是叫分
    min_player = 3,
    max_player = 3,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { 1, 3 },
    times = { 10, 20, 30 },
    usegold = nil,
    bomb = { 3, 4, 5 }
}

this[2002] = {
    name = "斗地主", --游戏名称
    logic = "land", --加载的逻辑
    init_params = 2, --加载逻辑的时候用到的参数, 1是抢地主，2是叫分
    min_player = 3,
    max_player = 3,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { 1, 3 },
    times = { 8, 16 },
    usegold = nil,
    bomb = { 3, 4, 5 }
}

this[3001] = {
    name = "宁波斗地主", --游戏名称
    logic = "fight_landlord_nb", --加载的逻辑
    init_params = {}, --加载逻辑的时候用到的参数:2是叫分
    min_player = 4,
    max_player = 4,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { -1, 4, 6, 8 }, --炸弹数量限制
    times = { 8, 16 },
    usegold = nil
}

this[4001] = {
    name = "捕鱼",
    logic = "buyu02",
    init_params = {},
    min_player = 1,
    max_player = 4,
    wait_time = 20 * 60, --房间等待时间，秒为单位
    price = { 40, 160 }, --开一把需要的钱
    score = { 3, 5 },
    times = { 10, 20, 30 },
    usegold = nil,
    -- rate = {1,2,3}
}


this[5001] = {
    name = "百人牛牛", --游戏名称
    logic = "hundred_niuniu", --加载的逻辑
    init_params =
    {
        robot_count = 10, --默认机器人数量
        per_max_gold = 5, --每局最大下注多少*万
        room_min_gold = 0.1, --房间最低金币限制*万
        unit = 10000, --单位
        min_master_gold = 100 --上庄最低金钱
    }, --加载逻辑的时候用到的参数
    min_player = 2,
    max_player = 100,
    wait_time = 0, --不需要开房
    price = 0, --自定义下注
    score = { 3, 5 },
    times = 0, --不限局数
    usegold = nil,
    rate = { 1, 2, 3 }
}

return this