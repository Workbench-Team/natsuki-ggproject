local channel = '660906542169849878'

function appeal(user, hash)
	
end

cl:on('reactionAdd', function(react, userid)
	local user = cl:getUser(userid)
	local hash = react.emojiHash
	if user.bot == true then
		return
	end
	if react.message.channel.id == channel then
		appeal(user, hash)
		react:delete(userid)
	end
end)
cl:on('reactionAddUncached', function(chnl, msgid, hash, userid)
	local user = cl:getUser(userid)
	if user.bot == true then
		return
	end
	if chnl.id == channel then
		appeal(user, hash)
		chnl:getMessage(msgid):removeReaction(hash, userid)
	end
end)

cl:on('ready', function()
--	cl:getChannel(channel):getMessages():forEach(function(msg) msg:delete() end)
--	cl:getChannel(channel):send{embed={title='title'}, content='content'}
	local message = cl:getChannel(channel):getMessage('684798172098592849')
	local embed = { title='Подробнее о системе обращений', description='Для начала нового обращения, вы можете нажать на соответствующую реакцию к этому сообщению\nПосле нажатия на реакцию вам будут прописаны правила, форма и команды для заполнения\nПравила обращений:', fields={{name='🇦', value='GG Events - заявление на администратора'}, {name='🇧', value='Жалоба на игрока/администратора'}, {name='🇨', value='Предложение чего-либо по сотрудничеству/серверу/мероприятию к GG Events и др.'}, }, color=8311585 }
	message:setContent('')
	message:setEmbed(embed)
	message:addReaction('🇦')
	message:addReaction('🇧')
	message:addReaction('🇨')
end)
