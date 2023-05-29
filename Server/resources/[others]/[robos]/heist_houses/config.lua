Config = {}
Config.CoordsWait = math.random(0, 0) -- Time before you receive the house coords (1 - 2 minutes).
Config.Night = {22, 5} -- Players can rob only from 20:00 to 04:00, interiors doesn't look good with day light.
Config.Lockpick = true -- Use lockpick item for door?.
Config.LockpickName = 'lockpick' -- The lockpick item.
Config.PoliceRaid = true -- Police can Raid houses?.
Config.PoliceJobName = 'police' -- Your Police job name.
Config.RandomPoliceCall = true -- Small chance to call cops when players uses the lockpick on door.
Config.PoliceRaidWithCommand = true -- Set false if you don't want a Police command to raid houses.
Config.PoliceRaidCommand = 'raid' -- Command por Police to raid the houses.
Config.CdTime = 1 -- 1 = 30 minutes, 2 = 60 minutes, 3 = 90 minutes.... Personal cooldown time for players before they can rob another house.
Config.SpawnSafe = true -- Random chance to spawn a safe.
Config.SafeRewards = { -- It will pick a random combination from this table. type = 'item' or 'cash'
	[1] = {
		{type = 'item', itemName = 'water', itemQty = math.random(1,2)},
		{type = 'item', itemName = 'bread', itemQty = math.random(1,2)},
	},
	[2] = {
		{type = 'cash', itemName = 'cash', itemQty = math.random(1000,2000)},
	},
	[3] = {
		{type = 'item', itemName = 'rolex', itemQty = 1},
	}
}

Config.ItemsReward = { -- It will pick a random combination from this table.
	[1] = {
		{type = 'item', itemName = 'water', itemQty = math.random(1,2)},
		{type = 'item', itemName = 'bread', itemQty = math.random(1,2)},
		{type = 'item', itemName = 'water', itemQty = math.random(1,2)},
	},
	
	[2] = {
		{type = 'cash', itemName = 'cash', itemQty = math.random(100,200)},
	},
	
	[3] = {
		{type = 'cash', itemName = 'cash', itemQty = math.random(100,200)},
		{type = 'item', itemName = 'water', itemQty = 1},
	},
}

Config.Lang = {
	['knock'] = 'Presiona ~y~[E]~w~ para llamar a la puerta',
	['search'] = 'Presiona ~y~[E]~w~ para buscar',
	['enter'] = 'Presiona ~y~[E]~w~ para entrar',
	['exit'] = 'Presiona ~y~[E]~w~ para salir',
	['getjob'] = 'Obtén un trabajo',
	['waitcall'] = 'El jefe te asignará una casa, espera a que llegue la llamada.',
	['jobwait'] = 'Espera hasta que el jefe te asigne una casa',
	['assigned'] = 'El jefe te ha asignado una casa, roba la casa durante la noche',
	['wait'] = 'Relajate, el jefe está buscando una casa',
	['cooldown'] = 'No hay trabajos disponibles para ti, regresa más tarde',
	['alarm'] = 'Alarma activada',
	['lockpick'] = 'Necesitas una herramienta para poder golpear la puerta',
	['wrong_veh'] = "No puedes usar este vehículo",
	['putinveh'] = 'Presiona ~y~[E]~w~ para meter en el vehículo',
	['police_alert'] = 'Robo en progreso en la casa',
	['safe_left'] = '~y~[E]~w~ Gira a la izquierda',
	['safe_right'] = ' ~y~[F]~w~ Gira a la derecha',
	['safe_confirm'] = ' ~y~[H]~w~ Confirmar',
	['money_found'] = 'Has encontrado $'
}


RegisterNetEvent('heist_houses:notification')
AddEventHandler('heist_houses:notification', function(msg)
	W.Notify('Robo', msg, 'info')
end)

Config.Casas = { -- Houses entry and model
	{x = -762.17169189453, y = 430.80480957031, z = 100.17984771729, modelo = 'HighEnd'},
	{x = -679.01800537109, y = 512.04656982422, z = 113.52597808838, modelo = 'HighEnd'},
	{x = -640.71325683594, y = 520.20758056641, z = 110.06629943848, modelo = 'HighEnd'},
	{x = -595.52197265625, y = 530.25726318359, z = 108.06629943848, modelo = 'HighEnd'},
	{x = -526.93499755859, y = 517.22058105469, z = 113.1662979126, modelo = 'HighEnd'},
	{x = -459.220703125, y = 536.86401367188, z = 121.36630249023, modelo = 'HighEnd'},
	{x = -417.94924926758, y = 569.06427001953, z = 125.1662979126, modelo = 'HighEnd'},
	{x = -311.78060913086, y = 474.95440673828, z = 111.96630096436, modelo = 'HighEnd'},
	{x = -304.98672485352, y = 431.05224609375, z = 110.6662979126, modelo = 'HighEnd'},
	{x = -72.793998718262, y = 428.53192138672, z = 113.36630249023, modelo = 'HighEnd'},
	{x = -66.838043212891, y = 490.05136108398, z = 144.86483764648, modelo = 'HighEnd'},
	{x = -110.07062530518, y = 501.92742919922, z = 143.45491027832, modelo = 'HighEnd'},
	{x = -174.52659606934, y = 502.4521484375, z = 137.42042541504, modelo = 'HighEnd'},
	{x = -230.21437072754, y = 487.83517456055, z = 128.76806640625, modelo = 'HighEnd'},
	{x = -907.65112304688, y = 544.91998291016, z = 100.36024475098, modelo = 'HighEnd'},
	{x = -904.60345458984, y = 588.14251708984, z = 101.12745666504, modelo = 'HighEnd'},
	{x = -974.55877685547, y = 581.84942626953, z = 103.14652252197, modelo = 'HighEnd'},
	{x = -1022.719909668, y = 586.90777587891, z = 103.4294052124, modelo = 'HighEnd'},
	{x = -1107.4542236328, y = 594.22204589844, z = 104.45043945312, modelo = 'HighEnd'},
	{x = -1125.4201660156, y = 548.62109375, z = 102.56945037842, modelo = 'HighEnd'},
	{x = -1146.5546875, y = 545.87408447266, z = 101.89562988281, modelo = 'HighEnd'},
	{x = -595.67047119141, y = 393.24130249023, z = 101.88217926025, modelo = 'HighEnd'},
	{x = 84.95435333252, y = 561.70123291016, z = 182.73361206055, modelo = 'HighEnd'},
	{x = 232.20700073242, y = 672.14221191406, z = 189.97434997559, modelo = 'HighEnd'},
}