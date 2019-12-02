discordia = require('discordia')
client = discordia.Client()
http = require('coro-http')
qs = require('querystring')
json = require('json')
timer = require('timer')
discordia.extensions()
prefix = '.'
version = '0.0'
token = json.decode(io.open("token.json", "r"):read("*a"))["value"]
