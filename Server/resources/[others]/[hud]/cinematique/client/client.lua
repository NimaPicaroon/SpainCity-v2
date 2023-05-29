local hasCinematic = false

RegisterNetEvent('bandas')
AddEventHandler('bandas', function()
	hasCinematic = not hasCinematic
	SendNUIMessage({openCinema = hasCinematic})
end)
