local mysql_host = config['mysql_db_host']
local mysql_port = config['mysql_db_port']
local mysql_user = config['mysql_db_user']
local mysql_password = config['mysql_db_password']
local mysql_db_name = config['mysql_db_name']

local economy_curse_in = config['economy_curse_in']
local economy_curse_out = config['economy_curse_out']
local economy_smile = config['economy_smile']

local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)

mysql_db:query('CREATE TABLE IF NOT EXISTS economy_balance ( userid VARCHAR(255) PRIMARY KEY, money INT NOT NULL );')

mysql_db:close()

function economy_insert_balance(userid, money)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format("INSERT INTO economy_balance ( userid, money ) VALUES('%s', '%s') ON DUPLICATE KEY UPDATE money = money + '%s';", userid, money, money))
mysql_db:close()
end

function economy_set_balance(userid, money)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
mysql_db:query( string.format("INSERT INTO economy_balance ( userid, money ) VALUES('%s', '%s') ON DUPLICATE KEY UPDATE money = '%s';", userid, money, money))
mysql_db:close()
end

function economy_get_balance(userid)
local mysql_db = mysql.connect(mysql_host, mysql_port, mysql_user, mysql_password, mysql_db_name)
local result = mysql_db:query( string.format("SELECT money FROM economy_balance WHERE userid = '%s';", userid) )
mysql_db:close()
if result[1] == nil then return 0 end
return result[1].money
end

shop_register_multiple('Печку', 'Печек', 'Govno x2', 0.01, donation_get_code_by_valute('RUB'), true, function (msg, count)
	economy_insert_balance(msg.author.id, count)
end)

-- Thanks @Dryzhok#2855 

local work_text_profit = {
'Брайн проиграл на спор в осу на %s %s',
'Сегодня вы были офицантом в баре, и вам один из заказчиков дал вам %s %s ',
'Вы правели хорошую ночь с Профессором и он вам дал %s %s',
'Проехавшись на улице с самокатом вы нашли %s %s',
'Вы продали несколько вещей и заработали %s %s',
'Как только вы открыли дверь у дома, там была собачка с %s %s',
'Ты встерил на улице игрока сцп и он обранил %s %s',
'Вы выйграли турнир по Xash3D и получили %s %s как приз',
'Вы сделали репорт, но абузер вам дал %s %s как подкуп',
'Когда вы проверяли свои карманы вы нашли %s %s',
'Вы выслали Мэдди пару колясок, он вам отплатил %s %s',
"Выдав пару еды Mr0Maks'y он вам отплатил %s %s",
'Вы хотели купить админа на ивенте но вместо этого вы заработали %s %s',
'Этим утром вам бабушка оставила %s %s . Спасибо бабуль',
'Вы сыграли на гитаре , притом хуево, но глухо немые дали вам %s %s',
'Получив %s %s вы стали говорить что короновирус везде',
'%s %s было выдано вам за то что вы переспали с кем то из списка геев',
"Вы дали heler'y пирожное и он отблагодорил вас и дал %s %s",
'Вы заметили как дружок пишет какую то хуето и украли у него пирог, продав его вы получаете %s %s',
'Вы увидели как Джасио сломал серв и естественно вы написали репорт. Он сломал вам кошелёк на %s %s',
'Вы устроились работать бухгалтером, но даже там начали абузить. Однако абуз прошел успешно, ваша прибыл составила %s %s'
}

local work_text_profit_count = #work_text_profit

local work_text_bad = {
'Вы не сделали домашку и вы потеряли %s %s самый худший день.',
'Ваш вибратор сломался и вы заплатили %s %s на починку',
'Ваш вибратор поджегся во время работы и вы заплатили %s %s на операцию',
'Вас забрали в дурку,вы заплатили %s %s что бы выйти',
'Вы потратили деньги на турнир в xash3D и проиграли %s %s',
'Вы сыграли в brawl stars, теперь вы должны дать %s %s на лечение психики',
'Сыграв  cs go  вы дали %s %s на лечение своей психики',
'Вы зашли в казино и проебали %s %s . Ебаный в рот это казино блять!',
'Ваш селикон застрял и вы должны дать хирургу %s %s на операцию',
'Вы украли у медди коляску, он вас отпиздил и украл %s %s',
'Короновирус теперь в вашей крови и вы выкинули %s %s просто так',
'Вы сказали что онимэ гавно и поплатились на %s %s',
'Поздравляем вы поменяли гендер за %s %s .',
'Теперь вы являетесь суперадмином и должны работать за свои деньги вот первый сбор %s %s',
'Крипер убил вас сзади и вы заплатили %s %s чтобы восстановить ресы',
'Вас выебали, теперь вы должны %s %s для операции против беременности',
'Для того чтобы заработать на стрип тиз клубе вы дали %s %s за костюм мед сестры',
'Вы попросили Газамбыча дать в долг, но как всегда получилось наоборот, теперь он вам должен %s %s',
'Вы увидели как Джасио сломал серв и естественно вы написали репорт. Он сломал вам кошелёк на %s %s',
'Мэдди забанил вас на год, откуп стоил %s %s',
'Вы подарили хелеру компудахтер из 90-х, вам это обошлось в %s %s',
'Вы проспорили что Брайн не пойдет играть в сцп. Случилось чудо... ,но вы проиграли %s %s'
}

local work_text_bad_count = #work_text_bad

local function economy_work(msg, argv, args)

local profit = (math.random(0, 500) > 100)

local userid = msg.author.id

local money = math.random(69, 768)

if profit == true then
	local embed = Embed:new(nil, string.format(work_text_profit[math.random(1, work_text_profit_count)], money, economy_smile), 3586419, {icon_url = cl.user.avatarURL,text = cl.user.tag}, {icon_url = msg.author.avatarURL,name = msg.author.tag})
	msg.channel:send{embed = embed:get()} --(string.format(work_text_profit[math.random(1, work_text_profit_count)], money, economy_smile))
	economy_insert_balance(userid, money)
	return
else
	msg.channel:send(string.format(work_text_bad[math.random(1, work_text_bad_count)], money, economy_smile))
	economy_insert_balance(userid, money * -1)
	return
end
end

function economy_money(msg, argv, args)
local userid = msg.author.id
local embed = Embed:new(nil, string.format('На счету %s %s', economy_get_balance(userid), economy_smile), 3586419, {icon_url = cl.user.avatarURL,text = cl.user.tag}, {icon_url = msg.author.avatarURL,name = msg.author.tag})
msg.channel:send{embed = embed:get()}

end

command_handler.register('eco', 'Экономика', 'money / work', false, function (msg, argv, args)
	local userid = msg.author.id
	if argv[2] == nil then msg.channel:send('Недостаточно аргументов') return end
	if argv[2] == 'money' then economy_money(msg, argv, args) return end
	if argv[2] == 'work' then economy_work(msg, argv, args) return end
end)
