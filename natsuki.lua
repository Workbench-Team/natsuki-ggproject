disc = require('discordia')
cl = disc.Client()
http = require('coro-http')
qs = require('querystring')
json = require('json')
timer = require('timer')
disc.extensions()
pref = '.'
ver = '0.0'



token = json.decode(io.open("token.json", "r"):read("*a"))["value"]
cl:run('Bot'..token)



cl:on('ready' function()
	print(cl.user.tag..' launched')
end)
