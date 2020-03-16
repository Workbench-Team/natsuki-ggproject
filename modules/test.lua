command_handler.register('test', 'Debug', nil, true, function (msg, argv, args)
local table = Embed:new('Test', 'Debug', 3586419, {icon_url = cl.user.avatarURL,text = cl.user.tag}, {icon_url = msg.author.avatarURL,name = msg.author.tag})
table:push_field('Field 1', 'Addonation text for field 1')
table:push_field('Field 2', 'Addonation text for field 2')
table:push_field('Field 3', 'Addonation text for field 3')
msg:reply { embed = table:get() }
end)

