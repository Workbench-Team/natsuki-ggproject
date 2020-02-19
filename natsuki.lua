_G.disc = require('discordia')
_G.cl = _G.disc.Client()
_G.http = require('coro-http')
_G.qs = require('querystring')
_G.json = require('json')
_G.timer = require('timer')
disc.extensions()
_G.pref = 'n/'
_G.ver = '3.0 dev'



token = json.decode(io.open("config.json", "r"):read("*a"))["value"]
cl:run('Bot '..token)



require('admin')
require('groups')
require('modules/list')


cl:on('ready', function()
	cl:setGame {
		type = 3,
		name = ver..' | '..pref..'help'
	}
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
