local method = 'privilage/'

function privilage_set(server, userid, privilage)
	local method = method..'set'
	data["server"] = server
	data["userid"] = userid
	data["privilage"] = privilage
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function privilage_delete(server, userid)
	local method = method..'delete'
	data["server"] = server
	data["userid"] = userid
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return false end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function privilage_get(server)
	local method = method..'get'
	data["server"] = server
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	if not body then return nil end
	local result = json.decode(body)["data"]
	cleardata()
	return result
end

function privilage_list(server)
local result = privilage_get(server)
local shit = string.format("Список привилегий:\n")

for i = 1,#result do
	shit = string.format("%s%s:%s\n", shit, cl:getUser(result[i].userid).tag..' | '..result[i].userid, result[i].privilage)
end

return shit
end
