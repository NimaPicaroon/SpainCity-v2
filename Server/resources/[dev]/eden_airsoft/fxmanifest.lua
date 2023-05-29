shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

name 'Eden Airsoft/Paintball Script'
author 'Yisus#6342'
description 'Airsoft Multiplayer Script with custom weapons and custom maps'
discord 'https://discord.gg/development'

ui_page "html/index.html"

files {
    'html/index.html',
    'html/assets/css/style.css',
    'html/assets/imgs/*.*',
    'html/assets/weapons/*.*',
    'html/assets/js/*.*',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locale.lua',
}

client_scripts {
    'client/bridge/*.lua',
    'client/client.lua',
    'client/death.lua'
}

server_scripts {
    'server/bridge/*.lua',
    'server/routingBuckets.lua',
    'server/server.lua',
}

escrow_ignore {
    'config.lua',
    'locale.lua',
    'client/bridge/*.lua',
    'server/bridge/*.lua',
}

dependencies {
    'ox_lib'
}

dependency '/assetpacks'