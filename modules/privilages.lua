local mysql_host = config['mysql_db_host']
local mysql_port = config['mysql_db_port']
local mysql_user = config['mysql_db_user']
local mysql_password = config['mysql_db_password']
local mysql_db_name = config['mysql_db_name']

function privilage_preinit(server)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format('CREATE TABLE IF NOT EXISTS privilages_%s(userid VARCHAR(255) PRIMARY KEY, privilage VARCHAR(255) NOT NULL)', server))
	mysql_db:close()
end

function privilage_set(server, userid, privilage)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("INSERT INTO privilages_%s( userid, privilage ) VALUES('%s','%s') ON DUPLICATE KEY UPDATE privilage = '%s'", server, userid, privilage, privilage) )
	mysql_db:close()
end

function privilage_get_account_link(userid, account_type)
	return account_get_link(userid, account_type)
end

function privilges_get_privilages_with_link(server, account_type)
	local result = privilage_get(server)

	for i = 1,#result do
		result[i].userid = privilage_get_account_link(result[i].userid, account_type)
	end
	return result
end

function privilage_delete(server, userid)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	mysql_db:query( string.format("DELETE FROM privilages_%s WHERE userid = '%s'", server, userid) )
	mysql_db:close()
end

function privilage_get(server)
	local mysql_db = mysql.connect( mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
	local result = mysql_db:query( string.format("SELECT * FROM privilages_%s", server) )
	mysql_db:close()
	return result
end

function privilage_list(server)
local result = privilage_get(server)

local shit = string.format("Список привилегий:\n")

for i = 1,#result do
	shit = string.format("%s%s:%s\n", shit, result[i].userid, result[i].privilage)
end

return shit
end
