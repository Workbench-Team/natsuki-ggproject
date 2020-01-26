local channel = '660906542169849878'

function appealsinfo(user, hash)
	local reportsinfo = {title = 'Информация о репортах', description = ''} 
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
	local embed = {
		title = '***Информация о подаче и правилах заявлений и обращений***',
		color = 16098851,
		description = '**С помощью реакций вы можете создать или узнать информацию об обращении, просто поставив соответствующую реакцию**',
		fields = {
			{name='1️⃣',value='Узнать информацию о подаче жалоб',inline=true},
			{name='2️⃣',value='Узнать информацию о заявлении или покупке админки для сервера GG Events в SCP: Secret Laboratory',inline=true},
			{name='3️⃣',value='Узнать информацию о предложениях по серверу, рекламе и т.д.',inline=true},
			{name='4️⃣',value='Узнать информацию о просьбе или покупке разбана/размута',inline=true},
		},
	}
	local message = _G.cl:getChannel(channel):send{embed=embed}
	message:addReaction('1️⃣')
	message:addReaction('2️⃣')
	message:addReaction('3️⃣')
	message:addReaction('4️⃣')
	_G.cl:getChannel(channel):send('***Будет доступно позже!***')
end)
