shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'

game 'gta5'

description 'ZC-Gym'
author 'Wacky'
version '0.0.2'

shared_scripts {
    -- @shared
    '@ZCore/Import.lua',

    -- @settings
    'settings.lua',
    'conf/gym.lua'
}

client_scripts {
    -- @controllers
    'client/controllers/gym.lua',
    'client/controllers/speed.lua',
    
    -- @main
    'client/main.lua'
}

server_scripts {
    -- @main
    'server/main.lua'
}

ui_page 'Ui/Index.html'

files {
    'Ui/Assets/*.png',
    'Ui/Assets/*.ttf',
    'Ui/*.html',
    'Ui/*.js',
    'Ui/*.css',
}