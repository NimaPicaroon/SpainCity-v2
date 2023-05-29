shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version 'cerulean'

game        'gta5'
lua54       'yes'

name        'ZCore'
description 'Lightweight roleplay-oriented framework for FiveM written in LUA, used in WaveCommunity!'
version     '0.0.1'

client_scripts {
    './Client/CMain.lua',

    './Client/Modules/Functions.lua',
    './Client/Modules/Connection.lua',
    './Client/Modules/Inventory.lua',
    './Client/Modules/Logger.lua',
    './Client/Modules/Itemcreator.lua',
    './Client/Modules/Wdata.lua',
    './Client/Modules/Afk.lua',
    './Client/Modules/Peds.lua',
    './Client/Config.lua',
}

server_scripts {

    '@oxmysql/lib/MySQL.lua',

    './Server/SMain.lua',
    './Server/ServerConfig.lua',

    './Server/Classes/Player.lua',

    './Server/Modules/Functions.lua',
    './Server/Modules/Logger.lua',
    './Server/Modules/Inventory.lua',
    './Server/Modules/Metadata.lua',
    './Server/Modules/Connection.lua',
    './Server/Modules/Saver.lua',
    './Server/Modules/Discord.lua',
    './Server/Modules/EntityHandler.lua',
    './Server/Modules/Status.lua',
    './Server/Modules/Peds.lua',
    './Server/Modules/Callbacks.lua',
    './Server/Modules/Dimensions.lua',
    './Server/Modules/Commands.lua',
    './Server/Modules/Paycheck.lua',
    './Server/Modules/Jobtable.lua',
}

shared_scripts {
    'Import.lua',
    './Shared/Config.lua',
}

ui_page 'Ui/Index.html'

files {
    'Ui/Index.html',
    'Ui/Script.js',
    'Ui/Index.css',
    'Ui/Assets/*.TTF',
    'Ui/Assets/*.png'
}