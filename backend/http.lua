_G.core = require("core")
_G.http = require('coro-http')
_G.json = require('json')
_G.config = require('./config')

local Emitter = core.Emitter 
local listen_ip = config.get("listen_ip")
local listen_port = config.get("listen_port")
local tokens = config.get("tokens")
local http_emitter = Emitter:new()

if listen_ip == nil then listen_ip = "0.0.0.0" end
if listen_port == nil then listen_port = 8080 end 

_G.http_responce_error_json = function (err_str)
	local err_table = {error = err_str}
	local json_str = json.encode(err_table)
	return { code = 200, {"Server", "GG Project Backend v 0.1"}, {"Content-Type", "application/json"}, {"Content-Length", #json_str + 1}, }, json_str.."\n"
end

_G.http_responce_ok_json = function (data)
	local json_str = json.encode({data = data})
	return { code = 200, {"Server", "GG Project Backend v 0.1"}, {"Content-Type", "application/json"}, {"Content-Length", #json_str + 1}, }, json_str.."\n"
end

local function http_is_api_token(str_token)
	if str_token == nil then return false end

	for i = 1, #tokens do
		if str_token == tokens[i] then return true end
	end
end

_G.http_backend_register = function (path, cb)
	http_emitter:on('/api/'..path, cb)
end

http_backend_register('ping', function (http_json)
return http_responce_ok_json("Have a very safe day.")
end)

http.createServer(listen_ip, listen_port, function (head, body)

if not (head.method == 'POST') then return http_responce_error_json("Only POST requests") end

local body_json = json.decode(body)

if not http_is_api_token(body_json.token) then return http_responce_error_json("Bad token") end

if http_emitter:listeners(head.path) == 0 then return http_responce_error_json("No handlers for this path") end 

return http_emitter:listeners(head.path)[1](body_json)
end)

require('modules/exec')
