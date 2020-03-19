command_handler.register('!', 'выполняет комманду', nil, true, function (msg, argv, args)
	msg.channel:broadcastTyping()
	table.remove(argv, 1)
	local cmd = table.concat(argv, ' ')
	local handle = io.popen(cmd)
	local result = handle:read('*a')
	io.open('result.txt', 'w'):write(result):close()
	local message = msg:reply { embed = { title = '$ '..cmd, description = result } }
	if message == nil then msg:reply { embed = { title = 'Ошибка', description = 'Запрос слишком большой или не заканчивается' }, file = 'result.txt' } end
	handle:close()
end)
