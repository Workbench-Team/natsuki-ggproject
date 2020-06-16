timer.setInterval(300000, function()
	local channel1 = cl:getChannel('722163883363532890')
	if channel1 then
		local result = 0
		cl:getGuild(server).voiceChannels:forEach(
		function(vc)
			result = #vc.connectedMembers + result
		end)
		coroutine.wrap(channel1.setName)(channel1, string.format('В голосовом: %s', result))
	end

	local channel2 = cl:getChannel('721845451627823185')
	if channel2 then
		coroutine.wrap(channel2.setName)(channel2, string.format('Участников: %s', channel2.guild.totalMemberCount))
	end
	return
end)
