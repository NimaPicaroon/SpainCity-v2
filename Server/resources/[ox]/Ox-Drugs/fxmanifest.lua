shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'

game 'gta5'

description 'Wacky'

version '1.0.0'

shared_scripts {
    '@ZCore/Import.lua',
    'config/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

client_scripts {
	'client/main.lua',
	'client/opium.lua',
    'client/coke.lua',
    'client/hachis.lua'
}