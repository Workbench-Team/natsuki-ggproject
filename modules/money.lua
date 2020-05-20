local mysql_host = config['mysql_db_host']
local mysql_port = config['mysql_db_port']
local mysql_user = config['mysql_db_user']
local mysql_password = config['mysql_db_password']
local mysql_db_name = config['mysql_db_name']

local donation_channel_id = config["donation_channel_id"]

local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)

mysql_db:query( 'CREATE TABLE IF NOT EXISTS donations(id INT AUTO_INCREMENT PRIMARY KEY, thxid VARCHAR(255) NOT NULL, amount DOUBLE NOT NULL, valute INT NOT NULL, comment VARCHAR(255), date DATE)' )
mysql_db:query( 'CREATE TABLE IF NOT EXISTS purchases(id INT AUTO_INCREMENT PRIMARY KEY, userid VARCHAR(255) NOT NULL, cost DOUBLE NOT NULL, valute INT NOT NULL, comment VARCHAR(255), date DATE)' )

mysql_db:query( 'CREATE TABLE IF NOT EXISTS users_balance_rub(userid VARCHAR(255) PRIMARY KEY, amount DOUBLE NOT NULL)' )
mysql_db:query( 'CREATE TABLE IF NOT EXISTS users_balance_eur(userid VARCHAR(255) PRIMARY KEY, amount DOUBLE NOT NULL)' )
mysql_db:query( 'CREATE TABLE IF NOT EXISTS users_balance_usd(userid VARCHAR(255) PRIMARY KEY, amount DOUBLE NOT NULL)' )
mysql_db:query( 'CREATE TABLE IF NOT EXISTS users_balance_kzt(userid VARCHAR(255) PRIMARY KEY, amount DOUBLE NOT NULL)' )

mysql_db:close()

function balance_insert(userid, amount, code)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if code == 643 then mysql_db:query( string.format( "INSERT INTO users_balance_rub ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = amount + '%s';", userid, amount, amount ) ) end
if code == 978 then mysql_db:query( string.format( "INSERT INTO users_balance_eur ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = amount + '%s';", userid, amount, amount ) ) end
if code == 840 then mysql_db:query( string.format( "INSERT INTO users_balance_usd ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = amount + '%s';", userid, amount, amount ) ) end
if code == 398 then mysql_db:query( string.format( "INSERT INTO users_balance_kzt ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = amount + '%s';", userid, amount, amount ) ) end
mysql_db:close()
end

function balance_set(userid, amount, code)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if code == 643 then mysql_db:query( string.format( "INSERT INTO users_balance_rub ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = '%s';", userid, amount, amount ) ) end
if code == 978 then mysql_db:query( string.format( "INSERT INTO users_balance_eur ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = '%s';", userid, amount, amount ) ) end
if code == 840 then mysql_db:query( string.format( "INSERT INTO users_balance_usd ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = '%s';", userid, amount, amount ) ) end
if code == 398 then mysql_db:query( string.format( "INSERT INTO users_balance_kzt ( userid, amount ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE amount = '%s';", userid, amount, amount ) ) end
mysql_db:close()
end

function balance_get(userid, code)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
local result = nil
if code == 643 then result = mysql_db:query( string.format("SELECT amount FROM users_balance_rub WHERE userid = '%s';", userid) ) end
if code == 978 then result = mysql_db:query( string.format("SELECT amount FROM users_balance_eur WHERE userid = '%s';", userid) ) end
if code == 840 then result = mysql_db:query( string.format("SELECT amount FROM users_balance_usd WHERE userid = '%s';", userid) ) end
if code == 398 then result = mysql_db:query( string.format("SELECT amount FROM users_balance_kzt WHERE userid = '%s';", userid) ) end
mysql_db:close()
if result[1] == nil then return 0.0 else return result[1].amount end
end

function purchase_insert(userid, cost, valute, comment)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format( "INSERT INTO purchases ( userid, cost, valute, comment, date ) VALUES('%s','%s', '%s', '%s', now());", userid, cost, valute, comment ) )
mysql_db:close()
end

function donation_get_valute_by_code(code)
if code == 643 then return "RUB" end
if code == 978 then return "EUR" end
if code == 840 then return "USD" end
if code == 398 then return "KZT" end
return "ERROR"
end

function donation_get_code_by_valute(valute)
if valute == 'RUB' then return 643 end
if valute == 'EUR' then return 978 end
if valute == 'USD' then return 840 end
if valute == 'KZT' then return 398 end
return 0
end

function donation_is_discord_id(user_str)
	return cl:getUser(user_str) == nil
end

function donation_in_db(thxid) --antiqiwi resend
	local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	local result = not mysql_db:query( string.format("SELECT * FROM donations WHERE thxid = '%s'", thxid) )[1] == nil
	mysql_db:close()
	return result
end

function donation_insert(amount,valute,comment,tranxid,date)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if not donation_is_discord_id(comment) == false then
	balance_insert('anon', amount, valute)
	mysql_db:query( string.format("INSERT INTO donations ( thxid, amount, valute, comment, date ) VALUES('%s',%f,%i,'anon',now())", tranxid, amount, valute ))
else
	balance_insert(comment, amount, valute)
	mysql_db:query( string.format("INSERT INTO donations ( thxid, amount, valute, comment, date ) VALUES('%s',%f,%i,'%s',now())", tranxid, amount, valute, mysql.escape(comment) ))
end
mysql_db:close()
end

function donation_alert(amount,valute,comment)
if not donation_is_discord_id(comment) == false then
	cl:getChannel(donation_channel_id):send(string.format("Поступил анонимный донат на сумму %.2f %s\n", amount, donation_get_valute_by_code(valute)))
else
	cl:getChannel(donation_channel_id):send(string.format("Поступил донат на сумму %.2f %s от <@!%s>\n", amount, donation_get_valute_by_code(valute), comment))
end

end

function donation_new(amount,valute,comment,tranxid,date)
	if donation_in_db(thxid) == true then return end
	donation_insert(amount,valute,comment,tranxid,date)
	donation_alert(amount,valute,comment)
end

command_handler.register('balance', 'Показывает баланс', '<user> or anon', false, function (msg, argv, args)
	if msg.guild.id ~= server then return end
	if argv[2] == 'anon' then
		local embed = Embed:new(msg, 'Анонимно задоначено:', string.format('%.2f RUB\n%.2f EUR\n%.2f USD\n%.2f KZT\n', balance_get('anon', 643), balance_get('anon', 978), balance_get('anon', 840), balance_get('anon', 398)), 0x36B973)
		msg.channel:send{embed = embed:get()}
		return
	end

	if argv[2] then
		local id = string.gsub(argv[2], '@', '')
		id = string.gsub(id, '<', '')
		id = string.gsub(id, '>', '')
		id = string.gsub(id, '!', '')
		if not cl:getUser(id) then return end
		local userid = cl:getUser(id).id
		local embed = Embed:new(msg, 'Баланс пользователя '..cl:getUser(id).tag..':', string.format('%.2f RUB\n%.2f EUR\n%.2f USD\n%.2f KZT', balance_get(userid, 643), balance_get(userid, 978), balance_get(userid, 840), balance_get(userid, 398)), 0x36B973)
		msg.channel:send{embed = embed:get()}
		return
	end

	local userid = msg.author.id
	local donation_msg = string.format('Ваш комментарий для доната `%s`\n', userid)
	donation_msg = string.format('%s%s', donation_msg, 'Для доната перейдите по ссылке, в комментариях укажите __**ТОЛЬКО**__ эти цифры без лишних пробелов, символов и слов, то есть только эти цифры, в ином случае донат будет анонимным.\nhttps://qiwi.com/n/PRBRAIN\n')
	donation_msg = string.format('%s%s', donation_msg, 'Ваш баланс:\n')
	local embed = Embed:new(msg, nil, string.format('%.2f RUB\n%.2f EUR\n%.2f USD\n%.2f KZT\nДля пополнения баланса, перейдите по ссылке и введите `%s` (Для каждого эти цифры уникальны) в поле с комментарием и ничего больше (ни пробелов, ни других слов и символов) https://qiwi.com/n/PRBRAIN', balance_get(userid, 643), balance_get(userid, 978), balance_get(userid, 840), balance_get(userid, 398), userid), 0x36B973)
	msg.channel:send{embed = embed:get()}
end)

shop_list = {}
shop_count = 1

function shop_buy(msg, userid, id, count)
	if type(count) ~= 'number' then
		msg:reply(msg.author.mentionString..' количество товара должно быть записано цифрой')
		return
	end
	count = math.floor(count)
	id = math.floor(id)

	if shop_list[id] == nil then
		local embed = embed:new(msg, nil, 'Неизвестный id для магазина', 0xFF0000)
		msg.channel:send{embed = embed:get()}
		return
	end
	if count == nil then count = 1 end

	if count > 1 and shop_list[id].amount == false then 
		local embed = Embed:new(msg, nil, 'Этот придмет можно купить только поштучно', 0xFF0000)
		msg.channel:send{embed = embed:get()}
		return 
	end

	local item_valute_code = shop_list[id].valute
	local balance_valute = balance_get(userid, item_valute_code)
	local cost = (shop_list[id].cost * count)

	if cost > balance_valute then
		local embed = Embed:new(msg, nil, string.format("Недостаточно средств для покупки!\nУ вас - %s %s\nНе хватает - %s %s", balance_valute, donation_get_valute_by_code(item_valute_code), cost - balance_valute, donation_get_valute_by_code(item_valute_code)), 0xFF0000)
		msg.channel:send{embed = embed:get()}
		return 
	end

	local result = shop_list[id].callback(msg, count)
	if result == false then
		local embed = Embed:new(msg, nil, "Обработчик покупки вернул false", 0xFF0000)
		msg.channel:send{embed = embed:get()}
		return 
	end

	local balance_new = balance_valute - cost

	balance_set(userid, balance_new, item_valute_code)
	purchase_insert( userid, cost, shop_list[id].valute, "" )

	if count == 1 then
		local embed = Embed:new(msg, nil, string.format("Вы купили %s за %s %s", shop_list[id].name, shop_list[id].cost, donation_get_valute_by_code(shop_list[id].valute)), 0x36B973)
		msg.channel:send{embed = embed:get()}
	else
		local embed = Embed:new(msg, nil, string.format("Вы купили %s %s за %s %s", count, shop_list[id].name_multiple, cost, donation_get_valute_by_code(shop_list[id].valute)), 0x36B973)
		msg.channel:send{embed = embed:get()}
	end
end

function shop_l(msg)
	local embed = Embed:new(msg, '**Магазин**', nil, 0x36B973)

	for i = 1,#shop_list do
		embed:push_field(shop_list[i].name, string.format('%s %s\nid = %s', shop_list[i].cost, donation_get_valute_by_code(shop_list[i].valute), i))
	end

	msg:reply { embed = embed:get() }
end

function shop_register(name, description, cost, valute, callback)
	shop_list[shop_count] = {}
	shop_list[shop_count]['name'] = name
	shop_list[shop_count]['description'] = description 
	shop_list[shop_count]['cost'] = cost 
	shop_list[shop_count]['valute'] = valute
	shop_list[shop_count]['amount'] = false
	shop_list[shop_count]['callback'] = callback 
	shop_count = shop_count + 1
end

function shop_register_multiple(name, name_multiple, description, cost, valute, amount, callback)
	shop_list[shop_count] = {}
	shop_list[shop_count]['name'] = name
	shop_list[shop_count]['name_multiple'] = name_multiple
	shop_list[shop_count]['description'] = description 
	shop_list[shop_count]['cost'] = cost 
	shop_list[shop_count]['valute'] = valute
	shop_list[shop_count]['amount'] = amount
	shop_list[shop_count]['callback'] = callback 
	shop_count = shop_count + 1
end

command_handler.register('shop', 'Самый убогий магазин который можно было написать для бота в дискорде', 'list / info <id> / buy <id> <count>', false, function (msg, argv, args)
	if msg.guild.id ~= server then return end
	local userid = msg.author.id
	if argv[2] == nil then 	msg.channel:send('Недостаточно аргументов') return end
	if argv[2] == 'list' then shop_l(msg) return end
	if argv[2] == 'buy' and argv[3] == nil then msg.channel:send('Недостаточно аргументов для покупки') return else shop_buy(msg, userid, tonumber(argv[3]), tonumber(argv[4])) return end
	return
end)

command_handler.register('setbalance', 'Установить баланс для пользователя', '<user> <valute> <amount>', true, function (msg, argv, args)
	if msg.guild.id ~= server then return end
	if not argv[2] then return end
	local id = string.gsub(argv[2], '@', '')
	id = string.gsub(id, '<', '')
	id = string.gsub(id, '>', '')
	id = string.gsub(id, '!', '')
	local userid = cl:getUser(id).id
	balance_set(userid, argv[4], donation_get_code_by_valute(argv[3]))
	msg:reply(string.format('Баланс пользователя %s установлен на %s %s', cl:getUser(id).tag, argv[4], argv[3]))
	return
end)
