cl:on('reactionAdd', function(reaction, userid)
	if userid == cl.user.id then return end
	if reaction.message.channel.id == '650781688754077766' then newsSubs(reaction.emojiHash, userid) end
	return
end)
cl:on('reactionAddUncached', function(channel, messageid, hash, userid)
	if userid == cl.user.id then return end
	if channel.id == '650781688754077766' then newsSubs(hash, userid) end
	return
end)

cl:on('reactionRemove', function(reaction, userid)
	if reaction.message.channel.id == '650781688754077766' then newsRemoveSubs(reaction.emojiHash, userid) end
	return
end)

cl:on('reactionRemoveUncached', function(channel, messageid, hash, userid)
	if channel.id == '650781688754077766' then newsRemoveSubs(hash, userid) end
	return
end)

function setupSubs()
	local channel = cl:getChannel('650781688754077766')
	local ggevents = cl:getRole('650782142955257869')
	local ggdm = cl:getRole('650782578441322496')
	local ggcinema = cl:getRole('650782777519898634')
	local ggorange = cl:getRole('695229555409158206')
	local scpsl = cl:getRole('650782827507351552')
	local pb = cl:getRole('677146477994311691')
	local msg = channel:getMessage('650793780005437441')
	msg:setContent('В этом канале вы можете подписаться на различные новости.\nДля этого есть соответствующие реакции ниже:\n🇦 - <@&'..ggevents.id..'>\n🇧 - <@&'..ggdm.id..'>\n🇨 - <@&'..ggcinema.id..'>\n🇩 - <@&'..scpsl.id..'>\n🇪 - <@&'..pb.id..'>\n🇫 - <@&'..ggorange.id..'>')
	msg:addReaction('🇦')
	msg:addReaction('🇧')
	msg:addReaction('🇨')
	msg:addReaction('🇩')
	msg:addReaction('🇪')
	msg:addReaction('🇫')
end

function newsSubs(hash, userid)
	local channel = cl:getChannel('650781688754077766')
	local chat = cl:getChannel('607249903629893643')
        local ggevents = '650782142955257869'
        local ggdm = '650782578441322496'
        local ggcinema = '650782777519898634'
	local ggorange = '695229555409158206'
        local scpsl = '650782827507351552'
	local pb = '677146477994311691'
	local member = cl:getGuild('606961070212644894'):getMember(userid)
        if hash == '🇦' then
		member:addRole(ggevents)
--		chat:send(member.user.mentionString..' подписался на новости GG Events')
	elseif hash == '🇧' then
		member:addRole(ggdm)
--		chat:send(member.user.mentionString..' подписался на новости GG DM')
	elseif hash == '🇨' then
		member:addRole(ggcinema)
--		chat:send(member.user.mentionString..' подписался на новости GG Cinema')
	elseif hash == '🇩' then
		member:addRole(scpsl)
--		chat:send(member.user.mentionString..' подписался на новости SCP: Secret Laboratory')
	elseif hash == '🇪' then
		member:addRole(pb)
--		chat:send(member.user.mentionString..' подписался на новости Профессора Brain')
	elseif hash == '🇫' then
		member:addRole(ggorange)
	end
end

function newsRemoveSubs(hash, userid)
	local channel = cl:getChannel('650781688754077766')
	local chat = cl:getChannel('607249903629893643')
        local ggevents = '650782142955257869'
        local ggdm = '650782578441322496'
        local ggcinema = '650782777519898634'
	local ggorange = '695229555409158206'
        local scpsl = '650782827507351552'
	local pb = '677146477994311691'
        local member = cl:getGuild('606961070212644894'):getMember(userid)
        if hash == '🇦' then
                member:removeRole(ggevents)
--		chat:send(member.user.mentionString..' отписался от новостей GG Events')
        elseif hash == '🇧' then
                member:removeRole(ggdm)
--		chat:send(member.user.mentionString..' отписался от новостей GG DM')
        elseif hash == '🇨' then
                member:removeRole(ggcinema)
--		chat:send(member.user.mentionString..' отписался от новостей GG Cinema')
        elseif hash == '🇩' then
                member:removeRole(scpsl)
--		chat:send(member.user.mentionString..' отписался от новостей SCP: Secret Laboratory')
	elseif hash == '🇪' then
		member:removeRole(pb)
--		chat:send(member.user.mentionString..' отписался от новостей Профессора Brain')
	elseif hash == '🇫' then
		member:removeRole(ggorange)
        end
end

cl:on('ready', function()
	setupSubs()
end)
