shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield



fx_version   'cerulean'
game         'gta5'
lua54        'yes'
use_fxv2_oal 'yes'

name         'ZC-Rde'
description  'Rde resource to use with ZCore'
author 'marccdev'

shared_scripts {
    '@ZCore/Import.lua',
    './Shared/Cfg.lua',
}

client_scripts {
    './Client/*.lua',
}

server_script {
	'@oxmysql/lib/MySQL.lua',
    './Server/*.lua'
}