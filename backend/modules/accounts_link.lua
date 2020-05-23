local mysql_host = config.get('mysql_db_host')
local mysql_port = config.get('mysql_db_port')
local mysql_user = config.get('mysql_db_user')
local mysql_password = config.get('mysql_db_password')
local mysql_db_name = config.get('mysql_db_name')

local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( 'CREATE TABLE IF NOT EXISTS discord_steam64id_link(userid VARCHAR(255) PRIMARY KEY, account VARCHAR(255) NOT NULL)')
mysql_db:close()

function account_link(userid, account_type, account)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if account_type == "steam64id" then mysql_db:query( string.format("INSERT INTO discord_steam64id_link ( userid, account ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE account = '%s'", userid, mysql.escape(account), mysql.escape(account)) ) end
mysql_db:close()
end

function account_get_link(userid, account_type)
local result = nil
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
if account_type == "steam64id" then result = mysql_db:query( string.format("SELECT account FROM discord_steam64id_link WHERE userid = '%s'", userid) ) end
mysql_db:close()
if result[1] == nil then return nil else return result[1].account end
end

function account_unlink(userid, account_type)
	local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	if account_type == "steam64id" then mysql_db:query( string.format("DELETE FROM discord_steam64id_link WHERE userid = '%s'", userid) ) end
	mysql_db:close()
end

local function is_account_type(account_type)
	if account_type == "steam64id" then return true end
	return false
end

http_backend_register('account/link', function (http_json)
	local userid = http_json.userid
	local account = http_json.account
	local account_type = http_json.type

	if not is_account_type(account_type) then return http_responce_error_json( string.format("invalid type %s", account_type) ) end

	local result = account_link(userid, account_type, account)

return http_responce_ok_json("ok")
end)

http_backend_register('account/get', function (http_json)
	local userid = http_json.userid
	local account_type = http_json.type

	if not is_account_type(account_type) then return http_responce_error_json( string.format("invalid type %s", account_type) ) end

	local result = account_get_link(userid, account_type)
return http_responce_ok_json(result)
end)

http_backend_register('account/unlink', function (http_json)
	local userid = http_json.userid
	local account_type = http_json.type

	if not is_account_type(account_type) then return http_responce_error_json( string.format("invalid type %s", account_type) ) end

	account_unlink(userid, account_type)
return http_responce_ok_json("ok")
end)

http_backend_register('account/linked', function (http_json)
	local userid = http_json.userid
	local account = http_json.account
	local account_type = http_json.type

	if not is_account_type(account_type) then return http_responce_error_json( string.format("invalid type %s", account_type) ) end

	local result = not account_get_link(userid, account_type, account) == nil
return http_responce_ok_json(result)
end)