_G.disc = require('discordia')
_G.cl = _G.disc.Client()
_G.http = require('coro-http')
_G.qs = require('querystring')
_G.json = require('json')
_G.timer = require('timer')
disc.extensions()
_G.pref = '.'
_G.ver = '3.0 dev'



token = _G.json.decode(io.open("token.json", "r"):read("*a"))["value"]
_G.cl:run('Bot '..token)



require('admin')
require('groups')
require('modules/list')


_G.cl:on('ready', function()
	print(_G.cl.user.tag..' launched')
	_G.cl:setGame {
		type = 3,
		name = ver
	}
end)

_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')

	if msg.author.bot == true then return end

	if args[1] == pref..'!' then
		exec(msg, args)
	end

	if args[1] == pref..'help' then
		help(msg)
	end

	if args[1] == pref..'say' then
		local d = false
		say(msg, args, d)
	elseif args[1] == pref..'sayd' then
		local d = true
		say(msg, args, d)
	end

	if args[1] == pref..'img' then
		nekos(msg, args)
	end

	if args[1] == pref..'fox' then
		fox(msg, args)
	end
end)
