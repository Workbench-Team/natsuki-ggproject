_G.core = require("core")
_G.disc = require('discordia')
_G.cl = _G.disc.Client()
_G.http = require('coro-http')
_G.qs = require('querystring')
_G.json = require('json')
_G.timer = require('timer')
_G.server = '606961070212644894'

--_G.mysql_driver = require("luasql.mysql")
--_G.mysql_env = assert (driver.mysql())

--_G.mysql = require('./luvit-mysql/mysql') --bye bye shit
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

require('groups')
require('modules/list')

cl:on('ready', function()
	cl:setGame {
		type = 3,
		name = pref..'help | under dev'
	}
	cl:setStatus('online')
end)

cl:on('messageCreate',function(msg)
	local logs = cl:getChannel('661166664104148993')
	if msg.channel.type == 1 or msg.channel.type == 3 then
		local cont = msg.content
		string.gsub(cont, '@everyone', 'everyone')
		string.gsub(cont, '@here', 'here')
		logs:send{content='*'..msg.channel.name..'*\n**'..msg.author.tag..'** сказал:\n> '..cont..'\nID канала: '..msg.channel.id..'\nID сообщения: '..msg.id, embed=msg.embed}
		if msg.attachment then
			for i,v in ipairs(msg.attachments) do
				logs:send{content=v.url}
			end
		end
	end
end)
