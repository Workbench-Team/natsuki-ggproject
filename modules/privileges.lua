local method = 'privilege/'

function privilege_add(server, userid, privilege, expiry)
	local method = method..'add'
	data["server"] = server
	data["userid"] = userid
	data["privilege"] = privilege
	if expiry ~= '-1' then
		data["expiry"] = expiry
	end
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function privilege_remove(server, userid, privilege)
	local method = method..'remove'
	data["server"] = server
	data["userid"] = userid
	data["privilege"] = privilege
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function privilege_get(server)
	local method = method..'get'
	data["server"] = server
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return nil end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function privilege_list(server)
	local result = privilege_get(server)
	local string_table = {}

	table.insert(string_table, string.format("Список привилегий на сервере %s:\n```", server))

	for i = 1,#result do
		table.insert(string_table, string.format("%s ID:%s - %s\n", cl:getUser(result[i].userid).tag, result[i].userid, result[i].privilege))
	end

	table.insert(string_table, '```')

	return table.concat( string_table )
end
