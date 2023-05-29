W = exports.ZCore:get()

RegisterNetEvent('Ox-Disparos:callPolice', function(coords, streetName)

	TriggerClientEvent('Ox-Disparos:Notify', -1, ('Una persona ha disparado un arma en ~y~'.. streetName))
	TriggerClientEvent('Ox-Disparos:InProgress', -1, coords, streetName)

end)  