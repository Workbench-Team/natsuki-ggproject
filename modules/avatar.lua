command_handler.register('avatar', 'Получить ссылку и изображение на аватарке', nil, false, function (msg, argv, args)
	if argv[2] then
		local id = msg.mentionedUsers.first.id
		local user = cl:getUser(id)
		if user then
			msg:reply { embed = { description = '[Ссылка на изображение]('..user:getAvatarURL(1024)..')', image = { url = user:getAvatarURL(1024) } } }
		end
	else
		msg:reply { embed = { description = '[Ссылка на изображение]('..msg.author:getAvatarURL(1024)..')', image = { url = msg.author:getAvatarURL(1024) } } }
	end
end)
