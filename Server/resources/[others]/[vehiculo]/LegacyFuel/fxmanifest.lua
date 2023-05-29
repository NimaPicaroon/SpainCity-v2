shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
game         'gta5'
lua54        'yes'

shared_scripts {
  '@ZCore/Import.lua'
}

server_scripts {
	'config.lua',
	'source/fuel_server.lua'
}

client_scripts {
	'config.lua',
	'functions/functions_client.lua',
	'source/fuel_client.lua'
}

exports {
	'GetFuel',
	'SetFuel'
}
