function fox(msg, args)
	msg.channel:broadcastTyping()
	local data, body = http.request('GET', 'https://randomfox.ca/floof/')
	local url = json.decode(body)['image']
	if url == nil then msg:reply { embed = { description = 'Проблемы с доступом к API', color = 13632027, author = {name=msg.author.tag,icon_url=msg.author.avatarURL}, footer = {icon_url=cl.user.avatarURL,text=cl.user.tag}, timestamp = disc.Date():toISO('T', 'Z') } } return end
	msg:reply {
		embed = {
			image = {
				url = url
			},
			title = 'Лисички :3 <:yobaKaef:607517927033274368>',
			description = 'Нет изображения? Кликните [сюда]('..url..')',
			color = 14914576,
			author = {
				name = msg.author.tag,
				icon_url = msg.author.avatarURL
			},
			footer = {
				icon_url = cl.user.avatarURL,
				text = cl.user.tag
			},
			timestamp = disc.Date():toISO('T', 'Z')
		}
	}
end
cl:on('messageCreate', function(msg)
	local cont = msg.content
        local args = cont:split(' ')
        if msg.author.bot == true then return end
	if msg.channel == '660906542169849878' then return end
        if args[1] == pref..'fox' then
		fox(msg, args)
        end
end)
