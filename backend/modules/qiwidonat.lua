local qiwi_hook_id = config["qiwi_hook_id"]

local http_callback = nil;

http_backend_register('qiwi/set_callback', function (http_json)
	local server = http_json.callback
	return http_responce_ok_json("ok")
end

http.createServer("0.0.0.0", 8080, function (head, body)
--p(body)

if not head.method == 'POST' then return { code = 500, {"Server", "Natsuki bot"}, {"Content-Length", 11} }, "Fuck you!\n" end

local body_json = json.decode(body)

if not body_json["hookId"] == qiwi_hook_id then return { code = 200 }, "\n" end
if body_json["test"] == true then print('Test hook!') return { code = 200, {"Server", "Natsuki bot"}, {"Content-Type", "text/plain"}, {"Content-Length", 1}, }, "\n" end
if not body_json["payment"] == "SUCCESS" then return { code = 200, {"Server", "Natsuki bot"}, {"Content-Type", "text/plain"}, {"Content-Length", 1}, }, "\n" end

donation_new( body_json["payment"]["total"]["amount"], body_json["payment"]["total"]["currency"], body_json["payment"]["comment"], body_json["payment"]["txnId"], body_json["payment"]["date"] )

return { code = 200, {"Server", "Natsuki bot"}, {"Content-Type", "text/plain"}, {"Content-Length", 12}, }, "Hello World\n"
end)
