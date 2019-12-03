function exec(msg, args)
	local alwd_g = {['admin'] = true, ['owner'] = true}
	local user_g = groups[msg.author.id]
	if alwd_g[user_g] == true then
		msg.channel:broadcastTyping()
		table.remove(args, 1)
		local cmd = table.concat(args, ' ')
		msg:reply('prbrain@sv1:~/natsuki$ '..cmd)
		msg.channel:broadcastTyping()
		local handle = io.popen(cmd)
		local result = handle:read('*a')
		msg:reply(result)
		handle:close()
	else
		msg:reply(msg.author.mentionString..' необходимо иметь группу `admin` или `owner`.')
	end
end
