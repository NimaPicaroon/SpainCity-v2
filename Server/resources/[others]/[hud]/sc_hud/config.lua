Config = {}

Config.Locale = 'br'

Config.serverLogo = 'https://i.imgur.com/yQudmOZ.png'

Config.font = {
	name 	= 'Do Hyeon',
	url 	= 'https://fonts.googleapis.com/css?family=Do+Hyeon:300,400,700,900&display=swap'
}

Config.date = {
	format	 	= 'default',
	AmPm		= false
}

Config.voice = {

	levels = {
		default = 5.0,
		shout = 12.0,
		whisper = 1.0,
		current = 0
	},
	
	keys = {
		distance 	= '~',
	}
}


Config.vehicle = {
	speedUnit = 'KMH',
	maxSpeed = 240,

	keys = {
		seatbelt 	= 'M',
		cruiser		= '-',
		signalLeft	= 'LEFT',
		signalRight	= 'RIGHT',
		-- signalBoth	= 'RIGHTCTRL',
	}
}

Config.ui = {
	showServerLogo		= true,

	showJob		 		= true,

	showWalletMoney 	= true,
	showBankMoney 		= true,
	showBlackMoney 		= true,
	showSocietyMoney	= true,
	showExpBar			= false,
	showNivelBar		= false,
	showText			= false,

	showDate 			= false,
	showLocation 		= false,
	showVoice	 		= false,
	showVoiceText       = false,

	showHealth			= false,
	showArmor	 		= false,
	showStamina	 		= false,
	showHunger 			= false,
	showThirst	 		= false,

	showMinimap			= true,

	showWeapons			= true,	
}