local ChangeSit = true

CreateThread(function()
	SetPlayerCanDoDriveBy(PlayerId(), true)
	SetPedCombatAttributes(PlayerPedId(), 2, true)
	while true do
		local wait = 1000
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) and ChangeSit then
			wait = 600
			SetPedConfigFlag(ped, 35, false)

			local veh = GetVehiclePedIsIn(ped, false)
			if GetIsTaskActive(ped, 2) == false and GetPedInVehicleSeat(veh, 0) == ped and IsVehicleSeatFree(veh, -1) then
				wait = 250
				SetPedIntoVehicle(ped, veh, 0)
			end
		end
		Citizen.Wait(wait)
	end
end)

RegisterCommand("asiento", function(source)
  ChangeSit = not ChangeSit
  Wait(10000)
  ChangeSit = not ChangeSit
end, false)