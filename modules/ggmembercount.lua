timer.setInterval(600000, function()
	local channel1 = cl:getChannel('722163883363532890')
	if channel1 then
		local result = 0
		cl:getGuild(server).voiceChannels:forEach(
		function(vc)
			result = #vc.connectedMembers + result
		end)
		channel1:setName(string.format('В голосовом: %s', result))
	end

	local channel2 = cl:getChannel('721845451627823185')
	if channel2 then
		channel2:setName(string.format('Участников: %s', member.guild.totalMemberCount))
	end
end)
