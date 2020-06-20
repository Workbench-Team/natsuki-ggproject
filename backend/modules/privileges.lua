local mysql = require('third_party/luajit_mysql')

local mysql_host = config.get('mysql_db_host')
local mysql_port = config.get('mysql_db_port')
local mysql_user = config.get('mysql_db_user')
local mysql_password = config.get('mysql_db_password')
local mysql_db_name = config.get('mysql_db_name')

local privilege_servers = config.get('privilege_servers')

for i = 1,#privilege_servers do
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format('CREATE TABLE IF NOT EXISTS privileges_%s(userid VARCHAR(255) NOT NULL, privilege VARCHAR(255) NOT NULL, expiry VARCHAR(255))', privilege_servers[i]))
	mysql_db:close()
end

function privilege_add(server, userid, privilege, expiry)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("INSERT INTO privileges_%s( userid, privilege, expiry ) VALUES('%s','%s','%s')", server, userid, privilege, expiry) )
	mysql_db:close()
end

function privilege_add_noexpiry(server, userid, privilege, expiry)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("INSERT INTO privileges_%s( userid, privilege ) VALUES('%s','%s')", server, userid, privilege) )
end

function privilege_get(server)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	local result = mysql_db:query( string.format("SELECT * FROM privileges_%s", server) )
	mysql_db:close()
	return result
end

function privilege_remove(server, userid, privilege)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("DELETE FROM privileges_%s WHERE userid = '%s' AND privilege = '%s'", server, userid, privilege) )
	mysql_db:close()
end

function privilege_get_with_link(server, account_type)
	local result = privilege_get(server)
	for i = 1,#result do
		result[i].account = account_get_link(result[i].userid, account_type)
	end
	return result
end

http_backend_register('privilege/add', function (res, http_json)
	local server = http_json.server
	local userid = http_json.userid
	local privilege = http_json.privilege
	if not http_json.expiry then return http_response_ok_json(res, privilege_add_noexpiry(server, userid, privilege, expiry)) end
	local expiry = http_json.expiry
	return http_response_ok_json(res, privilege_add(server, userid, privilege, expiry))
end)

http_backend_register('privilege/get', function (res, http_json)
	local server = http_json.server
	return http_response_ok_json(res, privilege_get(server))
end)

http_backend_register('privilege/get_with_link', function (res, http_json)
	local server = http_json.server
	local account_type = http_json.account_type
	return http_response_ok_json(res, privilege_get_with_link(server, account_type))
end)

http_backend_register('privilege/remove', function (res, http_json)
	local server = http_json.server
	local userid = http_json.userid
	local privilege = http_json.privilege
	return http_response_ok_json(res, privilege_remove(server, userid, privilege))
end)
