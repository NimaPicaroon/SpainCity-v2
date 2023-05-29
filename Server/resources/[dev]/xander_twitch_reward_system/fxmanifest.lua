shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

version '1.1.2'
author 'XanderWP <xander-fivem.tebex.io>'
description 'Twitch streamers reward system'
fx_version 'bodacious'
game 'gta5'
lua54 "yes"

shared_scripts {
    '@ZCore/Import.lua'
}

server_scripts {
    'Server/*.lua',
    'core.lua'
}

client_scripts {
    'Client/*',
    'core_c.lua'
}

files {
    'Client/index.html'
}

ui_page 'Client/index.html'

dependency '/assetpacks'