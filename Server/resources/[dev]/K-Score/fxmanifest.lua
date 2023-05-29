shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield



fx_version 'cerulean'
game 'gta5'

author 'Kilichi <josepovedaks@gmail.com>'
description 'Kilichi scoreboard script'
version '1.0.0'

shared_scripts {
    '@ZCore/Import.lua',
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'ui/index.html'

files {
    'ui/*.js',
    'ui/*.css',
    'ui/*.html',
}