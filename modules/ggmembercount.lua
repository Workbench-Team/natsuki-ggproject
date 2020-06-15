function updateMemberCount(member)
	if member.guild.id == server then
		local channel = cl:getChannel('721845451627823185')
		if channel then
			channel:setName(string.format('Участников: %s', member.guild.totalMemberCount))
		end
	end
end

cl:on('memberJoin', function(member)
	updateMemberCount(member)
end)

cl:on('memberLeave', function(member)
	updateMemberCount(member)
end)



cl:on('voiceChannelLeave', function(member, channel)
	updateVoiceCount(member)
end)

cl:on('voiceChannelJoin', function(member, channel)
	updateVoiceCount(member)
end)

function updateVoiceCount(member)
	local channel = cl:getChannel('722163883363532890')
	if channel then
		local result = 0
		cl:getGuild(server).voiceChannels:forEach(
		function(vc)
			result = #vc.connectedMembers + result
		end)
		channel:setName(string.format('В голосовом: %s', result))
	end
end
