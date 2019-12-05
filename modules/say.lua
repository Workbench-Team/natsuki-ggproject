function say(msg, args, d)
	if d == true then msg:delete() end
	msg.channel:broadcastTyping()
	table.remove(args, 1)
	msg:reply(table.concat(args, ' '))
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
        local args = cont:split(' ')
        if msg.author.bot == true then return end
        if args[1] == _G.pref..'say' then
                local d = false
		say(msg, args, d)
        elseif args[1] == _G.pref..'sayd' then
		local d = true
                say(msg, args, d)
        end
end)
