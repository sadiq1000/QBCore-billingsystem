fx_version 'adamant'

game 'gta5'

author 'Farhan Sadiq🔥#5825'
description 'sadiqBilling'

ui_page 'web/ui.html'

files {
	'web/*.*'
}

shared_script 'config.lua'

client_scripts {
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}
