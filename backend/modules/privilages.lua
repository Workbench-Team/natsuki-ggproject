local mysql = require('third_party/luajit_mysql')

local mysql_host = config.get('mysql_db_host')
local mysql_port = config.get('mysql_db_port')
local mysql_user = config.get('mysql_db_user')
local mysql_password = config.get('mysql_db_password')
local mysql_db_name = config.get('mysql_db_name')

local privilage_servers = config.get('privilage_servers')

for i = 1,#privilage_servers do
local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format('CREATE TABLE IF NOT EXISTS privilages_%s(userid VARCHAR(255) PRIMARY KEY, privilage VARCHAR(255) NOT NULL)', privilage_servers[i]))
mysql_db:close()
end

function privilage_set(server, userid, privilage)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("INSERT INTO privilages_%s( userid, privilage ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE privilage = '%s'", server, userid, privilage, privilage) )
	mysql_db:close()
end

function privilage_get(server)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	local result = mysql_db:query( string.format("SELECT * FROM privilages_%s", server) )
	mysql_db:close()
	return result
end

function privilage_delete(server, userid)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("DELETE FROM privilages_%s WHERE userid = '%s'", server, userid) )
	mysql_db:close()
end

function privilage_get_with_link(server, account_type)
	local result = privilage_get(server)

	for i = 1,#result do
		result[i].account = account_get_link(result[i].userid, account_type)
	end
	return result
end

http_backend_register('privilage/set', function (res, http_json)
	local server = http_json.server
	local userid = http_json.userid
	local privilage = http_json.privilage
	return http_response_ok_json(res, privilage_set(server, userid, privilage))
end)

http_backend_register('privilage/get', function (res, http_json)
	local server = http_json.server
	return http_response_ok_json(res, privilage_get(server))
end)

http_backend_register('privilage/get_with_link', function (res, http_json)
	local server = http_json.server
	local account_type = http_json.account_type
	return http_response_ok_json(res, privilage_get_with_link(server, account_type))
end)

http_backend_register('privilage/delete', function (res, http_json)
	local server = http_json.server
	local userid = http_json.userid
	return http_response_ok_json(res, privilage_delete(server, userid))
end)

