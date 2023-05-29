shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield



fx_version 'cerulean'
game 'gta5'
version '2.0.0'
lua54 'yes'

ui_page 'nui/index.html'
files {
    'nui/**'
}

client_scripts {

    -- Config
    'shared/Config.lua',
    
    -- Client classes
    'client/classes/PedMenu.lua',
    
    -- Client main code
    'client/Main.lua'
    
}

server_scripts {

    -- Config
    'shared/Config.lua',

    -- Mysql Async dependencie
    '@oxmysql/lib/MySQL.lua',
    
    -- Server classes
    'server/classes/PedManarger.lua',
    'server/classes/Menu.lua',
    
    -- Server main code
    'server/Main.lua'

}

shared_scripts {
    '@ZCore/Import.lua'
}

escrow_ignore { 'shared/Config.lua' }
dependency '/assetpacks'