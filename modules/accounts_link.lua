local method = 'account/'

function account_set_link(userid, account_type, account)
	if account_is_account_id(account_type) == false then return false end
	local method = method..'link'
	data["userid"] = userid
	data["type"] = account_type
	data["account"] = account
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function account_get_link(userid, account_type)
	if account_is_account_id(account_type) == false then return false end
	local method = method..'get'
	data["userid"] = userid
	data["type"] = account_type
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function account_del_link(userid, account_type)
	if account_is_account_id(account_type) == false then return false end
	local method = method..'unlink'
	data["userid"] = userid
	data["type"] = account_type
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function account_is_account_id(account_type)
	types = {'steam64id'}
	for k, v in pairs(types) do
		if account_type == v then return true end
	end
	return false
end

command_handler.register('accountlink', 'Привязка других аккаунтов к Discord аккаунту по id. Доступно для связывания: Steam в формате steamid64', '<type> <id>', false, function(msg, argv, args)
	if msg.guild.id ~= server then return end
	if not argv[2] then msg:reply('Нету типа для связывания! Доступные типы: Steam') return end
	if not argv[3] then msg:reply('Нету id для связывания! Напишите после типа') return end
	local steam64id_aliases = {'steam', 'steamid64', 'steamid', 'steam64id', 'стим', 'стимид'}
	local type = ''
	for k, v in pairs(steam64id_aliases) do
		if argv[2] == v then type = 'steam64id' end
	end
	if type == '' then msg:reply(string.format('Не найден тип связывания `%s`. Доступно для связывания: Steam в формате steamid64', argv[2])) return end
	local result = account_set_link(msg.author.id, type, argv[3])
	if result ~= 'ok' then msg:reply('Произошла ошибка. Проверьте правильность аргументов') return end
	msg:reply(string.format('К вашему Discord аккаунту привязан %s с таким уникальным идентификатором: %s', type, argv[3]))
end)

command_handler.register('adminaccountlink', 'Связывает userid Discord с другими порталами в бд проекта', nil, true, function (msg, argv, args)
	if msg.guild.id ~= server then return end
	if not argv[2] then msg:reply('Нету пользователя для связывания! Укажите id или упомяните пользователя') return end
	if not argv[3] then msg:reply('Нету типа для связывания! Доступные типы: Steam') return end
	if not argv[4] then msg:reply('Нету id для связывания! Напишите после типа') return end
	local id = string.gsub(argv[2], '@', '')
	id = string.gsub(id, '<', '')
	id = string.gsub(id, '>', '')
	id = string.gsub(id, '!', '')
	local user = cl:getUser(id)
	if not user then msg:reply('Не найден указанный пользователь') return end
	local steam64id_aliases = {'steam', 'steamid64', 'steamid', 'steam64id', 'стим', 'стимид'}
	local type = ''
	for k, v in pairs(steam64id_aliases) do
		if argv[3] == v then type = 'steam64id' end
	end
	if type == '' then msg:reply(string.format('Не найден тип связывания `%s`. Доступно для связывания: Steam в формате steamid64', argv[3])) return end
	local result = account_set_link(user.id, type, argv[4])
	if result ~= 'ok' then msg:reply('Произошла ошибка. Проверьте правильность аргументов') return end
	msg:reply(string.format('Для %s привязан %s с уникальным идентификатором %s\n', user.tag, type, argv[4]))
end)

command_handler.register('getlinkedaccount', 'Выводит ваши привязанные id. Доступные типы: Steam в формате steamid64', '<type> [mention]', false, function(msg, argv, args)
	if msg.guild.id ~= server then return end
	if not argv[2] then msg:reply('Нету типа для вывода id! Доступные типы: Steam') return end
	local steam64id_aliases = {'steam', 'steamid64', 'steamid', 'steam64id', 'стим', 'стимид'}
	local type = ''
	for k, v in pairs(steam64id_aliases) do
		if argv[2] == v then type = 'steam64id' end
	end
	if type == '' then msg:reply(string.format('Не найден тип `%s`. Доступно для связывания: Steam в формате steamid64', argv[2])) return end
	if argv[3] then
		local id = string.gsub(argv[3], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		local user = cl:getUser(id)
		if not user then msg:reply('Не найден указанный пользователь') return end
		local result = account_get_link(user.id, type)
		if result == 'no account linked with userid' then msg:reply(string.format('У пользователя %s отсутствует привязанный аккаунт типа %s', user.tag, type)) return end
		msg:reply(string.format('%s пользователя %s: %s', type, user.tag, result))
	else
		local result = account_get_link(msg.author.id, type)
		if result == 'no account linked with userid' then msg:reply(string.format('У вас отсутствует привязанный аккаунт типа %s', type)) return end
		msg:reply(string.format('Ваш %s: %s', type, result))
	end
end)

command_handler.register('unlink', 'Отвязывание привязанного аккаунта. Доступные типы: Steam в формате steamid64', '<type>', false, function(msg, argv, args)
	if msg.guild.id ~= server then return end
	if not argv[2] then msg:reply('Не указан тип для отвязывания! Доступные типы: Steam') return end
	local steam64id_aliases = {'steam', 'steamid64', 'steamid', 'steam64id', 'стим', 'стимид'}
        local type = ''
        for k, v in pairs(steam64id_aliases) do
                if argv[2] == v then type = 'steam64id' end
        end
        if type == '' then msg:reply(string.format('Не найден тип для отвязывания `%s`. Доступно для отвязывания: Steam в формате steamid64', argv[2])) return end
	local result = account_del_link(msg.author.id, type)
	if result ~= 'ok' then msg:reply('Произошла ошибка. Проверьте правильность аргументов') return end
	msg:reply(string.format('От вашего аккаунта отвязан %s', type))
end)
