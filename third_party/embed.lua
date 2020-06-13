-- Code for Natsuki to work with Discordia embed by Mr0maks

local discordia = disc --require('discordia')
local client = cl

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

function Embed:initialize(msg, title, description, color, fields )
  self.table = {
		title = title,
		description = description,
		author = {
			icon_url = msg.author.avatarURL,
			name = msg.author.tag
		},
		footer = {
			icon_url = cl.user.avatarURL,
			text = cl.user.tag
		},
		color = color,
		fields = fields,
		timestamp = discordia.Date():toISO('T', 'Z')
	}

	if fields == nil then self.table.fields = {} end
	--if footer == true then self.table.footer = {icon_url = discordia.Client.user.avatarURL, text = discordia.Client.user.tag} end
end

function Embed:push_field(name, value)
	table.insert(self.table.fields, {name = name, value = value})
end

function Embed:get()
  return self.table
end
