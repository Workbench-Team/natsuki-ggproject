command_handler.register('dog', 'Собачки UwU', nil, false, function (msg, argv, args)
        msg.channel:broadcastTyping()
        local data, body = http.request('GET', 'https://dog.ceo/api/breeds/image/random')
        if body == nil then msg:reply('Произошла ошибка') return end
        local url = json.decode(body)['message']
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
