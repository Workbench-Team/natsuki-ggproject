function help(msg)
	local table = {
		title = '**Бот в разработке**',
		description = '**[Ссылка на GitHub страницу](https://github.com/ProfessorBrain/natsuki)\n[Ссылка на приглашение бота](https://discordapp.com/oauth2/authorize?client_id=651411296050216975&scope=bot&permissions=0)**',
		author = {
			icon_url = msg.author.avatarURL,
			name = msg.author.tag
		},
		footer = {
			icon_url = _G.cl.user.avatarURL,
			text = _G.cl.user.tag
		},
		color = 3586419,
		fields = {
			{name=_G.pref..'help',value='Выводит помощь по командам'},
			{name=_G.pref..'nekos',value='NSFW и SFW картинки с сайта nekos.life'},
			{name=_G.pref..'say[d] <text>',value='Сказать <text>\nd - удалить ваше сообщение'},
			{name=_G.pref..'fox',value='Картинки с лисичками :3'},
			{name=_G.pref..'avatar [User]',value='Получить ссылку и изображение на аватарке'},
			{name=_G.pref..'lhh',value='Lofi Hip Hop музыка'},
		},
		timestamp = _G.disc.Date():toISO('T', 'Z')
	}
	msg:reply { embed = table }
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
        local args = cont:split(' ')
        if msg.author.bot == true then return end
	if msg.channel == '660906542169849878' then return end
        if args[1] == _G.pref..'help' then
                help(msg)
        end
end)
