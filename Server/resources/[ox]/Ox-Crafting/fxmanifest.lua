shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
game 'gta5'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/images/*.png'
}

shared_scripts {
    '@ZCore/Import.lua',
	'config.lua'
}

client_scripts {
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}