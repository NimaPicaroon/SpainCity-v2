shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'

game 'gta5'

description 'ZC-Chat'
author 'imsnaily :)'
version '0.0.2'

shared_scripts {
    -- @shared
    '@ZCore/Import.lua',

    -- @settings
    'settings.lua',
    'conf/chat.lua'
}

client_scripts {
    -- @main
    'client/main.lua'
}

server_scripts {
    -- @main
    'server/main.lua'
}