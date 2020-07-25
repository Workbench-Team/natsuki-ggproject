# Natsuki Discord bot
Natsuki is a discord bot of GG project and dedicated firstly for GG project
Some modules need to rewrite to work with configs and be adaptive for any bot

### GG project info
The project is dedicated to creating unique servers on the Internet. Of course, all servers can be unique, but we try to make them as unique and interesting as possible.

# Features
  - Read and reply DM
  - Simple command handler
  - Embed generator
  - Privileges (need to rewrite)
  - Read `modules/list.lua` to know all features

### TODO
  - New privileges system
  - Votes for GG Events
  - Automatic check reviews of GG Project
  - Rewrite voice module for any stream
  - Archive of appelas of GG project
  - Command to give clan roles for clan owners of GG project
  - Write all servers where bot is

## Install and config

### Install and launch
```sh
  $ git clone https://github.com/GG-Project/natsuki.git
  $ cd natsuki/
  $ luvit natsuki.lua
```

### Dependencies
To launch bot you need [discordia](https://github.com/SinisterRectus/discordia) library, that works on [luvit](http://luvit.io). Just follow instructions on discordia repository, how to install it

### Configs

Before launch bot, create `config.json` in home folder and config token for it:
```json
{
  "token": "Token of your discord bot",
  "example_backend_url": "http://127.0.0.1:1080/api/"
}
```
Other configs in that `config.json` requires with some modules

To disable some modules you need to comment lines in `modules/list.lua`

Configs, that allows to use some modules:
  - `backend_url`, `backend_token` - `admin`, `privileges`, `accounts_link`
  - `qiwi_hook_id` - `qiwidonat`
  - `economy_smile`, `economy_curse_in` - `economy`
  - `donation_channel_id` - `money`

### Privileges
`groups.lua` config for `admin` module:
```lua
groups = {
  ['discord_user_id'] = 'owner',
  ['other_discord_user_id'] = 'admin'
}
```

## Backend
To work with backend, you need to config and launch backend server from [this repository](https://github.com/GG-Project/backend)

### Config
Just create `config.json` with following configs:
```json
{
  "listen_port": "backend server port",
  "tokens": ["backend token 1", "backend token 2", "and more tokens"],
  "privilege_servers": ["server_name_1", "server_name_2"],
  "mysql_db_host": "database_remote_ip",
  "mysql_db_port": 3306,
  "mysql_db_user": "database_user",
  "mysql_db_password": "database_user_password",
  "mysql_db_name": "database_name"
}
```

### Launch
```sh
  $ cd backend/
  $ luvit http.lua
```

# License
[GNU General Public License v3.0](https://github.com/ProfessorBrain/natsuki/blob/master/LICENSE)
