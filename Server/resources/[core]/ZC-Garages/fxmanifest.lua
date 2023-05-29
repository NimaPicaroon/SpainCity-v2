shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield
 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
use_fxv2_oal 'yes'

game 'common'
lua54 'yes'

description 'Sistema de Garajes para SpainCityRP'
author 'imsnaily'
twitter '@imsnaily'

shared_scripts {
    'names.lua',

    'core/sh_*.lua',
    'modules/**/sh_*.lua'
}

server_scripts {
    'modules/**/**/class_*.lua',
    'modules/**/sv_*.lua'
}

client_scripts {
    'modules/**/cl_*.lua',
}

dependencies {
    'ZCore',
}