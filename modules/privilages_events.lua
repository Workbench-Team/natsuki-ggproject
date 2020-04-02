privilage_preinit('events')

command_handler.register('scpsleventsprivilage', 'Работа с привилегиями на scp:sl events', "list / set <user> <type> / delete <user>", true, function (msg, argv, args)
	if argv[2] == "list" then msg.channel:send(privilage_list('events')) end

	if argv[2] == "set" then
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local userid = cl:getUser(id).id
		privilage_set('events', userid, argv[4])
		msg:reply('Теперь '..cl:getUser(id).tag..' имеет '..argv[4])
	end

	if argv[2] == "delete" then
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local userid = cl:getUser(id).id
		privilage_delete('events', userid)
		msg:reply('Удалены все роли с '..cl:getUser(id).tag)
	end

end)
