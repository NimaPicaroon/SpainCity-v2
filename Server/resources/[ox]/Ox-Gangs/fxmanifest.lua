shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
use_fxv2_oal 'yes'
game         'gta5'
description 'Sistema de Bandas para SpainCityRP'
author 'Wacky'

shared_scripts {
    'core/sh_*.lua',
    'base/sh_*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'base/sv_*.lua',
    'base/classes/data.lua',
    'base/modules/Server/sv_*.lua'
}

client_scripts {
    'base/cl_*.lua',
    'base/modules/Client/cl_*.lua'
}

dependencies {
    'ZCore',
}

ui_page 'Ui/Index.html'

files {
    'Ui/Index.html',
    'Ui/Script.js',
    'Ui/Style.css',
    'Ui/Assets/*.woff',
    'Ui/Assets/BOXEDROUND.TTF',
    'Ui/Assets/*.png'
}