local socket = require "client.socket"
local skynet = require "skynet"
local protobuf = require "protobuf"
local parser = require "parser"
local msgprotocol = require "msgprotocol"

local CMD = {}
local client_fd

parser.register({
	"game.proto",
	"user.proto"
	}, "./protocol")


local function send_package(fd, pack)
	local package = string.pack(">s2", pack)
	print("size:"..#package)
	socket.send(fd, package)
end

local function msg_encode(name, msg)
	assert(name)
	local msgid = msgprotocol[name]
	assert(msgid, "agent msg_encode fail, unknow msg, msgname="..name)

	local ok,data
	if type(msg) == "table" then
		ok,data = pcall(protobuf.encode, name, msg)
		assert(ok, "agent msg_encode protobuf.encode fail, msgname="..name)
	end
	
	data = string.pack(">I2", msgid) .. data
	return data
end

-- local ok,data = pcall(msg_encode, respname, respdata)

function CMD.start(conf)
	LOG_DEBUG("connect "..conf.ip..":"..conf.port)

	for i=1,1 do
		client_fd = assert(socket.connect(conf.ip, conf.port))
		send_package(client_fd, "1"..":1:0:0:0")
		-- skynet.sleep(3*100)
		-- send_package(client_fd, "hello")
-- 		message UserInfoRequest {
-- 	required int32 uid = 1;
-- 	optional int32 type = 2;   //请求的数据类型 由UserInfoResonpse的内容进行顺序编号
-- }
		skynet.sleep(3*100)
		-- send_package(client_fd, msg_encode("user.UserInfoRequest", {uid = 1}))
		-- socket.close(client_fd)
		-- skynet.sleep(1)
	end

	LOG_DEBUG("done")
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
