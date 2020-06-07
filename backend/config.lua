local json = require('json')

local config_module = {}

local config_handle = io.open("config.json", "r")
local config = json.decode(config_handle:read("*a"))
config_handle:close()

config_module.get = function(name)
	if config == nil then return nil end
	if config[name] == nil then return nil end
	return config[name] 
end

return config_module