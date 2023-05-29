shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
game         'gta5'
lua54        'yes'

name         'ZC-Trunk'
description  'Trunk resource to use with ZCore'

shared_scripts {
    '@ZCore/Import.lua',
    './Shared/Cfg.lua',
}

client_scripts {
    './Client/CMain.lua'
}

server_script {
    './Server/SMain.lua'
}