local qiwi_hook_id = json.parse(io.open("config.json", "r"):read("*a"))["qiwi_hook_id"]
local donation_channel_id = json.parse(io.open("config.json", "r"):read("*a"))["donation_channel_id"]

local function code_to_text(code)
if code == 643 then return "RUB" end
if code == 978 then return "EUR" end
if code == 840 then return "USD" end
if code == 398 then return "KZT" end
return "ERROR"
end

http.createServer("0.0.0.0", 8080, function (head, body)
p(body)

if not head.method == 'POST' then return { code = 500, {"Server", "Natsuki bot"}, {"Content-Length", 11} }, "Fuck you!\n" end

local body_json = json.decode(body)

if not body_json["hookId"] == qiwi_hook_id then return { code = 200 }, "\n" end
if body_json["test"] == true then print('Test hook!') return { code = 200, {"Server", "Natsuki bot"}, {"Content-Type", "text/plain"}, {"Content-Length", 1}, }, "\n" end
if not body_json["payment"] == "SUCCESS" then return { code = 200, {"Server", "Natsuki bot"}, {"Content-Type", "text/plain"}, {"Content-Length", 1}, }, "\n" end

_G.cl:getChannel(donation_channel_id):send("Поступил донат на сумму "..body_json["payment"]["total"]["amount"].." "..code_to_text(body_json["payment"]["total"]["currency"]).." с комментарием '"..body_json["payment"]["comment"].."'")
return { code = 200, {"Server", "Natsuki bot"}, {"Content-Type", "text/plain"}, {"Content-Length", 12}, }, "Hello World\n"
end)
