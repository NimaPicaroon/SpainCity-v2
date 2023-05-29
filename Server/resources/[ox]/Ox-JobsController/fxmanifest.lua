shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield



fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

shared_scripts {
    '@ZCore/Import.lua'
}

server_scripts {
    'server/main.lua',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'client/main.lua'
}