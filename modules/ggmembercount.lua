cl:on('memberJoin', function(member)
	if member.guild.id == server then
		local channel = cl:getChannel('721845451627823185')
		if channel then
			channel:setName(string.format('Участников: %s', member.guild.members:count()))
		end
	end
end)
