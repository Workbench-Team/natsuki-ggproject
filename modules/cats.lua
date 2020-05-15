command_handler.register('cat', 'Котики :3', nil, false, function (msg, argv, args)
	msg.channel:broadcastTyping()
	local data, body = http.request('GET', 'https://api.thecatapi.com/v1/images/search')
	if body == nil then msg:reply('Произошла ошибка') return end
	local url = json.decode(body)[1]['url']
	if url == nil then msg:reply('Произошла ошибка') return end
	msg:reply {
                embed = {
                        image = {
                                url = url
                        },
                        description = 'Нет изображения? Кликните [сюда]('..url..')',
                        color = 9442302,
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
end)
