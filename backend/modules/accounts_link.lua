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
mysql_db:close()
if result[1] == nil then return nil else return result[1].account end
end

function account_in_db(userid, account_type, account)
	return not account_get_link(userid, account_type, account) == nil
end

function account_is_type(account_type)
	if account_type == "steam64id" then return true end
	return false
end
