local BlipsCreated = {}
local this = {}
haveHouse = false
objectsCreated = {}
insideHouse = false
houseProp = nil
editing = false
adminMode = false
xPlayer = {}

RegisterNetEvent('ZCore:updateData', function(data)
    xPlayer = data
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)

        print('Waiting for player to load')
    end

    while not W.GetPlayerData().job do
        Wait(100)
    end

    TriggerServerEvent('housing:loaded')
end)

exports('inProperty', function()
    return insideHouse
end)

RegisterNetEvent('Ox-Housing:client:playerLoaded')
AddEventHandler('Ox-Housing:client:playerLoaded', function(Houses)
    housesData = Houses
    Wait(100)
    xPlayer = W.GetPlayerData()
    for i,j in pairs(housesData) do
        for k, v in ipairs(j.ownerData) do
            if v.owner ~= nil then
                if v.owner.identifier == xPlayer.identifier then
                    haveHouse = j.id
                end
            end
        end
    end

    TriggerEvent("Ox-Housing:client:refreshHouses", housesData)
end)

function log(txt)
    if not txt then
        print("^2"..GetCurrentResourceName().. ' [INFO] ^8 Attempting to print a nil value')
    else
        print("^2"..GetCurrentResourceName().. ' [INFO] ^8' ..txt)
    end
end

function openHouseMenu(id, coords)
    local secCoords = {}
    local isOwner = false
    for k, v in pairs(coords) do
        if v.type == "entrada" then
            coords = v.coords
        elseif v.type == "puerta" then
            table.insert(secCoords, {coords = v.coords})
        end
    end
    local elements = {}
    local houseData = housesData[id]
    if houseData.bought == 1 then
        for k, v in pairs(houseData.ownerData) do
            if v.owner ~= nil then
                if v.owner.identifier == xPlayer.identifier then
                    if not houseData.gang or houseData.gang == '' then
                        table.insert(elements, {label = "Entrar a tu propiedad", value = "access"})
                        table.insert(elements, {label = "Hacer copia de las llaves", value = "keys"})
                        table.insert(elements, {label = "Cambiar la cerradura de la propiedad", value = "change_lock"})
                        table.insert(elements, {label = "Vender propiedad", value = "sell"})
                    elseif xPlayer.gang.name == houseData.gang then
                        table.insert(elements, {label = "Entrar a tu propiedad", value = "access"})
                        table.insert(elements, {label = "Vender propiedad", value = "sell"})
                    end

                    isOwner = true
                    break
                else
                    if not houseData.gang or houseData.gang ~= '' then
                        if xPlayer.gang.name == houseData.gang then
                            table.insert(elements, {label = "Entrar a la propiedad", value = "access"})
                            isOwner = true
                        else
                            if HasHouseKeys(id) then
                                table.insert(elements, {label = "Entrar a la propiedad", value = "access"})
                                isOwner = true
                            end
                        end
                    else
                        if HasHouseKeys(id) then
                            table.insert(elements, {label = "Entrar a la propiedad", value = "access"})
                            isOwner = true
                        end
                    end
                end
            end
        end

        if not isOwner then
            table.insert(elements, {label = "Tocar al timbre", value = "timber"})
        end

        W.OpenMenu('Gestión de propiedad', "hs_menu", elements, function (data, name)
            W.DestroyMenu(name)
            if data.value then
                local v = data.value
                if v == "access" then
                    if houseData.gang == '' then
                        if(HasHouseKeys(id))then
                            accesToHouse(houseData, coords, secCoords, id)
                        else
                            W.Notify("CASA", 'No tienes las llaves de esta casa', 'error')
                        end
                    else
                        accesToHouse(houseData, coords, secCoords, id)
                    end
                elseif v == "keys" then
                    local elements2 = {
                        {label = "Si", value = "yes"},
                        {label = "No", value = "no"}
                    }
                    Wait(100)
                    W.OpenMenu('¿Seguro?', "keys_menu", elements2, function (data, name)
                        W.DestroyMenu(name)
                        if data.value then
                            local v = data.value
                            if v == "yes" then
                                if xPlayer.money.bank > 50 then
                                    TriggerServerEvent("Ox-Housing:server:giveKey", id)
                                else
                                    W.Notify("BANCO", 'No tienes suficiente dinero', 'error')
                                end
                            elseif v == "no" then
                                openHouseMenu(id, coords)
                            end
                        end
                    end)
                elseif v == "change_lock" then
                    local elements2 = {
                        {label = "Si", value = "yes"},
                        {label = "No", value = "no"}
                    }
                    local title = 'Se te cobrará 500$, ¿Aceptas?'
                    if(not houseData.key_code)then
                        title = "¿Seguro?"
                    end
                    W.OpenMenu(title, "change_lock_menu", elements2, function (data, name)
                        W.DestroyMenu(name)
                        if data.value then
                            local v = data.value
                            if v == "yes" then
                                if xPlayer.money.bank > 500 or not houseData.key_code then
                                    TriggerServerEvent("Ox-Housing:server:changeLock", id)
                                else
                                    W.Notify("BANCO", 'No tienes suficiente dinero', 'error')
                                end
                            elseif v == "no" then
                                openHouseMenu(id, coords)
                            end
                        end
                    end)
                elseif v == "sell" then
                    local elements2 = {
                        {label = "Si", value = "yes"},
                        {label = "No", value = "no"}
                    }
                    Wait(100)
                    W.OpenMenu('¿Seguro?', "sell_menu", elements2, function (data, name)
                        W.DestroyMenu(name)
                        if data.value then
                            local v = data.value
                            if v == "yes" then
                                log("Selling house")
                                if houseData.gang == '' then
                                    if (HasHouseKeys(id)) then
                                        TriggerServerEvent("Ox-Housing:server:sellHouse", id, W.Round(houseData.price/2))
                                    else
                                        W.Notify("CASA", 'No tienes las llaves de esta casa', 'error')
                                    end
                                else
                                    TriggerServerEvent("Ox-Housing:server:sellHouse", id, W.Round(houseData.price/2))
                                end
                            elseif v == "no" then
                                openHouseMenu(id, coords)
                            end
                        end
                    end)
                elseif v == "timber" then
                    TriggerServerEvent("Ox-Housing:server:attemptToAccess", id)
                end
            end
        end)
    else
        if not haveHouse then
            table.insert(elements, {label = "Comprar propiedad", value = "buy"})
            table.insert(elements, {label = "Visitar interior", value = "visit"})
            W.OpenMenu("Casa #"..id.." por " ..houseData.price.. " dólares", "buyHouse_menu", elements, function (data, name)
                W.DestroyMenu(name)
                if data.value then
                    local v = data.value
                    if v == "buy" then
                        if not houseData.gang or houseData.gang == '' then
                            OpenConfirmationMenu(id, houseData)
                        elseif houseData.gang ~= '' then
                            if xPlayer.gang.name == houseData.gang then
                                OpenConfirmationMenu(id, houseData)
                            else
                                W.Notify("Propiedad", 'No puedes comprar esta propiedad.', 'error')
                            end
                        elseif houseData.gang then
                            if xPlayer.gang.name == houseData.gang then
                                OpenConfirmationMenu(id, houseData)
                            else
                                W.Notify("Propiedad", 'No puedes comprar esta propiedad.', 'error')
                            end
                        else
                            W.Notify("Propiedad", 'No puedes comprar esta propiedad.', 'error')
                        end
                    elseif v == "visit" then
                        visitInt(houseData, coords, secCoords)
                    end
                end
            end)
        else
            W.Notify("PROPIEDAD", 'No puedes tener varias casas', 'error')
        end
    end
end

function OpenConfirmationMenu(id, houseData)
    local elements2 = {
        {label = "Si", value = "yes"},
        {label = "No", value = "no"}
    }

    Wait(100)

    W.OpenMenu('¿Seguro?', "buy_menu2", elements2, function (data, name)
        W.DestroyMenu(name)
        if data.value then
            local v = data.value
            if v == "yes" then
                if xPlayer.money.bank >= houseData.price then
                    TriggerServerEvent("Ox-Housing:server:buyHouse", id, houseData.price)
                else
                    W.Notify("BANCO", 'No tienes suficiente dinero', 'error')
                end
            elseif v == "no" then
                openHouseMenu(id, coords)
            end
        end
    end)
end

function accesToHouse(data, coordsShell, secCoords, id)
    insideHouse = true
    local wExit = false
    W.DestroyAllMenus()
    DoScreenFadeOut(1000)
    TriggerServerEvent("Ox-Housing:enterHouse", id)
    Wait(2000)
    local shellToSend = data.shell
    local found = false
    local houseHash = GetHashKey(data.shell)
    local houseShell = nil
    for k, v in pairs(Housing['points']) do
        if v.shell == data.shell then
            SetEntityCoords(PlayerPedId(), coordsShell.x + v.x, coordsShell.y + v.y, coordsShell.z + 851 + v.z)
            break
        end
    end
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(300)
    local exit = GetEntityCoords(PlayerPedId())
    RequestModel(houseHash)
    while not HasModelLoaded(houseHash) do
        RequestModel(houseHash)
        log("Loading shell....")
        Wait(1)
    end
    houseShell = CreateObject(houseHash, coordsShell.x, coordsShell.y, coordsShell.z + 850, false, false, false)
    houseProp = houseShell
    FreezeEntityPosition(houseShell, true)
    W.TriggerCallback('Ox-Housing:server:getFurni', function(furni)
        log("Loading furni...")
        for k, v in pairs(furni) do
            local hash = GetHashKey(v.object.obj)
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                RequestModel(hash)
                Wait(1)
            end
            obj = CreateObject(hash, v.object.coords.x, v.object.coords.y, v.object.coords.z, false, false, false)
            SetEntityHeading(obj, v.object.heading)
            FreezeEntityPosition(obj, true)
            table.insert(objectsCreated, {obj = obj, heading = v.object.heading, coords = vector3(v.object.coords.x, v.object.coords.y, v.object.coords.z)})
        end
    end, id)

    W.TriggerCallback('Ox-Housing:server:setWallsAndFloors', function(data)
        if data then
            for k, v in pairs(data) do
                if v.style.type == "paredes" then
                    changeWallOnLoad(shellToSend, v.style.url, id)
                    found = true
                elseif v.style.type == "suelo" then
                    changeFloorOnLoad(shellToSend, v.style.url, id)
                    found = true
                end
            end
        end
    end, id)

    if not found then
        changeWallOnLoad(shellToSend, "default", id)
        changeFloorOnLoad(shellToSend, "default", id)
    end

    CreateThread(function()
        local add = false
        local add2 = false
        local selectedObject
        local selectedObject2
        while insideHouse do
            local wait = 500

            if #objectsCreated > 0 then
                for k,v in pairs(objectsCreated) do
                    SetEntityCoords(v.obj, v.coords)
                    SetEntityHeading(v.obj, v.heading)
                end
                wait = 0
            end

            if light then
                x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
                DrawSpotLight(x, y, z + 50.0, 0.0, 0.0, -0.5, 255, 255, 255, 100.0, 40.0, 850.0, 200.0, 50.0)
                wait = 0
            end

            if pared then
                changeWallOnLoad(shellToSend, pared)
            end

            if suelo then
                changeFloorOnLoad(shellToSend, suelo)
            end

            for k,v in pairs(Housing['furni']['storage']) do
                local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v[2]), false, false, false)
                local coords = GetEntityCoords(object)
                if DoesEntityExist(object) and not editing then
                    wait = 0
                    local dist = #(coords-GetEntityCoords(PlayerPedId()))
                    if dist < 2 then
                        if not add then
                            add = true
                            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'house_storage')
                            selectedObject = v[2]
                        end
                        if IsControlJustPressed(1, 38) then
                            W.TriggerCallback('thief:isBeenSteal', function(result)
                                if not result then
                                    local ply, distance = W.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
                                    if distance < 2 and distance ~= -1 then
                                        W.Notify("ERROR", 'Tienes un jugador demasiado cerca', 'error')
                                    else
                                        OpenArmory(id)
                                    end
                                else
                                    W.Notify("ERROR", 'Te estan cacheando', 'error')
                                end
                            end, GetPlayerServerId(PlayerId()))
                        end
                    else
                        if (add and selectedObject == v[2]) then
                            W.DestroyAllMenus()
                            exports['ZC-HelpNotify']:close('house_storage')
                            add = false
                        end
                    end
                end
            end

            for k,v in pairs(Housing['furni']['ilegal']) do
                local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(v[2]), false, false, false)
                local coords = GetEntityCoords(object)
                if DoesEntityExist(object) and not editing then
                    wait = 0
                    local dist = #(coords-GetEntityCoords(PlayerPedId()))
                    if dist < 2.5 then
                        if not add2 then
                            add2 = true
                            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'house_ilegal')
                            selectedObject2 = v[2]
                        end
                        if IsControlJustPressed(1, 38) then
                            local type = v[4]
                            if type == "drugs" then
                                TriggerEvent("Ox-Drugs:drugTable", object)
                            else
                                TriggerEvent("Ox-Crafting:craftTable", object)
                            end
                        end
                    else
                        if (add2 and selectedObject2 == v[2]) then
                            W.DestroyAllMenus()
                            exports['ZC-HelpNotify']:close('house_ilegal')
                            add2 = false
                        end
                    end
                end
            end
            Wait(wait)
        end
    end)

    FreezeEntityPosition(houseShell, true)
    DoScreenFadeIn(300)
    FreezeEntityPosition(PlayerPedId(), false)
    CreateThread(function()
        local add = false
        while true do
            local wait = 750
            local ply = PlayerPedId()
            local coords = GetEntityCoords(ply)
            local dist = GetDistanceBetweenCoords(exit, coords, true)

            if dist < 6 then
                wait = 0
                DrawMarker(1, exit - vector3(0, 0, 0.70), 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 853, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                if dist < 1.3 and not editing then
                    if not add then
                        add = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'house_interior')
                    end
                    if IsControlJustPressed(1, 38) then
                        local elements = {}
                        table.insert(elements, {label = "Salir por la puerta principal", value = coordsShell})
                        for k, v in pairs(secCoords) do
                            table.insert(elements, {label = "Salir por la puerta secundaria " ..k, value = v.coords})
                        end
                        for k, v in pairs(data.ownerData) do
                            if v.owner ~= nil then
                                if v.owner.identifier == xPlayer.identifier then
                                    table.insert(elements, {label = "Añadir muebles", value = "furni"})
                                    table.insert(elements, {label = "Quitar muebles", value = "nofurni"})
                                    table.insert(elements, {label = "Cambiar estilo de la casa", value = "changePaint"})
                                    break
                                end
                            end
                        end
                        table.insert(elements, {label = "Encender/apagar luces", value = "light"})
                        table.insert(elements, {label = "Dejar entrar", value = "letIn"})
                        local dataToSend = data
                        W.OpenMenu('Que deseas hacer?', "op_menu", elements, function (data, name)
                            W.DestroyMenu(name)
                            if data.value then
                                if data.value == "furni" then
                                    posFurni(id, coordsShell, houseShell)
                                    editing = true
                                elseif data.value == "nofurni" then
                                    deleteFurni(id, coordsShell, houseShell)
                                    editing = true
                                elseif data.value == "light" then
                                    light = not light
                                    TriggerServerEvent("Ox-Housing:server:lights", id, light)
                                elseif data.value == "letIn" then
                                    W.TriggerCallback('Ox-Housing:getPeopleOut', function(people) 
                                        if people then
                                            local elements = {}

                                            for k,v in pairs(people) do
                                                if v then
                                                    table.insert(elements, {label = v.name, value = v.source})
                                                end
                                            end
                                            Wait(100)
                                            W.OpenMenu('Personas que han tocado el timbre', "timbre", elements, function (data, name)
                                                W.DestroyMenu(name)
                                                if data.value then
                                                    TriggerServerEvent("Ox-Housing:server:letIn", data.value, dataToSend, coordsShell, secCoords, id)
                                                end
                                            end)
                                        else
                                            W.Notify("CASA", 'Nadie ha tocado el timbre...')
                                        end
                                    end, id)
                                elseif data.value == "changePaint" then
                                    editWalls(dataToSend.shell, id)
                                else
                                    W.DestroyAllMenus()
                                    wExit = true
                                    DoScreenFadeOut(300)
                                    for k, v in pairs(objectsCreated) do
                                        while DoesEntityExist(v.obj) do Wait(0) DeleteObject(v.obj) end;
                                        table.remove(objectsCreated, k)
                                    end
                                    objectsCreated = {}
                                    insideHouse = false
                                    light = false
                                    createdSpawnedObj = {}
                                    Wait(500)
                                    SetEntityCoords(ply, vector3(data.value.x, data.value.y, data.value.z))
                                    TriggerServerEvent("Ox-Housing:server:goOut", id)
                                    while DoesEntityExist(houseShell) do DeleteObject(houseShell); DeleteEntity(houseShell);  Wait(0) end
                                    houseProp = nil
                                    Wait(500)
                                    DoScreenFadeIn(300)
                                    changeWallOnLoad(shellToSend, 'default')
                                    changeFloorOnLoad(shellToSend, 'default')
                                end
                            end
                        end)
                    end
                else
                    if (add) then
                        W.DestroyAllMenus()
                        exports['ZC-HelpNotify']:close('house_interior')
                        add = false
                    end
                end
            else
                if (add) then
                    W.DestroyAllMenus()
                    exports['ZC-HelpNotify']:close('house_interior')
                    add = false
                end
            end
            if wExit then
                if (add) then
                    W.DestroyAllMenus()
                    exports['ZC-HelpNotify']:close('house_interior')
                    add = false
                end
                break
            end
            Wait(wait)
        end
    end)
end

function visitInt(data, coordsShell, secCoords)
    local wExit = false
    W.DestroyAllMenus()
    DoScreenFadeOut(300)
    Wait(300)
    local houseHash = GetHashKey(data.shell)
    local houseShell = nil
    for k, v in pairs(Housing['points']) do
        if v.shell == data.shell then
            SetEntityCoords(PlayerPedId(), coordsShell.x + v.x, coordsShell.y + v.y, coordsShell.z + 851 + v.z)
            break
        end
    end

    FreezeEntityPosition(PlayerPedId(), true)
    Wait(300)
    local exit = GetEntityCoords(PlayerPedId())
    RequestModel(houseHash)
    log("Loading...")
    while not HasModelLoaded(houseHash) do
        RequestModel(houseHash)
        Wait(1)
    end
    houseShell = CreateObject(houseHash, coordsShell.x, coordsShell.y, coordsShell.z + 850, false, false, false)
    houseProp = houseShell
    FreezeEntityPosition(houseShell, true)
    DoScreenFadeIn(300)
    FreezeEntityPosition(PlayerPedId(), false)

    CreateThread(function()
        local add = false
        while true do
            local wait = 1000
            local ply = PlayerPedId()
            local coords = GetEntityCoords(ply)
            local dist = GetDistanceBetweenCoords(exit, coords, true)

            if dist < 10 then
                wait = 0
                DrawMarker(1, exit - vector3(0, 0, 0.70), 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 853, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                if dist < 2 then
                    if not add then
                        add = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para salir', 'house_exit')
                    end
                    if IsControlJustPressed(1, 38) then
                        local elements = {}
                        table.insert(elements, {label = "Puerta principal", value = coordsShell})
                        for k, v in pairs(secCoords) do
                            table.insert(elements, {label = "Puerta secundaria " ..k, value = v.coords})
                        end
                        W.OpenMenu('Puertas', "doors_menu", elements, function (data, name)
                            W.DestroyMenu(name)
                            if data.value then
                                exports['ZC-HelpNotify']:close('house_exit')
                                add = false
                                wExit = true
                                DoScreenFadeOut(300)
                                Wait(500)
                                SetEntityCoords(ply, vector3(data.value.x, data.value.y, data.value.z))
                                Wait(500)
                                DoScreenFadeIn(300)
                                while DoesEntityExist(houseShell) do DeleteObject(houseShell); DeleteEntity(houseShell);  Wait(0) end
                                houseProp = nil
                            end
                        end)
                    end
                else
                    if add then
                        exports['ZC-HelpNotify']:close('house_exit')
                        add = false
                    end
                end
            end
            if wExit then
                exports['ZC-HelpNotify']:close('house_exit')
                add = false
                break
            end
            Wait(wait)
        end
    end)
end

RegisterNetEvent("Ox-Housing:client:lights")
AddEventHandler("Ox-Housing:client:lights", function(var)
    light = var
end)

RegisterNetEvent("Ox-Housing:client:letIn")
AddEventHandler("Ox-Housing:client:letIn", function(data, coordsShell, secCoords, idHouses)
    accesToHouse(data, coordsShell, secCoords, idHouses)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        while DoesEntityExist(houseProp) do DeleteObject(houseProp); DeleteEntity(houseProp); Wait(0) end
    end
end)

HasHouseKeys = function(house_id)
    local PlayerData = W.GetPlayerData()
    local houseGang = housesData[house_id].gang

    if not housesData[house_id] then
        return
    end

    print(houseGang, PlayerData.gang.name)
    if houseGang == PlayerData.gang.name then
        return true
    end

    if (not housesData[house_id].key_code) then
        return
    end

    for k, v in pairs(PlayerData.inventory.items) do
        if(v.item == "house_keys")then
            print('item is house_keys')
            if(v.metadata)then
                print('has metadata')
                if(v.metadata.house and tonumber(v.metadata.house) == house_id)then
                    if(v.metadata.house_key_code and tonumber(v.metadata.house_key_code) == tonumber(housesData[house_id].key_code))then
                        return true
                    end
                end
            end
        end
    end

    if(adminMode)then
        return true
    end

    return false
end

RegisterCommand("godhouse", function(source, args)
    local xPlayerData = W.GetPlayerData()
    if(xPlayerData.group == "admin")then
        adminMode = not adminMode
        if(adminMode)then
            W.Notify("ADMINISTRACIÓN", "Has activado el modo administrador en el sistema de casas", "verify")
        else
            W.Notify("ADMINISTRACIÓN", "Has desactivado el modo administrador en el sistema de casas", "verify")
        end
    end
end)

RegisterCommand("tphouse", function(source, args)
    local xPlayerData = W.GetPlayerData()
    local idHouse = args[1] or false
    if(xPlayerData.group == "admin" and idHouse)then
        if(not housesData[tonumber(idHouse)])then
            return W.Notify("ERROR", "La casa indicada no existe", "error")
        end
        for k, v in pairs(housesData[tonumber(idHouse)].points) do
            if(v.type == "entrada")then
                return SetEntityCoords(GetPlayerPed(-1), vector3(v.coords.x, v.coords.y, v.coords.z))
            end
        end
    end
end)