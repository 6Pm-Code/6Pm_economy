


fx_version 'cerulean'
games { 'gta5' }

author 'Jason'
description '6pm_ECONOMY !'
version '1.0'

lua54 'yes'


server_scripts {
	'server.lua',
	"@oxmysql/lib/MySQL.lua",
    "@mysql-async/lib/MySQL.lua",
}

escrow_ignore {
	'server.lua'
}