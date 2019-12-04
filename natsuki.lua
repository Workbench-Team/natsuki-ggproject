disc = require('discordia')
cl = disc.Client()
_G.http = require('coro-http')
qs = require('querystring')
_G.json = require('json')
timer = require('timer')
disc.extensions()
pref = '.'
ver = '3.0 dev'



token = _G.json.decode(io.open("token.json", "r"):read("*a"))["value"]
cl:run('Bot '..token)



require('admin')
require('groups')
require('modules/list')


cl:on('ready', function()
	print(cl.user.tag..' launched')
	cl:setGame {
		type = 3,
		name = ver
	}
end)

cl:on('messageCreate', function(msg)
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
		nekos(msg, args, cl, disc)
	end
end)
