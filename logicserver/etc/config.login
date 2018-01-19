include "config.common"

nodename = "login"

luaservice = luaservice .. "./server/login/?.lua;"
-- 将添加到 package.path 中的路径，供 require 调用。
lua_path = lua_path .. "./server/login/?.lua;"..
		   	"./config/?.lua;"..
		   	"./protocol/?.lua;"
snax = lua_path

-- 后台模式
--daemon = --"./"..nodename..".pid"
