function trigger(msg, cont)
	local triggers = {['F'] = 'F', ['f'] = 'F', ['дошик'] = '<:vkusno:648966999644438569>', ['Дошик'] = '<:vkusno:648966999644438569>', ['Доширак'] = '<:vkusno:648966999644438569>', ['доширак'] = '<:vkusno:648966999644438569>'}
	if triggers[cont] == nil then return end
	msg:reply(triggers[cont])
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')
	if msg.author.bot == true then return end
	trigger(msg, cont)
end)
