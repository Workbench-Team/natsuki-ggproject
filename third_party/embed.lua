-- Mini Addon For Discrordia to work with embed by Mr0maks

local discordia = disc --require('discordia')

local core = require("core")
local Object = core.Object

_G.Embed = Object:extend()
local author = Object:extend()
local footer = Object:extend()

function author:initialize(icon_url, name)
	self.table = { icon_url = icon_url, name = name }
end

function author:get()
	return self.table
end

function Embed:initialize(title, description, color, footer, author, fields )
  self.table = {
		title = title,
		description = description,
		author = author,
		footer = footer,
		color = color,
		fields = fields,
		timestamp = discordia.Date():toISO('T', 'Z')
	}

	if fields == nil then self.table.fields = {} end
	--if footer == true then self.table.footer = {icon_url = discordia.Client.user.avatarURL, text = discordia.Client.user.tag} end
end

function Embed:push_field(name, value)
	local count = #self.table.fields
	if count == 0 then self.table.fields[1] = {name = name, value = value} else self.table.fields[count + 1] = {name = name, value = value} end
end

function Embed:get()
  return self.table
end
