local skynet = require "skynet"
local cluster = require "skynet.cluster"

local nodename = skynet.getenv("nodename")

skynet.start(function()
	local redis = skynet.uniqueservice("redispool")
	skynet.call(redis, "lua", "start")

	local gamemanager = skynet.uniqueservice("gamemanager")
	cluster.register("manager", gamemanager)
	cluster.open(nodename)
	skynet.exit()
end)
