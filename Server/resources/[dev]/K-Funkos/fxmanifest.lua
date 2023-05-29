shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }

author 'Jose Poveda <jospovsab@alu.edu.gva.es>'
description 'Toys System'
version '1.0.0'

shared_scripts {
    '@ZCore/Import.lua',
    'src/Config.lua'
}

client_scripts {
    'src/Client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'src/Server/*.lua'
}
