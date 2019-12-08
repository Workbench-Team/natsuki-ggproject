function lhh(msg, args)
	local vc = msg.guild.connection
	if vc then
		local method = args[2]
		if method then
			if method == 'leave' then
				vc:stopStream()
				vc:close()
				msg:reply{embed={description='Я покинула канал '..vc.channel.name}}
			elseif method == 'stop' then
				vc:stopStream()
				msg:reply{embed={description='Останавливаю музыку в канале '..vc.channel.name}}
			elseif method == 'play' then
				msg:reply{embed={description='Начинаю стримить Lofi hip hop музыку в канал '..vc.channel.name}}
				local suc, err = pcall(function()
					return vc:playFFmpeg('http://sv1.ggproject.xyz:8000/lhh')
				end)
				if err == 0 then
					msg:reply{embed={description='Не удалось соединиться с сервером'}}
				end
			else
				msg:reply(msg.author.mentionString..' неизвестная команда, '.._G.pref..'lff для просмотра доступных команд')
			end
		end
	else
		local method = args[2]
		if method then
			if method == 'join' then
				local chnl = msg.member.voiceChannel
				if chnl then
					local vc = chnl:join()
					if vc then
						msg:reply{embed={description='Теперь я в канале '..vc.channel.name}}
					else
						msg:reply{embed={description='Не удалось зайти в канал '..chnl.name..'. Возможно отсутствуют права или нет соединения с Discord API'}}
					end
				else
					msg:reply(msg.author.mentionString..' вы не находитесь в каком либо голосовом канале или у меня нет прав')
				end
			elseif method == 'play' then
				local chnl = msg.member.voiceChannel
				if chnl then
					local vc = chnl:join()
					if vc then
						msg:reply{embed={description='Начинаю стримить Lofi hip hop музыку в канал '..vc.channel.name}}
						local suc, err = pcall(function()
							return vc:playFFmpeg('http://sv1.ggproject.xyz:8000/lhh')
		                                end)
						if err == 0 then
							msg:reply{embed={description='Не удалось соединиться с сервером'}}
						end
					else
						msg:reply{embed={description='Не удалось зайти в канал '..chnl.name..'. Возможно отсутствуют права или нет соединения с Discord API'}}
					end
				else
					msg:reply(msg.author.mentionString..' вы не находитесь в каком либо голосовом канале или у меня нет прав')
				end
			else
				msg:reply(msg.author.mentionString..' неизвестная команда, '.._G.pref..'lff для просмотра доступных команд')
			end
		end
	end
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')
	if args[1] == _G.pref..'lhh' then
		if msg.channelType == 1 or msg.channelType == 3 then return end
		if args[2] then
			lhh(msg, args)
		else
			msg:reply{embed={description='Помощь будет написана позже\nДоступные команды: play, stop, join, leave'}}
		end
	end
end)
