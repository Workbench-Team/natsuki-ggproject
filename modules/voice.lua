function music(msg, args)
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split()
	if args[1] == _G.pref..'music' then
		music(msg, args)
	end
end)
