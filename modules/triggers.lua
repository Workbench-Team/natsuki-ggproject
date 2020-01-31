function trigger(msg, cont)
	local triggers = {['F'] = 'F', ['f'] = 'F', ['дошик'] = '<:vkusno:648966999644438569>', ['Дошик'] = '<:vkusno:648966999644438569>', ['Доширак'] = '<:vkusno:648966999644438569>', ['доширак'] = '<:vkusno:648966999644438569>', ['Справедливо'] = '<:spravedlivo:607524570873724938>', ['справедливо'] = '<:spravedlivo:607524570873724938>', ['Справебыдло'] = '<:spravedlivo:607524570873724938>', ['справебыдло'] = '<:spravedlivo:607524570873724938>', ['Гы'] = '<:yyy:671614286807695361>', ['гы'] = '<:yyy:671614286807695361>', ['Ы'] = '<:yyy:671614286807695361>', ['ы'] = '<:yyy:671614286807695361>', ['Хы'] = '<:yyy:671614286807695361>', ['хы'] = '<:yyy:671614286807695361>'}
	if triggers[cont] == nil then return end
	msg:reply(triggers[cont])
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')
	if msg.author.bot == true then return end
	if msg.channel == '660906542169849878' then return end
	trigger(msg, cont)
end)
