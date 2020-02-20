local channel = '660906542169849878'

function appealsinfo(user, hash)
end

cl:on('reactionAdd', function(react, userid)
	local user = cl:getUser(userid)
	local hash = react.emojiHash
	if user.bot == true then
		return
	end
	if react.message.channel.id == channel then
		appealsinfo(user, hash)
		react:delete(userid)
	end
end)
cl:on('reactionAddUncached', function(chnl, msgid, hash, userid)
	local user = cl:getUser(userid)
	if user.bot == true then
		return
	end
	if chnl.id == channel then
		appealsinfo(user, hash)
		chnl:getMessage(msgid):removeReaction(hash, userid)
	end
end)

cl:on('ready', function()
--	cl:getChannel(channel):getMessages():forEach(function(msg) msg:delete() end)
--	cl:getChannel(channel):send('***Будет доступно позже!***')
end)
