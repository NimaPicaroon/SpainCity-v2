shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54        'yes'

client_scripts  {'Client/CMain.lua', "Client/Damages.lua", "Client/Cleaner.lua"}
server_scripts  {'Server/SMain.lua'}

ui_page 'Ui/Index.html'

files {
    'Ui/*.html',
    'Ui/*.css',
    'Ui/*.js',
    'Ui/Assets/*.ttf',
    'Ui/Assets/*.png',
}

shared_scripts {
    -- @shared
    '@ZCore/Import.lua'
}