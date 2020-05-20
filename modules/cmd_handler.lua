local command_list = {}
local command_helplist = {}
local Emitter = core.Emitter
local command_emitter = Emitter:new()
command_count = 1
_G.command_handler = {}


cl:on('messageCreate',function(msg)
	local args = msg.content
	local argv = args:split(' ')

	if command_list[argv[1]] == nil then return end

	if command_list[argv[1]].is_admin == true then
	local alwd_g = {['admin'] = true, ['owner'] = true}
	local user_g = groups[msg.author.id]
	if alwd_g[user_g] == true then command_emitter:emit(argv[1], msg, argv, args) else msg:reply(msg.author.mentionString..' необходимо иметь группу `admin` или `owner`.') end
	else
	command_emitter:emit(argv[1], msg, argv, args)
	end
end)

local function register(command, help, help_args, is_admin, cb)
	command_list[pref..command] = {}
	command_list[pref..command]['is_admin'] = is_admin
	command_helplist[command_count] = {}
	command_helplist[command_count]['command'] = pref..command
	if type(help_args) == 'string' then
	command_helplist[command_count]['command_help'] = string.format('%s %s', pref..command, help_args)
	else
	command_helplist[command_count]['command_help'] = pref..command
	end
	command_helplist[command_count]['help'] = help
	command_helplist[command_count]['is_admin'] = is_admin

	command_emitter:on(pref..command, cb)

	command_count = command_count + 1
end

_G.command_handler['register'] = register

command_handler.register('help', 'Выводит это сообщение', nil, false, function (msg, argv, args)
	local embed = Embed:new(msg, '**Бот в разработке**', '**[Ссылка на GitHub страницу](https://github.com/ProfessorBrain/natsuki)\n[Ссылка на приглашение бота](https://discordapp.com/oauth2/authorize?client_id=617013309341827132&scope=bot&permissions=8192)**', 0x36B973)

for i = 1,#command_helplist do
	embed:push_field(command_helplist[i].command_help, command_helplist[i].help)
end
	msg:reply { embed = embed:get() }
end)

