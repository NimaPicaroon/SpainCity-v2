shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield


fx_version 'cerulean'
game 'gta5'

author ''
description ''
version '0.1.0'

ui_page('html/index.html')

files({
    'html/index.html',
	'html/sounds/On.ogg',
	'html/sounds/Upgrade.ogg',
	'html/sounds/Off.ogg',
	'html/sounds/Downgrade.ogg',
	'html/sounds/beep.wav'
})

client_script 'client.lua'
server_script 'server.lua'