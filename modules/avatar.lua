function avatar(msg, args)
	if args[2] then
		local id = string.gsub(args[2], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local user = _G.cl:getUser(id)
		if user then
			msg:reply { embed = { description = '[Ссылка на изображение]('..user:getAvatarURL(1024)..')', image = { url = user:getAvatarURL(1024) } } }
		end
	else
		msg:reply { embed = { description = '[Ссылка на изображение]('..msg.author:getAvatarURL(1024)..')', image = { url = msg.author:getAvatarURL(1024) } } }
	end
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')
	if msg.author.bot == true then return end
	if args[1] == _G.pref..'avatar' then
		avatar(msg, args)
	end
end)
