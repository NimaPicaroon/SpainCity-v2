shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version   'cerulean'
game         'gta5'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'Server/SMain.lua'
}

client_scripts {
	'Config.lua',
    'Client/CMain.lua',
	'Client/Modules/*.lua'
}

shared_scripts {
    '@ZCore/Import.lua'
}

exports {
	'CanUseWeapons',
    'SetGears',
    'RemoveGears'
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