http_backend_register('exec', function (http_json)
	local cmd =  http_json.cmd
	if cmd == nil then return http_responce_error_json("No cmd") end 
	local handle = io.popen(cmd)
	local result = handle:read('*a')
	handle:close()

return http_responce_ok_json(result)
end)
