shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Sistema de Químicos para SpainCity'

author 'LuisChR7'

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'server/*.lua',
}

client_scripts {
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'client/*.lua',
}

shared_scripts{
	'@ZCore/Import.lua',
}

dependencies {
	'ZCore',
}













