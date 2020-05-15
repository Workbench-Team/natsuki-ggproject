local mysql_host = config['mysql_db_host']
local mysql_port = config['mysql_db_port']
local mysql_user = config['mysql_db_user']
local mysql_password = config['mysql_db_password']
local mysql_db_name = config['mysql_db_name']

local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( 'CREATE TABLE IF NOT EXISTS discord_steam64id_link(userid VARCHAR(255) PRIMARY KEY, account VARCHAR(255) NOT NULL)')
mysql_db:close()

function account_set_link(userid, account_type, account)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if account_type == "steam64id" then mysql_db:query( string.format("INSERT INTO discord_steam64id_link ( userid, account ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE account = '%s'", userid, mysql.escape(account), mysql.escape(account)) ) end
mysql_db:close()
end

function account_get_link(userid, account_type, account)
local result = nil
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if account_type == "steam64id" then result = mysql_db:query( string.format("SELECT account FROM discord_steam64id_link WHERE userid = '%s'", userid) ) end
if result[1] == nil then return nil else return result[1].account end
mysql_db:close()
end

function account_in_db(userid, account_type)
	local result
	local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	if account_type == "steam64id" then result = mysql_db:query( string.format("SELECT account FROM discord_steam64id_link WHERE userid = '%s'", userid) ) end
	mysql_db:close()
	return not result[1] == nil
end

function account_is_account_id(account_type)
	if account_type == "steam64id" then return true end
end

command_handler.register('accountlink', 'Связывает userid Discord с другими порталами в бд проекта. Типы для связывания: Steam, писать в форме steam64id', '<type> <id>', false, function (msg, argv, args)
	local userid = msg.author.id
	if not argv[2] or not account_is_account_id(argv[2]) then msg.channel:send("Нету типа для связывания! Доступные типы: steam64id") return end
	if not argv[3] then msg.channel:send("Нету айди для связывания! Для типа steam64id нужно указать ваш уникальный идентификатор steam аккаунта используя сайт http://steamid.io") return end
	if account_in_db(userid, argv[2]) then msg.channel:send("TODO") end

	account_set_link(userid, argv[2], argv[3])

	local output = string.format('К вашему аккаунту привязан %s с таким уникальным идентификатором %s\n', argv[2], argv[3])
	msg.channel:send(output)
end)

command_handler.register('adminaccountlink', 'Связывает userid Discord с другими порталами в бд проекта', nil, true, function (msg, argv, args)
	local id = string.gsub(argv[2], '@', '')
	id = string.gsub(id, '<', '')
	id = string.gsub(id, '>', '')
	id = string.gsub(id, '!', '')
	local userid = cl:getUser(id).id
--	if not argv[3] or account_is_account_id(argv[3]) then msg.channel:send("Нету типа для связывания!") end
	if not argv[4] then msg.channel:send("Нету айди для связывания!") end

	account_set_link(userid, argv[3], argv[4])

	local output = string.format('Для %s привязан %s с уникальным идентификатором %s\n', userid, argv[3], argv[4])
	msg.channel:send(output)
end)

command_handler.register('getlinkedaccount', 'Выводит ваши привязанные id. Доступные типы: steam64id', '<type> [mention]', false, function(msg, argv, args)
	if not argv[2] then
		msg:reply('Не указан тип аккаунта. Доступные: steam64id')
		return
	elseif argv[2] ~= 'steam64id' then
		msg:reply('Неправильный тип аккаунта. Доступные: steam64id')
		return
	end

	if msg.mentionedUsers then
		local id = string.gsub(argv[3], '@', '')
	        id = string.gsub(id, '<', '')
	        id = string.gsub(id, '>', '')
	        id = string.gsub(id, '!', '')
	        local userid = cl:getUser(id).id
		local result = account_get_link(userid, argv[2], nil)
		msg:reply(string.format('steam64id пользователя %s: %s', cl:getUser(userid).tag, result))
		return
	end

	local result = account_get_link(msg.author.id, argv[2], nil)

	msg:reply(string.format('Ваш steam64id: %s', result))
end)
