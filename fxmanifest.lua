fx_version 'adamant'

game 'gta5'

description 'agent immo custom mirror RP'

version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

dependencies {
	'es_extended',
	'esx_property',
	'esx_addonaccount',
	'esx_society'
}
