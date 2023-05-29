shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
use_fxv2_oal 'yes'

game 'common'
lua54 'yes'

description 'Sistema de Fumar para SpainCityRP'
author 'imsnaily'
twitter '@imsnaily'

shared_scripts {
    'core/sh_*.lua',
    'base/sh_*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'base/sv_*.lua'
}

client_scripts {
    'base/cl_*.lua'
}

dependencies {
    'ZCore',
}