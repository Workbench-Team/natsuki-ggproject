local mysql = require('third_party/luajit_mysql')

local mysql_host = config.get('mysql_db_host')
local mysql_port = config.get('mysql_db_port')
local mysql_user = config.get('mysql_db_user')
local mysql_password = config.get('mysql_db_password')
local mysql_db_name = config.get('mysql_db_name')

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

http_backend_register('donation/new', function (http_json)
	local amount = http_json.amount
	local valute = http_json.valute
	local comment = http_json.comment
	local thxid = http_json.thxid

	if amount == nil or valute == nil or thxid == nil then return http_responce_error_json("One of param is nil") end


	if donation_in_db(thxid) == true then return http_responce_error_json("Donation in db") end
	donation_insert(amount,valute,comment,thxid)
	donation_alert(amount,valute,comment)
end)