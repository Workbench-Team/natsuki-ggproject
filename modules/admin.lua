local method = 'exec'

command_handler.register('!', 'выполняет команду', '<команда shell/bash>', true, function (msg, argv, args)
	if msg.guild.id ~= server then return end
	msg.channel:broadcastTyping()
	table.remove(argv, 1)
	local cmd = table.concat(argv, ' ')
	data["cmd"] = cmd
	local data = json.encode(data)
	local data, body = http.request('POST', backend_url..method, nil, data)
	local result = json.decode(body)["data"]
	io.open('result.txt', 'w'):write(result):close()
	local message = msg:reply { embed = { title = '$ '..cmd, description = result } }
	if message == nil then msg:reply { embed = { title = 'Ошибка', description = 'Запрос слишком большой или не заканчивается' }, file = 'result.txt' } end
end)
