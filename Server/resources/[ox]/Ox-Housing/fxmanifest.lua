shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield



fx_version 'cerulean'
game 'gta5'

description 'Housing script'

authors "guillerp#1928 & Wacky#6068"


files {
	'stream/generic_texture_renderer.gfx',
	'stream/generic_texture_renderer_2.gfx'
}

shared_scripts {
    '@ZCore/Import.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'Config.lua',
	'Server/Modules/*.lua',
	'Server/*.lua',
	'Server/Classes/*.lua'
}

client_scripts {
	'Config.lua',
	'Client/*.lua',
	'Client/Modules/*.lua'
}