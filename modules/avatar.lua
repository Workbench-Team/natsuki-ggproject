command_handler.register('avatar', 'Получить ссылку и изображение на аватарке', nil, false, function (msg, argv, args)
	if argv[2] then
		local user = msg.mentionedUsers.first or cl:getUser(argv[2])
		if user then
			msg:reply { embed = { description = '[Ссылка на изображение]('..user:getAvatarURL(1024)..')', image = { url = user:getAvatarURL(1024) } } }
		end
	else
		msg:reply { embed = { description = '[Ссылка на изображение]('..msg.author:getAvatarURL(1024)..')', image = { url = msg.author:getAvatarURL(1024) } } }
	end
end)
