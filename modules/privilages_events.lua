command_handler.register('scpsleventsprivilage', 'Работа с привилегиями на scp:sl events', "list / set <user> <type> / delete <user>", true, function (msg, argv, args)
	if argv[2] == "list" then msg.channel:send(privilage_list('events')) end

	if argv[2] == "set" then
		if msg.guild.id ~= server then return end
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local userid = cl:getUser(id).id
		if not userid then return end
		privilage_set('events', userid, argv[4])
		msg:reply('Теперь '..cl:getUser(id).tag..' имеет '..argv[4])
		cl:getChannel('645301914279608350'):send('<@!'..userid..'> - '..argv[4])
	end

	if argv[2] == "delete" then
		if msg.guild.id ~= server then return end
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local userid = cl:getUser(id).id
		if not userid then return end
		privilage_delete('events', userid)
		msg:reply('Удалены все роли с '..cl:getUser(id).tag)
		cl:getChannel('645301914279608350'):getMessages(100):find(function(msg) local argv = msg.content:split(' ') if argv[1] == '<@!'..userid..'>' then msg:delete() return end end)
	end

end)
