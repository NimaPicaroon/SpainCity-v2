local showedEntity = nil
local _enabledDoors, _doorState = {}, {}
local pulsed = false
local _coordsToShow = nil
local text = ""

-- Configuration vars

TriggerEvent("chat:addSuggestion", "/door", ("Add a door"), {})

CreateThread(function()
    Wait(500)
    W.TriggerCallback('ZC-guille_doorlock:cb:getDoors', function(doors, state)
        _enabledDoors = doors
        _doorState = state
    end)
end)

RegisterNetEvent("guille_doorlock:client:setUpDoor", function()
    local _doorType, _distToDoor, allowedJobs, doorPin, item = "normal", 2, {}, "", ""

    CreateDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
end)

CreateDoor = function (_doorType, _distToDoor, allowedJobs, doorPin, item)
    local elements = {}

    table['insert'](elements, {label = "Door type: " .._doorType, value = "doortype"})
    table['insert'](elements, {label = "Distance to door: " .._distToDoor, value = "doordist"})
    table['insert'](elements, {label = "Add job", value = "addjob"})
    table['insert'](elements, {label = "Add pin: " ..doorPin, value = "doorpin"})
    table['insert'](elements, {label = "Add item: " ..item, value = "dooritem"})
    for k, v in pairs(allowedJobs) do
        table['insert'](elements, {label = v, value = k})
    end

    table['insert'](elements, {label = "Confirm creation", value = "conf"})

    W.OpenMenu("Creación de puertas", "menu_door", elements, function (data, name)
        W.DestroyMenu(name)
        local v = data['value']
        if v == "doortype" then
            Wait(200)
            W.OpenMenu("Creación de puertas", "menu_door", {{label = "Slider", value = "slide"},{label = "Normal", value = "normal"},{label = "Double", value = "double"}}, function (data2, name2)
                local v = data2['value']
                _doorType = v
                W.DestroyMenu(name2)
                Wait(200)
                CreateDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
            end)
        elseif v == "doordist" then
            W.OpenDialog('Distancia a la puerta', 'dist_to_door', function(dist)
                W.CloseDialog()
                if dist and tonumber(dist) then
                    _distToDoor = dist
                    Wait(200)
                    CreateDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
                else
                    W.Notify('PUERTA', 'Distancia ~r~inválida~w~', 'error')
                end
            end)
        elseif v == "addjob" then
            W.OpenDialog('Nombre del job', 'new_job', function(job)
                W.CloseDialog()
                if job and job ~= '' then
                    local jobs = allowedJobs
                    table['insert'](jobs, job)
                    CreateDoor(_doorType, _distToDoor, jobs, doorPin, item)
                else
                    W.Notify('PUERTA', 'Trabajo ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "conf" then
            addDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
            _doorType = "normal"
            _distToDoor = 2
            doorPin = ""
            allowedJobs = {}
        elseif v == "doorpin" then
            W.OpenDialog('PIN', 'new_pin', function(pin)
                W.CloseDialog()
                if pin and tonumber(pin) then
                    doorPin = tostring(pin)
                    Wait(200)
                    CreateDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
                else
                    W.Notify('PUERTA', 'PIN ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "dooritem" then
            W.OpenDialog('Nombre del item', 'new_jobitem', function(itemName)
                W.CloseDialog()
                if itemName and itemName ~= '' then
                    item = itemName
                    Wait(200)
                    CreateDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
                else
                    W.Notify('PUERTA', 'Item ~r~inválido~w~', 'error')
                end
            end)
        else
            for key, val in pairs(allowedJobs) do
                if k == tonumber(val) then
                    table['remove'](allowedJobs, k)
                end
            end
            W.DestroyMenu(name)
            Wait(200)
            CreateDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
        end
    end)
end

RegisterNetEvent("guille_doorlock:client:deleteDoor", function()
    CreateThread(function()
        while true do
            local msec = 0
            local _ped = PlayerPedId()
            local _coords = GetEntityCoords(_ped)
            local hit, coords, entity = RayCastGamePlayCamera(5000.0)
            local _found = false

            DrawLine(_coords, coords, 255, 0, 0, 255)
            W.ShowText(coords + vector3(0,0,0.5), '~y~Eliminar puerta\n~w~ [E] Elimina la puerta', 0.5, 8)
            for k, v in pairs(_enabledDoors) do
                if v['_type'] ~= "double" then
                    local _doorCoords = vector3(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'])
                    DrawMarker(28, _doorCoords, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.18, 0.18, 0.18, 255, 0, 0, 255, false, true, 2, nil, nil, false)
                else
                    local _doorCoords = vector3(v['_textCoords']['x'], v['_textCoords']['y'], v['_textCoords']['z'])
                    DrawMarker(28, _doorCoords, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.18, 0.18, 0.18, 255, 0, 0, 255, false, true, 2, nil, nil, false)
                end
            end
            if IsControlJustPressed(1, 38) then
                for k, v in pairs(_enabledDoors) do
                    if v['_type'] ~= "double" then
                        local _doorCoords = vector3(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'])
                        local _distTo = #(coords - _doorCoords)
                        if _distTo < 1 then
                            TriggerServerEvent("guille_doorlock:server:syncRemove", k)
                            _found = true
                        end
                    else
                        local _doorCoords = vector3(v['_textCoords']['x'], v['_textCoords']['y'], v['_textCoords']['z'])
                        local _distTo = #(coords - _doorCoords)
                        if _distTo < 1 then
                            TriggerServerEvent("guille_doorlock:server:syncRemove", k)
                            _found = true
                        end
                    end
                end
                if _found then
                    W.Notify('NOTIFICACIÓN', 'Puerta eliminada', 'verify')
                    break
                else
                    W.Notify('NOTIFICACIÓN', 'Puerta no encontrada', 'error')
                end
            end

            if IsControlJustPressed(1, 177) then
                W.Notify('NOTIFICACIÓN', 'Eliminado cancelado')
                break
            end
            Wait(msec)
        end
    end)
end)

RegisterNetEvent("guille_doorlock:client:removeGlobDoor", function(id)
    table['remove'](_enabledDoors, id)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetEntityDrawOutline(showedEntity, false)
    end
end)

addDoor = function(type, dist, jobs, pin, item)
    dist = tonumber(dist)
    if not dist then
        dist = 2
    end
    if type ~= "double" then
        CreateThread(function()
            while true do
                local msec = 0
                local _ped = PlayerPedId()
                local _coords = GetEntityCoords(_ped)
                local hit, coords, entity = RayCastGamePlayCamera(5000.0)   
                if IsEntityAnObject(entity) then
                    print(GetEntityModel(entity))

                    W.ShowText(coords + vector3(0,0,0.5), '~y~Añadir puerta\n~w~ [E]', 0.5, 8)
                    DrawLine(_coords, coords, 0, 255, 34, 255)
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                    if IsControlJustPressed(1, 38) then
                        local _doorCoords = GetEntityCoords(entity)
                        local _doorModel = GetEntityModel(entity)
                        local _heading = GetEntityHeading(entity)
                        local _textCoords = coords
                        TriggerServerEvent("guille_doorlock:server:addDoor", _doorCoords, _doorModel, _heading, type, _textCoords, dist, jobs, pin, item)
                        SetEntityDrawOutline(entity, false)
                        break
                    end
                    SetEntityDrawOutline(entity, true)
                else
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                end
                Wait(msec)
            end
        end)
    else
        local _doorsDobule, entities = {}, {}
        CreateThread(function()
            while true do
                local msec = 0
                local _ped = PlayerPedId()
                local _coords = GetEntityCoords(_ped)
                local hit, coords, entity = RayCastGamePlayCamera(5000.0)   
                if IsEntityAnObject(entity) then
                    for k, v in pairs(entities) do
                        SetEntityDrawOutline(v, true)
                    end
                    if #_doorsDobule ~= 2 then
                        DrawLine(_coords, coords, 0, 255, 34, 255)
                        W.ShowText(coords + vector3(0,0,0.5), '~y~Añadir puerta\n~w~ [E]', 0.5, 8)
                    else
                        DrawLine(_coords, coords, 0, 255, 34, 255)
                        W.ShowText(coords + vector3(0,0,0.5), '~y~Confirmar puertas\n~w~ [E]', 0.5, 8)
                    end
                    showedEntity = entity
                    if IsControlJustPressed(1, 38) then
                        local _doorCoords = GetEntityCoords(entity)
                        local _doorModel = GetEntityModel(entity)
                        local _heading = GetEntityHeading(entity)
                        local _textCoords = coords
                        if #_doorsDobule == 2 then
                            for k, v in pairs(entities) do
                                SetEntityDrawOutline(v, false)
                            end
                            entities = {}
                            TriggerServerEvent("guille_doorlock:server:addDoubleDoor", _doorsDobule, type, _textCoords, dist, jobs, pin)
                            _doorsDobule = {}
                            break
                        else
                            table['insert'](_doorsDobule, {coords = _doorCoords, model = _doorModel, heading = _heading})
                            table['insert'](entities, entity)
                        end
                    end
                end
                Wait(msec)
            end
        end)
    end
end

RegisterNetEvent("guille_doorlock:client:refreshDoors", function(tableToIns)
    table['insert'](_enabledDoors, tableToIns)
end)

local _selectedDoorJobs, pin, object = {}, nil, nil

CreateThread(function()
    while true do
        local isNearToDoor = false
        local msec = 800
        for k, v in pairs(_enabledDoors) do
            local _doorHash = GetHashKey(v["_doorModel"])
            local _ped = PlayerPedId()
            local _coords = GetEntityCoords(_ped)

            if v['_type'] == "normal" then
                local _doorCoords = vector3(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'])
                local _distTo = #(_coords - _doorCoords)
                if _distTo < 30 then
                    door = GetClosestObjectOfType(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'], 1.0, v["_doorModel"], false, false, false)
                    if _doorState[k] ~= nil then
                        FreezeEntityPosition(door, false)
                    else
                        FreezeEntityPosition(door, true)
                    end
                end
                if _distTo < v['dist'] then
                    door = GetClosestObjectOfType(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'], 1.0, v["_doorModel"], false, false, false)
                    _coordsToShow = vector3(v['_textCoords']['x'], v['_textCoords']['y'], v['_textCoords']['z'])
                    isNearToDoor = true
                    _selectedDoorJobs = v['jobs']
                    if v['usePin'] then
                        pin = v['pin']
                    else
                        pin = nil
                    end
                    if v['useitem'] then
                        object = v['item']
                    else
                        object = nil
                    end
                    if _doorState[k] ~= nil then
                        text = Config["strings"]['close']
                        FreezeEntityPosition(door, false)
                        if pulsed then
                            TriggerServerEvent("guille_doorlock:server:updateDoor", k, nil)
                            animatePlyDoor()
                            pulsed = false
                        end
                    else
                        FreezeEntityPosition(door, true)
                        text = Config["strings"]['open']
                        if pulsed then
                            TriggerServerEvent("guille_doorlock:server:updateDoor", k, "locked")
                            animatePlyDoor()
                            pulsed = false
                        end
                        if v['_type'] == "normal" then
                            SetEntityHeading(door, v['_heading'])
                        end
                    end

                    msec = 300
                end
            elseif v['_type'] == "double" then
                local _doorCoords = vector3(v['_doorsDouble'][1]['coords']['x'], v['_doorsDouble'][1]['coords']['y'], v['_doorsDouble'][1]['coords']['z'])
                local _doorCoords2 = vector3(v['_doorsDouble'][2]['coords']['x'], v['_doorsDouble'][2]['coords']['y'], v['_doorsDouble'][2]['coords']['z'])
                local _distTo = #(_coords - vector3(v['_textCoords']['x'], v['_textCoords']['y'], v['_textCoords']['z']))
                if _distTo < 30 then
                    _coordsToShow = vector3(v['_textCoords']['x'], v['_textCoords']['y'], v['_textCoords']['z'])
                    door1 = GetClosestObjectOfType(_doorCoords, 1.0, v['_doorsDouble'][1]['model'], false, false, false)
                    door2 = GetClosestObjectOfType(_doorCoords2, 1.0, v['_doorsDouble'][2]['model'], false, false, false)
                    if _doorState[k] ~= nil then
                        FreezeEntityPosition(door1, false)
                        FreezeEntityPosition(door2, false)
                    else
                        FreezeEntityPosition(door1, true)
                        FreezeEntityPosition(door2, true)
                        SetEntityHeading(door1, v['_doorsDouble'][1]['heading'])
                        SetEntityHeading(door2, v['_doorsDouble'][2]['heading'])
                    end
                    if _distTo < v['dist'] then
                        if v['usePin'] then
                            pin = v['pin']
                        else
                            pin = nil
                        end
                        if v['useitem'] then
                            object = v['item']
                        else
                            object = nil
                        end
                        _selectedDoorJobs = v['jobs']
                        if _doorState[k] ~= nil then
                            isNearToDoor = true
                            text = Config["strings"]['close']
                            FreezeEntityPosition(door1, false)
                            FreezeEntityPosition(door2, false)
                            if pulsed then
                                TriggerServerEvent("guille_doorlock:server:updateDoor", k, nil)
                                animatePlyDoor()
                                pulsed = false
                                pin = nil
                            end
                        else
                            isNearToDoor = true
                            FreezeEntityPosition(door1, true)
                            FreezeEntityPosition(door2, true)
                            text = Config["strings"]['open']
                            if pulsed then
                                TriggerServerEvent("guille_doorlock:server:updateDoor", k, "locked")
                                animatePlyDoor()
                                pulsed = false
                                pin = nil
                            end
                            SetEntityHeading(door1, v['_doorsDouble'][1]['heading'])
                            SetEntityHeading(door2, v['_doorsDouble'][2]['heading'])
                        end
                        msec = 300
                    end
                end
            else
                local _doorCoords = vector3(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'])
                local _distTo = #(_coords - _doorCoords)
                if _distTo < 30 then
                    door = GetClosestObjectOfType(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'], 1.0, v["_doorModel"], false, false, false)
                    if not IsDoorRegisteredWithSystem(v['_doorModel'].. "door"..k) then
                        AddDoorToSystem(v['_doorModel'].. "door"..k, v['_doorModel'], _doorCoords, false, false, false)
                    end
                    if _doorState[k] ~= nil then
                        DoorSystemSetDoorState(v['_doorModel'].. "door"..k, 0, false, false) 
                        DoorSystemSetAutomaticDistance(v['_doorModel'].. "door"..k, 30.0, false, false)
                    else
                        DoorSystemSetAutomaticDistance(v['_doorModel'].. "door"..k, 0.0, false, false)
                        DoorSystemSetDoorState(v['_doorModel'].. "door"..k, 4, false, false)
                    end
                end
                if _distTo < v['dist'] then
                    door = GetClosestObjectOfType(v['doorCoords']['x'], v['doorCoords']['y'], v['doorCoords']['z'], 1.0, v["_doorModel"], false, false, false)
                    _coordsToShow = vector3(v['_textCoords']['x'], v['_textCoords']['y'], v['_textCoords']['z'])
                    isNearToDoor = true
                    _selectedDoorJobs = v['jobs']
                    if v['usePin'] then
                        pin = v['pin']
                    else
                        pin = nil
                    end
                    if v['useitem'] then
                        object = v['item']
                    else
                        object = nil
                    end
                    if _doorState[k] ~= nil then
                        text = Config["strings"]['close']
                        DoorSystemSetDoorState(v['_doorModel'].. "door"..k, 0, false, false) 
                        DoorSystemSetAutomaticDistance(v['_doorModel'].. "door"..k, 30.0, false, false)
                        if pulsed then
                            TriggerServerEvent("guille_doorlock:server:updateDoor", k, nil)
                            animatePlyDoor()
                            pulsed = false
                        end
                    else
                        DoorSystemSetDoorState(v['_doorModel'].. "door"..k, 4, false, false)
                        DoorSystemSetAutomaticDistance(v['_doorModel'].. "door"..k, 0.0, false, false)
                        text = Config["strings"]['open']
                        if pulsed then
                            TriggerServerEvent("guille_doorlock:server:updateDoor", k, "locked")
                            animatePlyDoor()
                            pulsed = false
                        end
                    end

                    msec = 300
                end
            end
        end
        if isNearToDoor then
            if #_selectedDoorJobs > 0 then
                local job = W.GetPlayerData().job['name']
                for k, v in pairs(_selectedDoorJobs) do
                    if v == job then
                        if not show then
                            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'use_guille_doorlock')
                            show = true
                        end
                    end
                end
            end
            if pin then
                show = true
            end
            if object then
                local inventory = W.GetItemsForInventory()
                for k,v in pairs(inventory.data) do
                    if v.name == object then
                        if not show then
                            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'use_guille_doorlock')
                            show = true
                        end
                    end
                end
            end
        else
            if show then
                exports['ZC-HelpNotify']:close('use_guille_doorlock')
                show = false
            end
        end
        
        Wait(msec)
    end
end)

animatePlyDoor = function()
	CreateThread(function()
        while not HasAnimDictLoaded("anim@heists@keycard@") do
            RequestAnimDict("anim@heists@keycard@")
            Wait(1)
        end
        TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        Wait(200)
        ClearPedTasks(PlayerPedId())
	end)
end

local _nuiDone = false

-- CreateThread(function()
--     while true do
--         local msec = 800
--         if show then
--             if Config['enableNuiIndicator'] then
--                 SendNUIMessage({
--                     show = true;
--                     text = replaceColorText(text);
--                 })
--                 _nuiDone = false
--                 msec = 500
--             else
--                 msec = 3
--                 DrawTxt(_coordsToShow, text, 0.7, 8)
--             end
--         else
--             if Config['enableNuiIndicator'] then
--                 if not _nuiDone then
--                     SendNUIMessage({
--                         show = false;
--                     })
--                     _nuiDone = true
--                 end
--             end
--         end
--         Wait(msec)
--     end
-- end)

DrawTxt = function(coords, text, size, font)
    local coords = vector3(coords.x, coords.y, coords.z)

    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)

    if not size then size = 1 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(true)

    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("guille_doorlock:client:updateDoorState", function(id, type, h)
    _doorState[id] = type
end)

RegisterCommand("lockdoor", function()
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    if show then
        local _allowed = false
        if #_selectedDoorJobs > 0 then
            for k, v in pairs(_selectedDoorJobs) do
                if v == W.GetPlayerData().job['name'] then
                    _allowed = true
                end
            end
        else
            _allowed = true
        end
        if _allowed then
            pulsed = true
            return
        end
        if not allowed then
            if pin then
                W.OpenDialog('Introduce el PIN', 'intr_pin', function(pinIntr)
                    W.CloseDialog()
                    if pinIntr and tonumber(pinIntr) then
                        if pinIntr ~= pin then
                            W.Notify('PUERTA', 'PIN ~r~incorrecto~w~', 'error')
                        else
                            pulsed = true
                            pin = nil
                        end
                    else
                        W.Notify('PUERTA', 'PIN ~r~inválido~w~', 'error')
                    end
                end)
            end
            if object then
                local inventory = W.GetItemsForInventory()
                for k,v in pairs(inventory.data) do
                    if v.name == object then
                        pulsed = true
                        object = nil
                    end
                end
            end
        end
    end
end)

RegisterKeyMapping("lockdoor", "Interactuar con puertas", 'keyboard', 'E')

RayCastGamePlayCamera = function(distance)
    -- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end


replaceColorText = function(text)
    text = text:gsub("~r~", "<span class='red'>") 
    text = text:gsub("~b~", "<span class='blue'>")
    text = text:gsub("~g~", "<span class='green'>")
    text = text:gsub("~y~", "<span class='yellow'>")
    text = text:gsub("~p~", "<span class='purple'>")
    text = text:gsub("~c~", "<span class='grey'>")
    text = text:gsub("~m~", "<span class='darkgrey'>")
    text = text:gsub("~u~", "<span class='black'>")
    text = text:gsub("~o~", "<span class='gold'>")
    text = text:gsub("~s~", "</span>")
    text = text:gsub("~w~", "</span>")
    text = text:gsub("~b~", "<b>")
    text = text:gsub("~n~", "<br>")
    text = "<span>" .. text .. "</span>"
    return text
end

RotationToDirection = function(rotation)
    -- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end
