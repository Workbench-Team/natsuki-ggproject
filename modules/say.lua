command_handler.register('say', 'Сказать <text>', '<text>', false, function (msg, argv, args)
	msg.channel:broadcastTyping()
	table.remove(argv, 1)
	for k, v in pairs(argv) do
		string.gsub(argv, '@everyone', 'everyone')
		string.gsub(argv, '@here', 'here')
	end
	msg:reply(table.concat(argv, ' '))
end)

command_handler.register('sayd', 'Сказать <text> и удалить ваше сообщение', '<text>', false, function (msg, argv, args)
	msg.channel:broadcastTyping()
	table.remove(argv, 1)
	for k, v in pairs(argv) do
		string.gsub(argv, '@everyone', 'everyone')
		string.gsub(argv, '@here', 'here')
	end
	msg:reply(table.concat(argv, ' '))
	msg:delete()
end)
