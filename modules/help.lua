function help(msg)
	local table = {
		title = 'Бот в разработке',
		description = '**[Ссылка на GitHub страницу](https://github.com/ProfessorBrain/natsuki)**'
	}
	msg:reply { embed = table }
end
