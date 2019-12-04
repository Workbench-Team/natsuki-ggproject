function help(msg)
	local table = {
		title = '**Бот в разработке**',
		description = '**[Ссылка на GitHub страницу](https://github.com/ProfessorBrain/natsuki)**',
		fields = {
			{name=_G.pref..'help',value='Выводит помощь по командам'},
			{name=_G.pref..'img',value='NSFW и SFW картинки с сайта nekos.life'},
			{name=_G.pref..'say[d] <text>',value='Сказать <text>\nd - удалить ваше сообщение'}
		}
	}
	msg:reply { embed = table }
end
