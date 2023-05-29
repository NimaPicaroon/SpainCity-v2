shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield



--[[ FX Information ]]--
fx_version 'cerulean'
use_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--
name 'rahe-boombox'
author 'RAHE Development'
description 'RAHE Boombox'
version '1.0.0'

--[[ Manifest ]]--
dependencies {
    'oxmysql',
    'ox_lib',
    'xsound',
    '/server:5181',
    '/onesync',
}

client_scripts {
    'config/client.lua',
    'api/client.lua',
    'client/cl_*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
    'config/translations.lua',
    'shared/sh_*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/server.lua',
    'api/server.lua',
    'server/sv_*.lua',
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/translations.js',
    'nui/tailwind.css',
    'nui/alpine.js',
}

escrow_ignore {
    'api/client.lua',
    'api/server.lua',
    'config/*.lua',
}

dependency '/assetpacks'