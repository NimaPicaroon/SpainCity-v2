shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
game 'gta5'

client_scripts {
	'client/*.lua'
}

shared_scripts {
    '@ZCore/Import.lua',
	'config/*.lua',
}

server_scripts {
	'server/*.lua',
	'@mysql-async/lib/MySQL.lua'
}
