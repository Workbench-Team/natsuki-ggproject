command_handler.register('choose', 'change this', nil, false, function (msg, argv, args)
  local vsargs = args:split('vs')
  if vsargs[1] and vsargs[2] then
		vsargs[1] = vsargs[1]:gsub(argv[1], '')
		message:reply('The choice is: '..vsargs[math.random(#vsargs)]) 
	else
		message:reply('Please put at least two arguments to choose from.')
	end
end
