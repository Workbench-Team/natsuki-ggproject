function nekos(msg, args)
	msg.channel:broadcastTyping()
	local neko_type = args[2]
	if neko_type == nil then msg:reply { embed = { description = "Укажите тег, доступные теги:\n`'femdom', 'tickle', 'classic', 'ngif', 'erofeet', 'meow', 'erok', 'poke', 'les', 'hololewd', 'lewdk', 'keta', 'feetg', 'nsfw_neko_gif', 'eroyuri', 'kiss', 'kuni', 'tits', 'pussy_jpg', 'cum_jpg', 'pussy', 'lewdkemo', 'lizard', 'slap', 'lewd', 'cum', 'cuddle', 'spank', 'smallboobs', 'goose', 'Random_hentai_gif', 'avatar', 'fox_girl', 'nsfw_avatar', 'hug', 'gecg', 'boobs', 'pat', 'feet', 'smug', 'kemonomimi', 'solog', 'holo', 'wallpaper', 'bj', 'woof', 'yuri', 'trap', 'anal', 'baka', 'blowjob', 'holoero', 'feed', 'neko', 'gasm', 'hentai', 'futanari', 'ero', 'solo', 'waifu', 'pwankg', 'eron', 'erokemo'`", color = 13632027, author = {name=msg.author.tag,icon_url=msg.author.avatarURL}, footer = {icon_url=_G.cl.user.avatarURL,text=_G.cl.user.tag}, timestamp = _G.disc.Date():toISO('T', 'Z') } } return end
	neko_type = string.gsub(neko_type, "'", '')
	local data, body = _G.http.request('GET', 'https://nekos.life/api/v2/img/'..neko_type)
	if body == nil then msg:reply { embed = { description = 'Проблемы с доступом к API', color = 13632027, author = {name=msg.author.tag,icon_url=msg.author.avatarURL}, footer = {icon_url=_G.cl.user.avatarURL,text=_G.cl.user.tag}, timestamp = _G.disc.Date():toISO('T', 'Z') } } return end
	local url = _G.json.decode(body)['url']
	if url == nil then msg:reply { embed = { description = 'Неверный тег или проблемы с доступом к API', color = 13632027, author = {name=msg.author.tag,icon_url=msg.author.avatarURL}, footer = {icon_url=_G.cl.user.avatarURL,text=_G.cl.user.tag}, timestamp = _G.disc.Date():toISO('T', 'Z') } } return end
	if msg.channel.nsfw ~= true then msg:reply { embed = { description = 'Канал должен быть помечен как NSFW', color = 13632027 } } return end
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
				icon_url = _G.cl.user.avatarURL,
				text = _G.cl.user.tag
			},
			timestamp = _G.disc.Date():toISO('T', 'Z')
		}
	}
end
