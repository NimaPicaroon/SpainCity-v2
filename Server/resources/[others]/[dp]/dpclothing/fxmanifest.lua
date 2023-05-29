
fx_version 'cerulean'

game 'gta5'

description 'DpClothing'
version '0.0.2'

shared_scripts {
    -- @shared
    '@ZCore/Import.lua'
}

client_scripts {
    'Client/Functions.lua', 		-- Global Functions / Events / Debug and Locale start.
	'Client/Config.lua',			-- Configuration.
	'Client/Variations.lua',		-- Variants, this is where you wanan change stuff around most likely.
	'Client/Clothing.lua',
	'Client/GUI.lua',				-- The GUI.
}