function exec(msg, args)
	if msg.guild.id ~= '606961070212644894' then return end
	local alwd_g = {['admin'] = true, ['owner'] = true}
	local user_g = groups[msg.author.id]
	if alwd_g[user_g] == true then
		msg.channel:broadcastTyping()
		table.remove(args, 1)
		local cmd = table.concat(args, ' ')
		local handle = io.popen(cmd)
		local result = handle:read('*a')
		io.open('result.txt', 'w'):write(result):close()
		local message = msg:reply { embed = { title = 'prbrain@sv1:~/natsuki$ '..cmd, description = result } }
		if message == nil then msg:reply { embed = { title = 'Ошибка', description = 'Запрос слишком большой или не заканчивается' }, file = 'result.txt' } end
		handle:close()
		print(msg.author.tag..' : '..cmd..'\nResult: '..result)
	else
		msg:reply(msg.author.mentionString..' необходимо иметь группу `admin` или `owner`.')
	end
end
_G.cl:on('messageCreate', function(msg) 
	local cont = msg.content
        local args = cont:split(' ')
        if msg.author.bot == true then return end
        if args[1] == _G.pref..'!' then
                exec(msg, args)
	end
end)
