local skynet = require "skynet"

function skynet.add_timer(ti, func)
	local flag = true
	local function cb()
		if not flag then
			return
		end
		func()
		flag, func = false, nil
	end
	skynet.timeout(ti, cb)

	return function()  flag, func = false, nil end
end

function skynet.del_timer( timer )
	assert(type(timer) == "function")
	timer()
end

function skynet.module( name )
    local M = _G[name] or {}  
    _G[name]=M  
    package.loaded[name]=M  
    return M
end

return skynet