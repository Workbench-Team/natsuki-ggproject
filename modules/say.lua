command_handler.register('say', 'Сказать <text>', '<text>', false, function (msg, argv, args)
	msg.channel:broadcastTyping()
	table.remove(argv, 1)
	for k, v in pairs(argv) do
		if v == '@everyone' or v == '@here' then
			msg:reply('Упоминание всех запрещёно')
			return
		end
	end
	msg:reply(table.concat(argv, ' '))
end)

command_handler.register('sayd', 'Сказать <text> и удалить ваше сообщение', '<text>', false, function (msg, argv, args)
	msg.channel:broadcastTyping()
	table.remove(argv, 1)
	for k, v in pairs(argv) do
		if v == '@everyone' or v == '@here' then
			msg:reply('Упоминание всех запрещено')
			return
		end
	end
	msg:reply(table.concat(argv, ' '))
	msg:delete()
end)
