function lhh(msg, args)
	if not msg.member then return end
	local vc = msg.guild.connection
	if vc then
		local method = args[2]
		if method then
			if method == 'leave' then
				vc:stopStream()
				vc:close()
				msg:reply{embed={description='Я покинула канал '..vc.channel.name,color=5447430,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
			elseif method == 'stop' then
				vc:stopStream()
				msg:reply{embed={description='Останавливаю музыку в канале '..vc.channel.name,color=5447430,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
			elseif method == 'play' then
				msg:reply{embed={description='Начинаю стримить Lofi hip hop музыку в канал '..vc.channel.name,color=8311585,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
				local suc, err = pcall(function()
					return vc:playFFmpeg('http://127.0.0.1:8000/lhh')
				end)
				if err == 0 then
					msg:reply{embed={description='Не удалось соединиться с сервером',color=13632027,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
				end
			else
				msg:reply(msg.author.mentionString..' неизвестная команда, '.._G.pref..'lhh для просмотра доступных команд')
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
						msg:reply{embed={description='Теперь я в канале '..vc.channel.name,color=8311585,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
					else
						msg:reply{embed={description='Не удалось зайти в канал '..chnl.name..'. Возможно отсутствуют права или нет соединения с Discord API',color=13632027,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
					end
				else
					msg:reply(msg.author.mentionString..' вы не находитесь в каком либо голосовом канале или у меня нет прав')
				end
			elseif method == 'play' then
				local chnl = msg.member.voiceChannel
				if chnl then
					local vc = chnl:join()
					if vc then
						msg:reply{embed={description='Начинаю стримить Lofi hip hop музыку в канал '..vc.channel.name,color=8311585,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
						local suc, err = pcall(function()
							return vc:playFFmpeg('http://127.0.0.1:8000/lhh')
		                                end)
						if err == 0 then
							msg:reply{embed={description='Не удалось соединиться с сервером',color=13632027,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
						end
					else
						msg:reply{embed={description='Не удалось зайти в канал '..chnl.name..'. Возможно отсутствуют права или нет соединения с Discord API',color=13632027,footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z')}}
					end
				else
					msg:reply(msg.author.mentionString..' вы не находитесь в каком либо голосовом канале или у меня нет прав')
				end
			else
				msg:reply(msg.author.mentionString..' неизвестная команда, '.._G.pref..'lhh для просмотра доступных команд')
			end
		end
	end
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')
	if msg.author.bot == true then return end
	if msg.channel == '660906542169849878' then return end
	if args[1] == _G.pref..'lhh' then
		if msg.channelType == 1 or msg.channelType == 3 then return end
		if args[2] then
			lhh(msg, args)
		else
			msg:reply{embed={description=_G.pref..'lhh - модуль воспроизведения Lofi hip hop музыки в любой голосовой канал\nКогда-нибудь этих команд будет больше\nДоступные команды:',fields={{name='join',value='Зайти в голосовой канал'},{name='leave',value='Покинуть голосовой канал'},{name='play',value='Начать воспроизведение музыки Lofi hip hop'},{name='stop',value='Остановить воспроизведение'},{name='Примеры исользования этих команд',value=_G.pref..'lhh play - воспроизведёт музыку в канале, в котором бот находится или подключится и воспроизведёт там, где находится пользователь\n'.._G.pref..'lhh leave - Бот остановит транслирование и покинет канал'}},footer={text='Requested by '..msg.author.tag,icon_url=msg.author.avatarURL},timestamp=_G.disc.Date():toISO('T', 'Z'),color=14538918}}
		end
	end
end)
