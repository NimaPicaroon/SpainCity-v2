shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
use_fxv2_oal 'yes'

game 'common'
lua54 'yes'

description 'Sistema de Robos para SpainCityRP'
type 'Ammunation'
author 'imsnaily'
twitter '@imsnaily'

shared_scripts {
    'core/sh_*.lua',
    'modules/**/sh_*.lua'
}

server_scripts {
    'modules/**/sv_*.lua'
}

client_scripts {
    'modules/**/cl_*.lua'
}

dependencies {
    'ZCore',
}