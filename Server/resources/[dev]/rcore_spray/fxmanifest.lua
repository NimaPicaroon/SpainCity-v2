shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'rcore spray'

version '1.1.0'

shared_scripts {
    '@ZCore/Import.lua'
}

client_scripts {
	'config.lua',
	'client/warmenu.lua',
	'client/fonts.lua',
	'client/determinant.lua',
	'client/raycast.lua',
	'client/client.lua',
	'client/spray_rotation.lua',
	'client/control.lua',
	'client/remove.lua',
	'client/time.lua',
	'client/cancellable_progress.lua',
}

server_scripts {
	'config.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/db.lua',
	'server/server.lua',
	'server/remove.lua',
}