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
		['eventsadmin'] = '```Markdown\n# Форма подачи заявки для админа:\n1. Ваш ник\n2. Ссылка на ваш профиль Steam\n3. Имеется ли у вас опыт в админке, или хотя бы умение ей пользоваться\n4. Сколько часов у вас наиграно в игре?\n5. Вы точно уверены в том, что вы сможете командовать игрокам и знаете много ивентов?\n6. Почему вы хотите стать именно этим администратором на нашем сервере.\n7. Какой примерно ваш рабочий день будет на сервере по МСК времени?\n8. Выберите, кем вы хотели бы быть, в скобках требования:\n* Помощник (иметь админку с 3 рангом, 150 часов, 10 лвл в дс и 0 ошибок)\n* Ивент админ (100 часов, 5 лвл в дс и 2 ошибки)\n* Охранник (30 часов, 3 лвл в дс и 4 ошибки)\n# Вы будете проходить проверку на 15 вопросов по правилам и ивентам (20 на помощника)! При проверке правила перечитывать с дискорда строго запрещено, карается запретом стать администратором\n```\nДля получения админки вам нужно привязать ваш Discord к Steam: https://discordapp.com/channels/606961070212644894/621800645283938305/685137202740723864',
		['report'] = '```Markdown\n# Форма подачи жалобы на игрока/пользователя:\n1. ID обвиняемого игрока/пользователя или ник\n2. Причина и описание обвинения\n3. Доказательства изображением или ссылкой (если нужны)\n```',
		['offering'] = '```Markdown\n# Форма подачи предложения:\n1. Что вы бы хотели нам предложить?\n2. Содержание предложения\n3. Скриншоты для примера, где это есть на других серверах/проектах (если нужно)\n```',
		['unban'] = '```Markdown\n# Форма подачи заявки на разбан/размут:\n1. Ваш ник в игре (если в игре)\n2. Ник администратора, то есть кем выдано\n3. Причина выдачи администратором\n4. Почему мы должны вас разбанить/размутить?\n5. Доказательства (если нужны)```',
		['reportbug'] = '```md\n# Форма для заполнения:\n1. Какую дыру или баг вы нашли и как можно это воспроизвести?\n2. Когда вы его нашли и кто о нём знал?\n3. Если знаете, предложите, как можно это исправить\n```',
	}
	local embed = Embed:new(msg, 'Меню, правила и форма обращения', 'Для того, чтобы закрыть обращение, поставьте реакцию ❌ (или напишите ❌, если не закрывается с помощью реакции). Закрывайте обращение только тогда, когда оно действительно закончено и больше не требует обсуждений, либо если в нём не соблюдены требуемые условия и правила. Ниже будет написана форма обращения и его тип', 4886754, {{name=type, value=infos[type]}})
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
	if msg.channel.category then
		if msg.channel.category.id == category then
			if msg.content == '❌' then
				closeappeals(msg.author, msg.channel)
			end
		end
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
	if not channel.category then return end
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
	local embed = { title='**Подробнее о системе обращений**', description='**Для начала нового обращения, вы можете написать один из типов обращений ниже\nВ самих, уже созданных, обращениях (отдельный текстовый канал) вы найдёте все требования, команды и форму, которые напишу вам я\nТакже в обращении будет меню для управления обращением, через которое вы сможете закрыть обращение (безвозвратно удалит канал с обращением)\nПравила обращений:\n1. Создавайте только одно обращение с одной темой, не создавайте их по несколько раз, одного обращения вполне достаточно\n2. Если ответа не поступит в течение дня, вы можете пингануть 1 раз администрацию, которая требуется для проверки обращения\n3. Если обращение не принадлежит вам, пожалуйста, не трогайте и не закрывайте его без разрешения\n4. Пожалуйста, после создания обращения, напишите его суть/содержание/причину в течение часа, иначе оно будет закрыто без спроса**', fields={{name='eventsadmin', value='GG Events - заявление на администратора'}, {name='report', value='Жалоба на игрока/администратора'}, {name='offering', value='Предложение чего-либо по сотрудничеству/серверу/мероприятию к GG Events и др.'}, {name='unban', value='Запрос разбана/размута'}, {name='reportbug', value='Сообщить о дыре или баге'}, }, color=16098851 }
	message:setContent('')
	message:setEmbed(embed)
end)
