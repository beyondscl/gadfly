cardTool = require("niuniu_deal")

-- --接口测试
-- master = {401,402,403,404,405}
-- client = {401,402,403,404,406}

master = { 401, 402, 403, 404, 405 }
client = { 301, 302, 303, 304, 305 }

print(cardTool.niuniuCompare(master, client))