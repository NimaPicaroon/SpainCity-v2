W = exports.ZCore:get()

Config = {}
Config.DispenseDict = {"mini@sprunk", "plyr_buy_drink_pt1"}
Config.PocketAnims = {"mp_common_miss", "put_away_coke"}

Config.Machines = {
	[`prop_vend_soda_01`] = {			-- machine model
		item =  {"cola"}, 				-- Database item names
		name =  {"E-Cola"}, 			-- Friendly display names
		prop =  {`prop_ecola_can`}, 	-- Props to spawn falling in machine
		price = {100}						-- Purchase prices
	},
	-- [`prop_vend_soda_02`] = {
	-- 	item = {"sprunk"},
	-- 	name = {"Sprunk"},
	-- 	prop = {`prop_ld_can_01`},
	-- 	price = {100}
	-- },
	[`prop_vend_snak_01`] = {
		item = {"chips", "doritos"},
		name = {"Patatas", "Doritos"},
		prop = {`v_ret_ml_chips2`, `v_ret_ml_chips2`},
		price = {100}
	},
}

local proximity = false
local proximitymachine = false
local waterCoolers = {-742198632}
local coordswaterproximity = vector3(0, 0, 0 + 1.0)
local machineModel = machine
local VendingObject = nil

function ReqAnimDict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end
end

function ReqTheModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

function nearVendingMachine()
	local player = PlayerPedId()
	local playerLoc = GetEntityCoords(player, 0)

	for machine, _  in pairs(Config.Machines) do
		VendingObject = GetClosestObjectOfType(playerLoc, 0.6, machine, false)
		if DoesEntityExist(VendingObject) then
			machineModel = machine
            return true
		end
	end
	return false
end

Citizen.CreateThread(function()
    local shown = false
    local shown2 = false
    local inzone2 = false
    local anim = false

    while true do
        local msec = 750
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        proximity = false
        inzone2 = false
        
        -- for i = 1, #waterCoolers do
        --     local waterCoolerPos = GetEntityCoords(GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, waterCoolers[i], false, false, false))
        --     local dist = #(vector3(pos.x, pos.y, pos.z) - vector3(waterCoolerPos.x, waterCoolerPos.y, waterCoolerPos.z))
        --     coordswaterproximity = vector3(waterCoolerPos.x, waterCoolerPos.y, waterCoolerPos.z + 1.0)

        --     if dist <= 1.5 then 
        --         msec = 0
        --         if not anim then
        --             W.ShowText(coordswaterproximity, '~y~Máquina Expendedora\n~y~1~w~ producto disponible', 0.6, 8)
        --         end

        --         if IsControlJustReleased(0, 38) then
        --             if not anim then
        --                 W.Notify('Máquina Expendedora', 'El vaso se está llenando...', 'info')
        --                 anim = true

        --                 prop_name = prop_name or 'prop_cs_paper_cup'
        --                 IsAnimated = true

        --                 Citizen.CreateThread(function()
        --                     local playerPed = PlayerPedId()
        --                     local x,y,z = table.unpack(GetEntityCoords(playerPed))
        --                     local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
        --                     local boneIndex = GetPedBoneIndex(playerPed, 18905)
        --                     AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

        --                     ReqAnimDict("mp_player_intdrink")
        --                     TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

        --                     Citizen.Wait(3000)
        --                     IsAnimated = false
        --                     ClearPedSecondaryTask(playerPed)
        --                     DeleteObject(prop)

        --                     -- Aqui va el export o lo que sea para dar un poco de agua directamente al jugador (no objeto, sinó en el status)
        --                     Citizen.Wait(1500)
        --                     anim = false
        --                 end)
                    
        --             end
        --         end
        --     end

        --     if proximity and not shown then
        --         shown = true

        --         exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_watermachines')
        --     elseif not proximity and shown then
        --         shown = false

        --         exports['ZC-HelpNotify']:close('interact_watermachines')
        --     end
        -- end

        if nearVendingMachine() then
            inzone2 = true
            msec = 0
            local player = PlayerPedId()
            local playerLoc = GetEntityCoords(player, 0)
            coordsmachine = GetEntityCoords(GetClosestObjectOfType(playerLoc, 0.6, machineModel, false))
            
            local machine = machineModel
            local machineInfo = Config.Machines[machineModel]
            local machineNames = machineInfo.name

            W.ShowText(coordsmachine, '~y~Máquina Expendedora\n~y~'..#Config.Machines[machineModel].item..'~w~ productos disponibles', 0.6, 8)
            if IsControlJustReleased(0, 38) then
                W.TriggerCallback('machines:buy', function(buyed)
                    if buyed then
                        W.Notify('Máquinas Expendedoras', 'Has pagado ~g~$'..Config.Machines[machineModel].price[1]..'~w~ por un/a ~y~'..Config.Machines[machineModel].name[1], 'verify')

                        local ped = PlayerPedId()
                        local position = GetOffsetFromEntityInWorldCoords(VendingObject, 0.0, -0.97, 0.05)
                        TaskTurnPedToFaceEntity(ped, VendingObject, -1)
                        ReqAnimDict(Config.DispenseDict[1])
                        RequestAmbientAudioBank("VENDING_MACHINE")
                        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
                        SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
                        ReqTheModel(machineInfo.prop[1])
                        SetPedResetFlag(ped, 322, true)
                        if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
                            TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(VendingObject), 0.1)
                            while not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) do
                                Citizen.Wait(2000)
                            end
                        end
                        TaskTurnPedToFaceEntity(ped, VendingObject, -1)
                        Citizen.Wait(1000)
                        TaskPlayAnim(ped, Config.DispenseDict[1], Config.DispenseDict[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
                        Citizen.Wait(2500)
                        local canModel = CreateObjectNoOffset(machineInfo.prop[1], position, true, false, false)
                        SetEntityAsMissionEntity(canModel, true, true)
                        SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
                        AttachEntityToEntity(canModel, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                        Citizen.Wait(1700)
                        ReqAnimDict(Config.PocketAnims[1])
                        TaskPlayAnim(ped, Config.PocketAnims[1], Config.PocketAnims[2], 8.0, 5.0, -1, true, 1, 0, 0, 0)
                        Citizen.Wait(1000)
                        ClearPedTasks(ped)
                        ReleaseAmbientAudioBank()
                        RemoveAnimDict(Config.DispenseDict[1])
                        RemoveAnimDict(Config.PocketAnims[1])
                        if DoesEntityExist(canModel) then
                            DetachEntity(canModel, true, true)
                            DeleteEntity(canModel)
                        end
                        SetModelAsNoLongerNeeded(machineInfo.prop[1])
                        TriggerServerEvent('ZCore:addItem', machineInfo.item[1], 1)
                    end
                end, Config.Machines[machineModel].price[1])
            end
        end

        if inzone2 and not shown2 then
            shown2 = true

            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'interact_vendingmachines')
        elseif not inzone2 and shown2 then
            shown2 = false

            exports['ZC-HelpNotify']:close('interact_vendingmachines')
        end

        Citizen.Wait(msec)
    end
end)