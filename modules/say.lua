function say(msg, args, d)
	if d == true then msg:delete() end
	msg.channel:broadcastTyping()
	table.remove(args, 1)
	msg:reply(table.concat(args, ' '))
end
