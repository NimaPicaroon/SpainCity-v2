shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
game         'gta5'
lua54        'yes'

name         'ZC-Ambulance'
description  'Ambulance resource '

shared_scripts {
    '@ZCore/Import.lua',
    './Shared/Cfg.lua',
}

client_scripts {
    './Client/CUtils.lua',
    './Client/CMain.lua',
    './Client/Beds.lua',
    './Client/Items.lua',
    './Client/Loops.lua'
}

server_script {
    './Server/SMain.lua'
}

ui_page 'Ui/Index.html'

files {
    'Ui/Assets/*.png',
    'Ui/Assets/*.ttf',
    'Ui/*.html',
    'Ui/*.js',
    'Ui/*.css',
}