_G.core = require("core")
_G.http = require('http')
_G.json = require('json')
_G.config = require('./config')

local Emitter = core.Emitter 
local listen_ip = config.get("listen_ip")
local listen_port = config.get("listen_port")
local tokens = config.get("tokens")
local http_emitter = Emitter:new()

listen_port = listen_port or 8080

_G.http_response_error_json = function (res, err_str)
	local json_str = json.encode({error = err_str})
--	res:setHeader("Content-Type", "application/json")
--	res:setHeader("Content-Length", #json_str)
	res:write(err_str)
--	res:finish()
end

_G.http_response_ok_json = function (res, data)
	local json_str = json.encode({data = data})
--	res:setHeader("Content-Type", "application/json")
--	res:setHeader("Content-Length", #json_str)
	res:write(json_str)
--	res:finish()
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

http_backend_register('ping', function (res, http_json)
http_response_ok_json(res, "Have a very safe day.")
end)

function onRequest (req, res)

if not (req.method == 'POST') then http_response_error_json(res, "Only POST requests") end

local chunks = {}
local length = 0

local api_url = 

req:on('data', function (chunk)
	p({url = req.url, request=chunk})
	length = length + 1
	chunks[length] = chunk
end)

res:setHeader("Content-Type", "application/json")

req:on('end', function ()
    local body = table.concat(chunks, "")

    local body_json = json.decode(body)

	if body_json == nil then http_response_error_json(res, "Bad json") return end

	if not http_is_api_token(body_json.token) then http_response_error_json(res, "Bad token") return end

	if http_emitter:listeners(req.url)[1] ~= nil then http_emitter:listeners(req.url)[1](res, body_json) else http_response_error_json(res, "No handlers for this path") end
	res:finish()
end)
end

http.createServer(onRequest):listen(listen_port)

require('modules/exec')
require('modules/accounts_link')
require('modules/privilages')
