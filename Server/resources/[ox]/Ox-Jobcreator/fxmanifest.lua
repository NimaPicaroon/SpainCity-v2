shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield










fx_version 'cerulean'
game 'gta5'
lua54 'yes'

exports {
	'IsHandcuffed'
}

shared_scripts {
    './Shared/Cfg.lua',
    '@ZCore/Import.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    './Server/SMain.lua',

    './Server/Modules/Logger.lua',
    './Server/Modules/Functions.lua',
    './Server/Modules/Database.lua',
    './Server/Modules/Database.js',

    './Server/Classes/Job.lua',
    './Server/Classes/Player.lua',
    './Server/Modules/Commands.lua',

    './Server/Modules/Init.lua',
    './Server/Modules/Storage.lua',
    './Server/Modules/InteractionMenu.lua',
    './Server/Modules/Paycheck.lua'
}

client_scripts {
    './Client/CMain.lua',
    './Client/Modules/NuiCallbacks.lua',
    './Client/Modules/Markers.lua',
    './Client/Modules/Functions.lua',
    './Client/Modules/EditFunctions.lua',
    './Client/Modules/Framework.lua',
    './Client/Modules/InteractionMenu.lua'
}

ui_page './Ui/Index.html'

files {
    './Ui/Js/Main.js',
    './Ui/Js/Edit.js',

    './Ui/Css/Style.css',
    './Ui/Css/Edit.css',
    './Ui/Css/Creatorpage.css',

    './Ui/Assets/*.png',

    './Ui/Index.html',
}