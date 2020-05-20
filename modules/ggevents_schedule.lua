local read_quotes_format = ' "([^"]+)"(.-)$'

command_handler.register('planevent', 'Запланировать мероприятие в расписание', '"Название мероприятия" "Описание мероприятия или ссылка на него в списке мероприятий" "YYYY-MM-DD HH:MM:SS" по UTC (+00:00) времени', false, function(msg, argv, args)
	if msg.guild.id ~= server then return end
	local allowedroles = {"607233166524022784", "681120189974052953", "640160188254388240", "628295268911284225"}
	local allowed = false
	for k, v in pairs(allowedroles) do
		local hasrole = msg.member.roles:get(allowedroles[k])
		if hasrole then
			allowed = true
		end
	end
	if allowed == false then msg:reply('Недостаточно прав') return end
	local title, desc = string.match(args, read_quotes_format)
	if title == nil or title == '' then msg:reply('Не найдено название, напишите в двойных ковычках "Название"') return end
	local desc, time = string.match(desc, read_quotes_format)
	if desc == nil or desc == '' then msg:reply('Не найдено описание или ссылка, напишите в двойных ковычках "Описание"') return end
	local time, _ = string.match(time, read_quotes_format)
	if time == nil or time == '' then msg:reply('Не найдено время, напишите в двойных ковычках "YYYY-MM-DD HH:MM:SS" по UTC (+00:00) времени') return end
	local unixtime
	local suc, err = pcall(function()
		unixtime = disc.Date().parseISO(time)
	end)
	if suc == false then
		msg:reply('Неправильный формат времени, пишите по такому формату "YYYY-MM-DD HH:MM:SS" по UTC (+00:00) времени, пример: "2020-12-31 23:59:59"') return
	end
	local embed = { title = title, description = desc, footer = { text = 'Время проведения по вашему времени' }, timestamp = time, color = 16312092, author = { name = 'Проводящий: '..msg.author.tag, icon_url = msg.author.avatarURL } }
	local message, err = cl:getChannel('707761955586310256'):send{embed=embed}
	if err then
		msg:reply('Неправильный формат времени, пишите по такому формату "YYYY-MM-DD HH:MM:SS" по UTC (+00:00) времени, пример: "2020-12-31 23:59:59"') return
	end
	msg:reply('Мероприятие запланировано: https://discordapp.com/channels/'..message.guild.id..'/'..message.channel.id..'/'..message.id)
end)
