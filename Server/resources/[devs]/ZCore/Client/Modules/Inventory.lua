W.Inventory = {}
W.Inventory.__Index = W.Inventory

W.Inventory.Items = {}
W.Inventory.Drops = {}
W.Inventory.Objects = {}

-- DROPS
RegisterNetEvent('ZCore:addDrop', function(dropId, id, name, label, quantity, slotId, dataCoords)
    local ped = GetPlayerPed(GetPlayerFromServerId(id))

    if #W.Inventory.Drops == 0 then
        W.InitDrops()
    end

    W.Inventory.Drops[dropId] = {
        id = dropId,
        coords = {
            x = dataCoords.x,
            y = dataCoords.y,
            z = dataCoords.z,
        },
        name = name,
        slotId = slotId,
        quantity = quantity,
        label = label
    }

    local prop = CreateObject((W.Props[name] ~= nil and GetHashKey(W.Props[name])) or GetHashKey('prop_paper_bag_small'), W.Inventory.Drops[dropId].coords.x, W.Inventory.Drops[dropId].coords.y, W.Inventory.Drops[dropId].coords.z, false)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop)
    SetEntityCollision(prop, false, true)
    PlaceObjectOnGroundProperly(prop)
    W.Inventory.Objects[dropId] = prop
    TriggerServerEvent('ZCore:newDrops', W.Inventory.Drops, W.Inventory.Objects)
end)
RegisterNetEvent("ZCore:GetVehicleType", function(Model, Request)
	local Model = Model
	local VehicleType = GetVehicleClassFromName(Model)
	local type = "automobile"
	if VehicleType == 15 then
		type = "heli"
	elseif VehicleType == 16 then
		type = "plane"
	elseif VehicleType == 14 then
		type = "boat"
	elseif VehicleType == 11 then
		type = "trailer"
	elseif VehicleType == 21 then
		type = "train"
	elseif VehicleType == 13 or VehicleType == 8 then
		type = "bike"
	end
	if Model == `submersible` or Model == `submersible2` then
		type = "submarine"
	end
	TriggerServerEvent("esx:ReturnVehicleType", type, Request)
end)
RegisterNetEvent('ZCore:addDropMoney', function(dropId, id, type, quantity, dataCoords)
    if #W.Inventory.Drops == 0 then
        W.InitDrops()
    end

    local label = 'Dinero'

    W.Inventory.Drops[dropId] = {
        id = dropId,
        coords = {
            x = dataCoords.x,
            y = dataCoords.y,
            z = dataCoords.z,
        },
        name = type,
        quantity = quantity,
        label = label
    }

    if tonumber(quantity) >= 1000 then
        local prop = CreateObject(GetHashKey('h4_prop_h4_cash_bag_01a'), W.Inventory.Drops[dropId].coords.x, W.Inventory.Drops[dropId].coords.y, W.Inventory.Drops[dropId].coords.z, false)
        FreezeEntityPosition(prop, true)
        SetEntityAsMissionEntity(prop)
        SetEntityCollision(prop, false, true)
        PlaceObjectOnGroundProperly(prop)
        W.Inventory.Objects[dropId] = prop
    elseif tonumber(quantity) >= 300 then
        local prop = CreateObject(GetHashKey('bkr_prop_money_wrapped_01'), W.Inventory.Drops[dropId].coords.x, W.Inventory.Drops[dropId].coords.y, W.Inventory.Drops[dropId].coords.z, false)
        FreezeEntityPosition(prop, true)
        SetEntityAsMissionEntity(prop)
        SetEntityCollision(prop, false, true)
        PlaceObjectOnGroundProperly(prop)
        W.Inventory.Objects[dropId] = prop
    else
        local prop = CreateObject(GetHashKey('p_banknote_onedollar_s'), W.Inventory.Drops[dropId].coords.x, W.Inventory.Drops[dropId].coords.y, W.Inventory.Drops[dropId].coords.z, false)
        FreezeEntityPosition(prop, true)
        SetEntityAsMissionEntity(prop)
        SetEntityCollision(prop, false, true)
        PlaceObjectOnGroundProperly(prop)
        W.Inventory.Objects[dropId] = prop
    end

    TriggerServerEvent('ZCore:newDrops', W.Inventory.Drops, W.Inventory.Objects)
end)

RegisterNetEvent('ZCore:dropAnim', function()
    local ped = PlayerPedId()

    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Wait(5)
    end
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" , 49.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
end)

RegisterNetEvent('ZCore:removeDrop', function(dropId)
    W.Inventory.Drops[dropId] = nil
    DeleteObject(W.Inventory.Objects[dropId])
    W.Inventory.Objects[dropId] = nil
end)

RegisterNetEvent('ZCore:createDrops', function(Drops, Objects)
    W.Inventory.Drops = Drops
    W.Inventory.Objects = Objects
end)

local closestDrop = nil

W.InitDrops = function ()
    CreateThread(function()
        local inZone = false
        local shown = false

        while true do
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            inZone = false

            for k,v in next, W.Inventory.Drops do
                local dist = #(playerPos - vector3(v.coords.x, v.coords.y, v.coords.z))

                if dist <= 1.25 then
                    closestDrop = k
                    inZone = true
                end
            end

            if inZone and not shown then
                shown = true
                exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para recoger', 'interact_pickups')
            elseif not inZone and shown then
                shown = false
                exports['ZC-HelpNotify']:close('interact_pickups')
            end

            Wait(500)
        end
    end)

    CreateThread(function()
        while true do
            local msec = 1000
            local pos = GetEntityCoords(PlayerPedId(), true)

            if closestDrop and W.Inventory.Drops[closestDrop] then
                local dist = #(pos - vector3(W.Inventory.Drops[closestDrop].coords.x, W.Inventory.Drops[closestDrop].coords.y, W.Inventory.Drops[closestDrop].coords.z))

                if dist <= 1.25 then
                    msec = 0

                    if IsControlJustPressed(0, 246) then --Y
                    
                        local playersNearby = W.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
                        if #playersNearby == 0 then
                            shown = false
                            inZone = false
                            exports['ZC-HelpNotify']:close('interact_pickups')
                            TriggerServerEvent('ZCore:pickupDrop', closestDrop)
                            closestDrop = nil

                            if #W.Inventory.Drops < 1 then
                                break
                            end
                        else
                            W.Notify('NOTIFICACION', 'Hay alguien cerca tuyo', 'error')
                            goto continue
                        end
                    end
                end
                
                ::continue::
            end
            Wait(msec)
        end
    end)
end

RegisterNetEvent('ZCore:giveAnimation', function(name, anim, src)
	if not HasAnimDictLoaded('mp_common') then
		RequestAnimDict('mp_common')
		while not HasAnimDictLoaded('mp_common') do
			Citizen.Wait(1)
		end
	end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if src then
        local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(src)))
        SetEntityHeading(ped, heading - 180)
    end

	TaskPlayAnim(ped, 'mp_common', anim, 8.0, -8, -1, 2, 0, 0, 0, 0)

    if anim == 'givetake1_a' then
        Citizen.Wait(500)
        local prop = CreateObject(GetHashKey(W.Props[name]), coords.x, coords.y, coords.z, true)
        FreezeEntityPosition(prop, true)
        SetEntityAsMissionEntity(prop)
        SetEntityCollision(prop, false, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
        Citizen.Wait(1000)
        DeleteEntity(prop)
        Citizen.Wait(1500)
        ClearPedTasks(ped)
    else
        Citizen.Wait(1500)
        local prop = CreateObject(GetHashKey(W.Props[name]), coords.x, coords.y, coords.z, true)
        FreezeEntityPosition(prop, true)
        SetEntityAsMissionEntity(prop)
        SetEntityCollision(prop, false, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
        Citizen.Wait(1500)
        DeleteEntity(prop)
        ClearPedTasks(ped)
    end
end)