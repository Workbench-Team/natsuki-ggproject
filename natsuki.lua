_G.core = require("core")
_G.disc = require('discordia')
_G.cl = _G.disc.Client()
_G.http = require('coro-http')
_G.qs = require('querystring')
_G.json = require('json')
_G.timer = require('timer')
_G.server = '606961070212644894'

_G.mysql = require('./third_party/luajit_mysql.lua')
require('./third_party/embed.lua')

_G.uv = require('uv')
disc.extensions()

_G.pref = 'n/'
_G.config = json.decode(io.open("config.json", "r"):read("*a"))

token = config["token"]
cl:run('Bot '..token)

_G.backend_token = config["backend_token"]
_G.backend_url = config["backend_url"]
_G.data = {["token"] = backend_token}
_G.data_backup = {["token"] = backend_token}

require('groups')
require('modules/list')

cl:on('ready', function()
	cl:setGame {
		type = 3,
		name = pref..'help | under dev'
	}
	cl:setStatus('online')
end)

cl:on('messageCreate', function(msg)
	local logs = cl:getChannel('661166664104148993')
	if msg.channel.type == 1 or msg.channel.type == 3 then
		local cont = msg.content
		cont = string.gsub(cont, '@', '')
		logs:send{content='*'..msg.channel.name..'*\n**'..msg.author.tag..'** сказал:\n> '..cont..'\nID автора: '..msg.author.id..'\nID сообщения: '..msg.id, embed=msg.embed}
		if msg.attachment then
			for i,v in ipairs(msg.attachments) do
				logs:send{content=v.url}
			end
		end
	end
	if msg.channel.id == logs.id then
		if msg.author.id == cl.user.id then return end
		local tbl = msg.content:split(' ')
		if not tbl[1] then return end
		local channel = cl:getUser(tbl[1])
		if not channel then return end
		table.remove(tbl, 1)
		channel:send(table.concat(tbl, ' '))
	end
end)

cl:on('messageUpdate', function(msg)
	local logs = cl:getChannel('661166664104148993')
	if msg.channel.type == 1 or msg.channel.type == 3 then
		local cont = msg.content
		string.gsub(cont, '@', '`@`')
		logs:send{content='*'..msg.channel.name..'*\n**'..msg.author.tag..'** изменил сообщение:\n> '..cont..'\nID канала: '..msg.channel.id..'\nID сообщения: '..msg.id, embed=msg.embed}
	end
end)
