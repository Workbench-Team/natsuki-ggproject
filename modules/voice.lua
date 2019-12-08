function lhh(msg, args)
	local vc = msg.guild.connection
	if vc then
		local method = args[2]
		if method then
			if method == 'leave' then
				vc:stopStream()
				vc:close()
			elseif method == 'stop' then
				vc:stopStream()
			elseif method == 'play' then
				local suc, err = pcall(function()
					return vc:playFFmpeg('http://sv1.ggproject.xyz:8000/live')
				end)
			end
		end
	else
		local method = args[2]
		if method then
			if method == 'join' then
				local chnl = msg.member.voiceChannel
				if chnl then
					local vc = chnl:join()
				end
			elseif method == 'play' then
				local chnl = msg.member.voiceChannel
				if chnl then
					local vc = chnl:join()
					if vc then
						local suc, err = pcall(function()
							return vc:playFFmpeg('http://sv1.ggproject.xyz:8000/live')
		                                end)
					end
				end
			end
		end
	end
	msg:delete()
end
_G.cl:on('messageCreate', function(msg)
	local cont = msg.content
	local args = cont:split(' ')
	if args[1] == _G.pref..'lhh' then
		if msg.channelType == 1 or msg.channelType == 3 then return end
		lhh(msg, args)
	end
end)
