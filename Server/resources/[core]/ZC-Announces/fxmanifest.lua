shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version "cerulean"
game "gta5"
version "1.0.0"
author "guillerp#1928"

client_scripts {
    "client/client.lua",
}

ui_page "ui/index.html"

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/server.lua",
}

shared_scripts {
    '@ZCore/Import.lua',
    'config.lua'
}

files {
    "ui/index.html",
    "ui/script.js",
    "ui/style.css",
    "ui/srcs/*.png",
    "ui/srcs/*.otf",
    "ui/srcs/*.ttf",
}