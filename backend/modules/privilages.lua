lolocal mysql_host = config['mysql_db_host']
local mysql_port = config['mysql_db_port']
local mysql_user = config['mysql_db_user']
local mysql_password = config['mysql_db_password']
local mysql_db_name = config['mysql_db_name']

local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format('CREATE TABLE IF NOT EXISTS privilages_%s(userid VARCHAR(255) PRIMARY KEY, privilage VARCHAR(255) NOT NULL)', server))
mysql_db:close()

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

function privilge_get_with_link(server, account_type)
	local result = privilage_get(server)

	for i = 1,#result do
		result[i].account = account_get_link(result[i].userid, account_type)
	end
	return result
end

http_backend_register('privilage/set', function (http_json)
	local server = http_json.server
	local userid = http_json.userid
	local privilage = http_json.privilage
	return http_responce_ok_json(privilage_set(server, userid, privilage))
end

http_backend_register('privilage/get', function (http_json)
	local server = http_json.server
	return http_responce_ok_json(privilage_get(server))
end

http_backend_register('privilage/get_with_link', function (http_json)
	local server = http_json.server
	local account_type = http_json.account_type
	return http_responce_ok_json(privilage_get_with_link(server, account_type))
end

http_backend_register('privilage/delete', function (http_json)
	local server = http_json.server
	local userid = http_json.userid
	return http_responce_ok_json(privilage_delete(server, userid))
end

