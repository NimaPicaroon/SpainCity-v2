shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
game         'gta5'
lua54        'yes'

name         'Ox-Banking'
description  'Banking resource to use with Wave'

shared_scripts {
    '@ZCore/Import.lua'
}

client_scripts {
    './Client/CMain.lua',
    './Config/Config.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    './Server/SMain.lua'
}

ui_page 'Ui/Index.html'

files {
    'Ui/Index.html',
    'Ui/Script.js',
    'Ui/Style.css',
    'Ui/Assets/BOXEDROUND.TTF',
    'Ui/Assets/MYRIADPRO-REGULAR.woff',
    'Ui/Assets/bank.png',
    'Ui/Assets/bank2.png'
}