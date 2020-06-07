http_backend_register('exec', function (res, http_json)
	local cmd =  http_json.cmd
	if cmd == nil then return http_response_error_json("No cmd") end 
	local handle = io.popen(cmd)
	local result = handle:read('*a')
	handle:close()

return http_response_ok_json(res, result)
end)
