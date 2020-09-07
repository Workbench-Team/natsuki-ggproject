local channel = '660906542169849878'
local message = '693027550578081855'
local category = '627248436525400084'
local logs = '607240980923416576'

function createappeals(msg)
	msg.channel:broadcastTyping()
	local types = {'eventsadmin', 'report', 'offering', 'unban', 'reportbug'}
	local type = nil
	for k,v in pairs(types) do
		if msg.content == v then
			type = v
		end
	end
	if type == nil then local temp = msg:reply(msg.author.mentionString..' неправильно указан тип обращения `'..msg.content..'`. Пожалуйста, прочитайте информацию выше') timer.sleep(10000) temp:delete() msg:delete() return end
	local appeal, err = cl:getChannel(category):createTextChannel(type..'_'..msg.createdAt)
	if not appeal then
		print(err)
		msg:delete()
		local temp = msg:reply(msg.author.mentionString..' произошла техническая ошибка, повторите, пожалуйста, позже')
		timer.sleep(10000)
		temp:delete()
		return
	end
	logs:send(msg.author.tag..' создал обращение '..appeal.name)
	local infos = {
		['eventsadmin'] = '```Markdown\n# Форма подачи заявки для админа:\n1. Ваш ник\n2. Ссылка на ваш профиль Steam\n3. Имеется ли у вас опыт в админке, или хотя бы умение ей пользоваться?\n4. Вы точно уверены в том, что вы сможете командовать игрокам и знаете много ивентов?\n5. Почему вы хотите стать админом?\n6. Какой примерно ваш рабочий день будет на сервере по МСК времени?\n\n# Вы подаёте заявку на Ивент админа, для которого требуется 100 часов в игре. Если вы уже им являетесь, то на Помощника, 150 часов в игре и иметь месячный стаж работы Ивент админа\n\n# Вы будете проходить проверку на 15 вопросов по правилам и ивентам (20 на помощника)! Максимум ошибок: Ивент админ - 3, Помощник - 1! Перечитывание правил во время проверки карается запретом админки\n```\nДля получения админки вам нужно привязать ваш Discord к Steam: https://discordapp.com/channels/606961070212644894/621800645283938305/685137202740723864',
		['report'] = '```Markdown\n# Форма подачи жалобы на игрока/пользователя:\n1. ID обвиняемого игрока/пользователя или ник\n2. Причина и описание обвинения\n3. Доказательства изображением или ссылкой (если нужны)\n```',
		['offering'] = '```Markdown\n# Форма подачи предложения:\n1. Что вы бы хотели нам предложить?\n2. Содержание предложения\n3. Скриншоты для примера, где это есть на других серверах/проектах (если нужно)\n```',
		['unban'] = '```Markdown\n# Форма подачи заявки на разбан/размут:\n1. Ваш ник в игре (если в игре)\n2. Ник администратора, то есть кем выдано\n3. Причина выдачи администратором\n4. Почему мы должны вас разбанить/размутить?\n5. Доказательства (если нужны)```',
		['reportbug'] = '```md\n# Форма для заполнения:\n1. Какую дыру или баг вы нашли и как можно это воспроизвести?\n2. Когда вы его нашли и кто о нём знал?\n3. Если знаете, предложите, как можно это исправить\n```',
	}
	local embed = Embed:new(msg, 'Меню, правила и форма обращения', 'Для того, чтобы закрыть обращение, поставьте реакцию ❌. Закрывайте обращение только тогда, когда оно действительно закончено и больше не требует обсуждений, либо если в нём не соблюдены требуемые условия и правила. Ниже будет написана форма обращения и его тип', 4886754, {{name=type, value=infos[type]}})
	local appealmenu, err = appeal:send{content='<@!'..msg.author.id..'>', embed=embed:get()}
	if not appealmenu then
		local temp = msg:reply(msg.author.mentionString..' к сожалению произошла техническая ошибка во время создания обращения. Попробуйте в следующий раз')
		timer.sleep(10000)
		msg:delete()
		temp:delete()
		return
	end
	appealmenu:pin()
	appealmenu:addReaction('❌')
	appeal:getPermissionOverwriteFor(msg.member):allowPermissions(0x00000400)
	if type == 'eventsadmin' then
		appeal:getPermissionOverwriteFor(cl:getRole('628295268911284225')):delete()
		appeal:getPermissionOverwriteFor(cl:getRole('639003693227704331')):delete()
		appeal:getPermissionOverwriteFor(cl:getRole('627161428989837312')):delete()
		appeal:getPermissionOverwriteFor(cl:getRole('627161097182642176')):delete()
	end
	local temp = msg:reply(msg.author.mentionString..' ваше обращение создано в канале <#'..appeal.id..'> (кликабельно)')
	timer.sleep(10000)
	temp:delete()
	msg:delete()
end

function closeappeals(user, chnl)
	chnl:delete()
	logs:send(user.tag..' закрыл обращение '..chnl.name)
end

cl:on('messageCreate', function(msg)
	if msg.channel.id == channel and msg.author ~= cl.user then
		createappeals(msg)
	end
end)

cl:on('reactionAdd', function(react, userid)
	if not react.message.channel.category then return end
	if react.message.channel.category.id == category and userid ~= cl.user.id then
		local user = cl:getUser(userid)
		local chnl = react.message.channel
		if react.emojiHash ~= '❌' then return end
		closeappeals(user, chnl)
	end
end)
cl:on('reactionAddUncached', function(chnl, msgid, hash, userid)
	if not chnl.category then return end
	if chnl.category.id == category and userid ~= cl.user.id then
		local user = cl:getUser(userid)
		if hash ~= '❌' then return end
		closeappeals(user, chnl)
	end
end)

cl:on('ready', function()
	logs = cl:getChannel(logs)
	cl:getChannel(channel):getMessages():forEach(function(msg) if msg.id ~= message then msg:delete() end end)
--	cl:getChannel(channel):send{embed={title='title'}, content='content'}
	local message = cl:getChannel(channel):getMessage(message)
	local embed = { title='**Информация о системе обращений**', description='**Для начала нового обращения, вы можете написать один из типов обращений ниже\nВ самих, уже созданных, обращениях (отдельный текстовый канал) вы найдёте все требования, команды и форму, которые напишу вам я\nТакже в обращении будет меню для управления обращением, через которое вы сможете закрыть обращение (безвозвратно удалит канал с обращением)**', fields={{name='**eventsadmin**', value='GG Events - заявление на администратора'}, {name='**report**', value='Жалоба на игрока/администратора'}, {name='**offering**', value='Предложение чего-либо по сотрудничеству/серверу/мероприятию к GG Events и др.'}, {name='**unban**', value='Запрос разбана/размута'}, {name='**reportbug**', value='Сообщить о дыре или баге'}, }, color=16098851 }
	message:setContent('')
	message:setEmbed(embed)
end)
