local currentPed = nil
local npcs = {}
local vendiendo = false
local ped

function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

CreateThread(function()
    while true do
        Wait(1000)
        ped = GetPedInFront()
    end
end)

local canNegociate = false

RegisterCommand('negociaciones', function()
	canNegociate = not canNegociate

	if canNegociate then
		W.Notify('Venta', 'Has activado las ventas a NPCS', 'verify')
	else
		W.Notify('Venta', 'Has desactivado las ventas a NPCS', 'warn')
	end
end)

CreateThread(function()
  	while true do
		local waittime = 1200

		if canNegociate then
			local player = PlayerPedId()
			local playerloc = GetEntityCoords(player)
			if ped and not vendiendo and not IsPedAPlayer(ped) and not IsPedInAnyVehicle(player) and DoesEntityExist(ped) and GetPedType(ped) ~= 28 and not DecorExistOn(cercainPed, 'SPAWNEDPED') and not IsEntityAMissionEntity(ped) and not IsPedDeadOrDying(ped) and GetSelectedPedWeapon(player) == GetHashKey('WEAPON_UNARMED') then
				local pos = GetEntityCoords(ped)
				local distance = #(pos - playerloc)
				if distance <= 2 and not CheckPedVendidoBefore(ped) then
					waittime = 0
					local pedloc = GetEntityCoords(ped)
					W.ShowText(vector3(pedloc['x'], pedloc['y'], pedloc['z'] + 1.1), '~y~Persona\n~w~Negociar', 0.6, 8)

					if IsControlJustPressed(1, 38) then
						if (IsPedInMeleeCombat(player) or IsPedSprinting(ped) or IsPedRunning(ped) or IsPedInWrithe(ped) or IsPedGettingUp(ped) or IsPedFleeing(ped) or IsEntityAMissionEntity(ped)) then
							currentPed = ped
							table.insert(npcs, ped)
							W.Notify("Venta", "La persona esta aterrorizada")
							TaskSmartFleePed(ped, PlayerPedId(), -1, -1, true, true)
							Wait(1000)
						else
							local drug = CheckDrug()
							if drug then
								W.TriggerCallback('Wave:GetPlayersJob', function(players)
									if players and #players >= Config.PoliceRequired then
										currentPed = ped
										SetEntityAsMissionEntity(ped)
										ClearPedTasksImmediately(ped)
										TaskStandStill(ped, 19.0)
										TaskStandStill(player, 19.0)
										TaskLookAtEntity(ped, player, -1, 2048, 3)
										TaskLookAtEntity(player, ped, -1, 2048, 3)
										TaskTurnPedToFaceEntity(ped, player, -1)
										TaskTurnPedToFaceEntity(player, ped, -1)
										local pedCoords = GetEntityCoords(ped)
										vendiendo = true
										CreateThread(Animation)
										local canSell = true
										CreateThread(function()
											while vendiendo do
												local dis = #(pedCoords - GetEntityCoords(PlayerPedId()))
												if dis > 2.0 then
													canSell = false
													break
												end
												Wait(500)
											end
										end)
										W.Progressbar("selling", 'Negociando...', 5000, false, true, {
											disableMovement = false,
											disableCarMovement = true,
											disableMouse = false,
											disableCombat = false,
										}, {}, {}, {}, function() -- Done
											if canSell then
												local callProbability = math.random(1, 100)
												local sellProbability = math.random(1, 100)
												if(Config.Probabilities["accept_sell"] > sellProbability)then
													TriggerServerEvent('Ox-Selling:sellDrug', drug)
												else
													W.Notify('Venta', 'El cliente no está interesado')
												end
												TaskSmartFleePed(ped, PlayerPedId(), -1, -1, true, true)
												if(Config.Probabilities["call_police"] > callProbability)then
													TriggerServerEvent('Ox-Selling:callPolice', pedCoords)
												end
											else
												W.Notify('Venta', 'Te has alejado demasiado', 'error')
											end
											table.insert(npcs, ped)
											SetPedAsNoLongerNeeded(ped)
											ClearPedTasks(PlayerPedId())
											vendiendo = false
										end, function()
											W.Notify('Venta', 'Has cancelado la acción', 'error')
											table.insert(npcs, ped)
											SetPedAsNoLongerNeeded(ped)
											ClearPedTasks(PlayerPedId())
											vendiendo = false
										end)
									else
										W.Notify('Venta', 'No puedes hacer esto ahora', 'error')
									end
								end, 'police', true)
							else
								W.Notify('Venta', 'No tienes nada para ofrecerle', 'error')
							end
						end
					end
				end
			end
		end
		
		Wait(waittime)
  	end
end)

function CheckPedVendidoBefore(p)
  local Vendido = false
  if #npcs > 8 then
    table.remove(npcs, 1)
  end
  for i,v in ipairs(npcs) do
    if(v == p) then
      Vendido = true
    end
  end
  return Vendido
end

CheckDrug = function ()
	local drug
	local haveWeed = W.HaveItem("bolsa_marihuana")
	if haveWeed > 0 then drug = {name  = "bolsa_marihuana", count = haveWeed} end
	local haveHachis = W.HaveItem("bolsa_hachis")
	if haveHachis > 0 then drug = {name  = "bolsa_hachis", count = haveHachis} end
	local haveCoke = W.HaveItem("chivato_coca")
	if haveCoke > 0 then drug = {name  = "chivato_coca", count = haveCoke} end
	local haveMeta = W.HaveItem("bolsa_meta")
	if haveMeta > 0 then drug = {name  = "bolsa_meta", count = haveMeta} end
	local haveOpium = W.HaveItem("bolsa_opio")
	if haveOpium > 0 then drug = {name  = "bolsa_opio", count = haveOpium} end
	local haveExtasis = W.HaveItem("bote_extasis")
	if haveExtasis > 0 then drug = {name  = "bote_extasis", count = haveExtasis} end
	local haveLean = W.HaveItem("lean")
	if haveLean > 0 then drug = {name  = "lean", count = haveLean} end
	return drug
end

Animation = function ()
	local pid = PlayerPedId()
	RequestAnimDict("amb@prop_human_bum_bin@idle_b")
	while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Wait(0) end

  	if currentPed ~= nil then
		TaskPlayAnim(currentPed,"amb@prop_human_bum_bin@idle_b","idle_d", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
  	end
  	TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
  	Wait(5000)
  	if currentPed ~= nil then
		StopAnimTask(currentPed, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
  	end
  	StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end