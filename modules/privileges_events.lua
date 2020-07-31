	command_handler.register('eventsprivilege', 'Работа с привилегиями на GG Events', "list / add <user> <type> / remove <user> <privilege>", true, function (msg, argv, args)
	if argv[2] == "list" then
		local list = privilege_list('events')
		if #list >= 1999 then
			for i, v in ipairs(split(list, 1999)) do
				msg.channel:send('```\n'..v..'\n```')
			end
		else
			msg.channel:send('```\n'..list..'\n```')
		end
	end

	if argv[2] == "add" then
		local expiry = '-1' -- Пока что без даты окончания
		if msg.guild.id ~= server then return end
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local userid = cl:getUser(id).id
		if not userid then return end
		if not argv[4] then return end
		privilege_add('events', userid, argv[4], expiry)
		msg:reply('Теперь '..cl:getUser(id).tag..' имеет '..argv[4])
	end

	if argv[2] == "remove" then
		if msg.guild.id ~= server then return end
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local userid = cl:getUser(id).id
		if not userid then return end
		if not argv[4] then return end
		privilege_remove('events', userid, argv[4])
		msg:reply(string.format('Удалена роль %s с пользователя %s', argv[4], cl:getUser(id).tag))
	end

end)
