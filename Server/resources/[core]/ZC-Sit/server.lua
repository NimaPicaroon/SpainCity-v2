local seatsTaken = {}

RegisterNetEvent('ZC-Sit:takePlace')
AddEventHandler('ZC-Sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true

	TriggerClientEvent('ZC-Sit:updatePlaces', -1, seatsTaken)
end)

RegisterNetEvent('ZC-Sit:leavePlace')
AddEventHandler('ZC-Sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end

	TriggerClientEvent('ZC-Sit:updatePlaces', -1, seatsTaken)
end)
