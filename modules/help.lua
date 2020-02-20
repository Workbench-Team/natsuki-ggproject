function help(msg)
	local table = {
		title = '**Бот в разработке**',
		description = '**[Ссылка на GitHub страницу](https://github.com/ProfessorBrain/natsuki)\n[Ссылка на приглашение бота](https://discordapp.com/oauth2/authorize?client_id=651411296050216975&scope=bot&permissions=8192)**',
		author = {
			icon_url = msg.author.avatarURL,
			name = msg.author.tag
		},
		footer = {
			icon_url = cl.user.avatarURL,
			text = cl.user.tag
		},
		color = 3586419,
		fields = {
			{name=pref..'help',value='Выводит помощь по командам'},
			{name=pref..'nekos',value='NSFW и SFW картинки с сайта nekos.life'},
			{name=pref..'say[d] <text>',value='Сказать <text>\nd - удалить ваше сообщение'},
			{name=pref..'fox',value='Картинки с лисичками :3'},
			{name=pref..'avatar [User]',value='Получить ссылку и изображение на аватарке'},
			{name=pref..'lhh',value='Lofi Hip Hop музыка'},
		},
		timestamp = disc.Date():toISO('T', 'Z')
	}
	msg:reply { embed = table }
end
cl:on('messageCreate', function(msg)
	local cont = msg.content
        local args = cont:split(' ')
        if msg.author.bot == true then return end
	if msg.channel == '660906542169849878' then return end
        if args[1] == pref..'help' then
                help(msg)
        end
end)
