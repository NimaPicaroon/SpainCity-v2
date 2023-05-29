shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

client_scripts {
    'Client/CMain.lua',
    'Client/Modules/*.lua'
}

server_scripts {
    'Server/SMain.lua'
}

shared_scripts {
    '@ZCore/Import.lua',
    'Config/Config.lua'
}

ui_page 'Ui/Index.html'

files {
    'Ui/Index.html',
    'Ui/Script.js',
    'Ui/Style.css',
    'Ui/Assets/BOXEDROUND.TTF',
    'Ui/Assets/*.png',
    'Ui/Assets/*.mp3'
}