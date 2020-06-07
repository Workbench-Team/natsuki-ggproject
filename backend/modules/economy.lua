local mysql = require('third_party/luajit_mysql')

local mysql_host = config.get('mysql_db_host')
local mysql_port = config.get('mysql_db_port')
local mysql_user = config.get('mysql_db_user')
local mysql_password = config.get('mysql_db_password')
local mysql_db_name = config.get('mysql_db_name')

local economy_curse_in = config.get('economy').economy_curse_in
local economy_curse_out = config.get('economy').economy_curse_out

local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query('CREATE TABLE IF NOT EXISTS economy_balance ( userid VARCHAR(255) PRIMARY KEY, money INT NOT NULL );')
mysql_db:close()

function economy_insert_balance(userid, money)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format("INSERT INTO economy_balance ( userid, money ) VALUES('%s', '%s') ON DUPLICATE KEY UPDATE money = money + '%s';", userid, money, money))
mysql_db:close()
end

function economy_set_balance(userid, money)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format("INSERT INTO economy_balance ( userid, money ) VALUES('%s', '%s') ON DUPLICATE KEY UPDATE money = '%s';", userid, money, money))
mysql_db:close()
end

function economy_get_balance(userid)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
local result = mysql_db:query( string.format("SELECT money FROM economy_balance WHERE userid = '%s';", userid) )
mysql_db:close()
if result[1] == nil then return 0 end
return result[1].money
end
