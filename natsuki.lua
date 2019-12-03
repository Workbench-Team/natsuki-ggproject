disc = require('discordia')
cl = disc.Client()
http = require('coro-http')
qs = require('querystring')
json = require('json')
timer = require('timer')
disc.extensions()
pref = '.'
ver = '3.0 dev'



token = json.decode(io.open("token.json", "r"):read("*a"))["value"]
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

	if args[1] == pref..'!' then
		exec(msg, args)
	end

	if args[1] == pref..'help' then
		help(msg)
	end
end)
