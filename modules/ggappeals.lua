local channel = '660906542169849878'

function appealsinfo(user, hash)
end

_G.cl:on('reactionAdd', function(react, userid)
	local user = _G.cl:getUser(userid)
	local hash = react.emojiHash
	if user.bot == true then
		return
	end
	if react.message.channel.id == channel then
		appealsinfo(user, hash)
		react:delete(userid)
	end
end)
_G.cl:on('reactionAddUncached', function(chnl, msgid, hash, userid)
	local user = _G.cl:getUser(userid)
	if user.bot == true then
		return
	end
	if chnl.id == channel then
		appealsinfo(user, hash)
		chnl:getMessage(msgid):removeReaction(hash, userid)
	end
end)

_G.cl:on('ready', function()
	_G.cl:getChannel(channel):getMessages():forEach(function(msg) msg:delete() end)
	_G.cl:getChannel(channel):send('***Будет доступно позже!***')
end)
