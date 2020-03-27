_G.core = require("core")
_G.disc = require('discordia')
_G.cl = _G.disc.Client()
_G.http = require('coro-http')
_G.qs = require('querystring')
_G.json = require('json')
_G.timer = require('timer')

--_G.mysql_driver = require("luasql.mysql")
--_G.mysql_env = assert (driver.mysql())

--_G.mysql = require('./luvit-mysql/mysql') --bye bye shit
_G.mysql = require('./third_party/luajit_mysql.lua')
require('./third_party/embed.lua')

_G.uv = require('uv')
disc.extensions()

_G.pref = 'n/'
_G.ver = '3.0.2.7 dev'
_G.config = json.decode(io.open("config.json", "r"):read("*a"))

token = config["token"]
cl:run('Bot '..token)

require('groups')
require('modules/list')

cl:on('ready', function()
	cl:setGame {
		type = 3,
		name = ver..' | '..pref..'help'
	}
	cl.guilds:forEach(function(guild) if guild.id ~= '606961070212644894' then guild:leave() end end)
end)

cl:on('messageCreate',function(msg)
	local logs = cl:getChannel('661166664104148993')
	if msg.channel.type == 1 or msg.channel.type == 3 then
		logs:send{content='*'..msg.channel.name..'*\n**'..msg.author.tag..'** сказал:\n> '..msg.content, embed=msg.embed}
		if msg.attachment then
			for i,v in ipairs(msg.attachments) do
				logs:send{content=v.url}
			end
		end
	end
end)
