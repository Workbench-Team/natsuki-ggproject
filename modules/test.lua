command_handler.register('test', 'test', nil, true, function(msg, argv, args)
	local data = { ["token"] = backend_token }
	data = json.encode(data)
	local data, body = http.request('POST', 'http://127.0.0.1:1080/api/ping', nil, data)
	if body then
		local result = json.decode(body)["data"]
		msg:reply(result)
	end
end)
