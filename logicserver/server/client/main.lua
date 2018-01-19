local skynet = require "skynet"
local max_client = 1
skynet.start(function()
	skynet.error("client start")
	-- skynet.uniqueservice("protoloader")
	-- if not skynet.getenv "daemon" then
	-- 	local console = skynet.newservice("console")
	-- end
	local client
	for i=1,max_client do
		client = skynet.newservice("client")
		skynet.call(client, "lua", "start", {ip="127.0.0.1", port=7001})
	end
	skynet.exit()
end)
