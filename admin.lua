function exec(msg, cont, args)
	if groups["admin"][msg.author.id] == true then else msg:reply(msg.author.mentionString..' необходим иметь группу `admin`.') return end
	msg.channel:broadcastTyping()
	table.remove(args, 1)
	local cmd = table.concat(args, ' ')
	local handle = io.popen(cmd)
	local result = handle:read('*a')
	msg:reply('```bash\n'..result..'\n```')
	handle:close()
end
