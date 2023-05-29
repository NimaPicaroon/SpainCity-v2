shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
game         'gta5'
lua54        'yes'
use_fxv2_oal 'yes'

name         'ZC-Stats'
description  'Stats resource to use with ZCore'

shared_scripts {
    '@ZCore/Import.lua'
}

client_scripts {
    './Client/CMain.lua'
}

server_script {
    './Server/SMain.lua'
}

ui_page 'Ui/Index.html'

files {
    'Ui/Index.html',
    'Ui/Script.js',
    'Ui/Style.css',
    'Ui/Assets/BOXEDROUND.TTF',
    'Ui/Assets/wave.png'
}