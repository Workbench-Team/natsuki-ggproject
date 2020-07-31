timer.setInterval(15000, function()
	local count = cl.guilds:count()
	coroutine.wrap(function()
		cl:setGame{type = 3, name = pref..'help | Servers: '..#cl.guilds}
	end)()
end)
