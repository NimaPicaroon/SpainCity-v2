housesData = {}
local houseBlips = {}
pointsdata = {}

RegisterNetEvent("Ox-Housing:client:refreshHouses")
AddEventHandler("Ox-Housing:client:refreshHouses", function(data)
    for k, v in pairs(houseBlips) do
        RemoveBlip(v.blip)
        table.remove(houseBlips, k)
    end
    houseBlips = {}
    housesData = data
    for key,value in pairs(data) do
        for k, v in pairs(value.points) do
            if v.type == "entrada" then
                if value.bought == 1 then
                    for kk, vv in pairs(value.ownerData) do
                        if vv.owner ~= nil then
                            if vv.owner.identifier == xPlayer.identifier then
                                local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
                                SetBlipSprite(blip, 40)
                                SetBlipColour(blip, 3)
                                SetBlipAsShortRange(blip, true)
                                SetBlipScale(blip, 0.45)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString('Tu casa')
                                EndTextCommandSetBlipName(blip)
                                table.insert(houseBlips, {blip = blip, id = data.id})
                            end
                        end
                    end
                else
                    if Housing['addBlips'] == true then
                        local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
                        SetBlipSprite(blip, 374)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        SetBlipScale(blip, 0.45)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentSubstringPlayerName('Propiedad')
                        EndTextCommandSetBlipName(blip)
                        table.insert(houseBlips, {blip = blip, id = id})
                    else
                        local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
                        SetBlipSprite(blip, 374)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        SetBlipScale(blip, 0)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentSubstringPlayerName('Propiedad')
                        EndTextCommandSetBlipName(blip)
                        table.insert(houseBlips, {blip = blip, id = id, owner = false})
                    end
                end
            end
        end
    end

    haveHouse = false
    for i,j in pairs(housesData) do
        for k, v in ipairs(j.ownerData) do
            if v.owner ~= nil then
                if v.owner.identifier == xPlayer.identifier then
                    haveHouse = j.id
                end
            end
        end
    end
end)

MyHouse = function()
    return haveHouse
end

exports('myHouse', MyHouse)

RegisterNetEvent("Ox-Housing:client:addHouse")
AddEventHandler("Ox-Housing:client:addHouse", function(data)
    local created = false
    for k, v in pairs(data.points) do
        if v.type == "entrada" and not created then
            created = true
            local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
            SetBlipSprite(blip, 374)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            SetBlipScale(blip, 0)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Propiedad')
            EndTextCommandSetBlipName(blip)
            table.insert(houseBlips, {blip = blip, id = id, owner = false})
        end
    end
    table.insert(housesData, data)
end)

RegisterNetEvent('Ox-Housing:ocultarblip')
AddEventHandler('Ox-Housing:ocultarblip', function()
    Housing['addBlips'] = not Housing['addBlips']
    if Housing['addBlips'] == false then
        W.Notify("ESTÉTICA", 'Blips ocultados', 'verify')
        for k,v in pairs(houseBlips) do
            if v.owner ~= nil and v.owner == false then
                SetBlipScale(v.blip, 0)
            end
        end
    else
        W.Notify("ESTÉTICA", 'Blips mostrados', 'verify')
        for k,v in pairs(houseBlips) do
            if v.owner ~= nil and v.owner == false then
                SetBlipScale(v.blip, 0.45)
            end
        end
    end
end)

RegisterNetEvent("Ox-Housing:client:modHouse")
AddEventHandler("Ox-Housing:client:modHouse", function(data, id)
    for k, v in pairs(houseBlips) do
        if v.id == id then
            RemoveBlip(v.blip)
            table.remove(houseBlips, k)
        end
    end
    housesData[id] = nil
    local created = false
    if data then
        for k, v in pairs(data.points) do
            if v.type == "entrada" and not created then
                if data.bought == 1 then
                    for kk, vv in pairs(data.ownerData) do
                        if vv.owner ~= nil then
                            if vv.owner.identifier == xPlayer.identifier then
                                local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
                                SetBlipSprite(blip, 40)
                                SetBlipColour(blip, 3)
                                SetBlipAsShortRange(blip, true)
                                SetBlipScale(blip, 0.45)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString('Tu casa')
                                EndTextCommandSetBlipName(blip)
                                table.insert(houseBlips, {blip = blip, id = data.id})
                            end
                        end
                    end
                else
                    if Housing['addBlips'] == true then
                        local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
                        SetBlipSprite(blip, 374)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        SetBlipScale(blip, 0.45)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentSubstringPlayerName('Propiedad')
                        EndTextCommandSetBlipName(blip)
                        table.insert(houseBlips, {blip = blip, id = id})
                    else
                        local blip = AddBlipForCoord(vector3(v.coords.x, v.coords.y, v.coords.z))
                        SetBlipSprite(blip, 374)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        SetBlipScale(blip, 0)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentSubstringPlayerName('Propiedad')
                        EndTextCommandSetBlipName(blip)
                        table.insert(houseBlips, {blip = blip, id = id, owner = false})
                    end
                end
                created = true
            end
        end
        housesData[id] = data
    end
end)

CreateThread(function()
    Wait(500)
    while true do
        pointsdata = {}
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply)

        for k,v in pairs(housesData) do
            for kk, vv in pairs(v.points) do
                if vv.type == 'entrada' or vv.type == 'puerta' then
                    local dist = #(vec3(vv.coords.x, vv.coords.y, vv.coords.z)-coords)
                    if dist < 20 then
                        table.insert(pointsdata, v)
                    end
                end
            end
        end
        Wait(1500)
    end
end)

local add = false
local marker
local house
CreateThread(function()
    Wait(1500)
    local buyedByHim = false
    local keyChecked = false
    while true do
        local wait = 1500
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply)
        for kk, vv in pairs(pointsdata) do
            for k, v in pairs(vv.points) do
                local dist = 100
                if v.type ~= "mirilla" then
                    dist = #(vec3(v.coords.x, v.coords.y, v.coords.z) - coords)
                end
                if dist < 8 then
                    wait = 0

                    if vv.bought == 1 then
                        for key, val in pairs(vv.ownerData) do
                            if val.owner ~= nil then
                                if val.owner.identifier == xPlayer.identifier or buyedByHim then
                                    if v.type == "garaje" then
                                        DrawMarker(1, v.coords.x, v.coords.y, v.coords.z + 0.05, 0, 0, 0, 0, 0, 0, 3.401, 3.401, 0.11, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                                    elseif v.type ~= "mirilla" then
                                        DrawMarker(1, v.coords.x, v.coords.y, v.coords.z + 0.05, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 153, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                                    end
                                else
                                    if vv.gang ~= '' then
                                        if xPlayer.gang and xPlayer.gang.name == vv.gang then
                                            if v.type == "garaje" then
                                                DrawMarker(1, v.coords.x, v.coords.y, v.coords.z + 0.05, 0, 0, 0, 0, 0, 0, 3.401, 3.401, 0.11, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                                            end
                                        end
                                    end
                                    if v.type == "entrada" or v.type == "puerta" then
                                        DrawMarker(1, v.coords.x, v.coords.y, v.coords.z + 0.05, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 255, 190, 45, 255, 0, 0, 0, 0, 0, 0, 0)
                                    end
                                end
                            end
                        end
                    else
                        if v.type == "entrada" or v.type == "puerta" then
                            DrawMarker(1, v.coords.x, v.coords.y, v.coords.z + 0.05, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 255, 190, 45, 255, 0, 0, 0, 0, 0, 0, 0)
                        end
                    end

                    if dist < 1.5 then
                        if v.type == "entrada" then
                            if not add then
                                marker = v.type
                                house = vv.id
                                add = true
                                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'house')
                            end
                            if IsControlJustPressed(1, 38) then
                                log("House menu")
                                openHouseMenu(vv.id, vv.points)
                            end
                        elseif v.type == "puerta" then
                            if not add then
                                add = true
                                marker = v.type
                                house = vv.id
                                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'house')
                            end
                            if IsControlJustPressed(1, 38) then
                                log("House menu")
                                openHouseMenu(vv.id, vv.points)
                            end
                        elseif v.type == "garaje" then
                            if(not keyChecked)then
                                keyChecked = true
                                if(HasHouseKeys(vv.id))then
                                    buyedByHim = true
                                end
                                for key, val in pairs(vv.ownerData) do
                                    if(val.owner.identifier == xPlayer.identifier)then
                                        buyedByHim = true
                                    end     
                                end
                            end
                            if buyedByHim then
                                if not add then
                                    add = true
                                    marker = v.type
                                    house = vv.id
                                    if(IsPedInAnyVehicle(ply))then
                                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para guardar el vehículo', 'house')
                                    else
                                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para abrir el garaje', 'house')
                                    end
                                end
                                if IsControlJustPressed(1, 38) then
                                    if IsPedInAnyVehicle(ply) then
                                        SaveVehicle(house)
                                    else
                                        OpenGarageMenu(house)
                                    end
                                end
                            end
                        end
                    else
                        if (add and marker == v.type and house == vv.id) then
                            W.DestroyAllMenus()
                            exports['ZC-HelpNotify']:close('house')
                            marker = nil
                            add = false
                            buyedByHim = false
                            keyChecked = false
                            house = nil
                        end
                    end
                else
                    if (add and marker == v.type and house == vv.id) then
                        W.DestroyAllMenus()
                        exports['ZC-HelpNotify']:close('house')
                        marker = nil
                        add = false
                        house = nil
                    end
                end
            end
        end
        Wait(wait)
    end
end)

RegisterCommand("modifyhouse", function ()
    local OwnData = W.GetPlayerData()
    if OwnData.group and OwnData.group == "admin" then
        if pointsdata[1] then
            local coords = GetEntityCoords(PlayerPedId())
            local dist
            local house
            for kk, vv in pairs(pointsdata) do
                for k, v in pairs(vv.points) do
                    if v.type == "entrada" or v.type == "puerta" then
                        local temp = #(vec3(v.coords.x, v.coords.y, v.coords.z) - vec3(coords.x, coords.y, coords.z))
                        if not dist or dist > temp then
                            dist = #(vec3(v.coords.x, v.coords.y, v.coords.z) - vec3(coords.x, coords.y, coords.z))
                            house = vv.id
                        end
                    end
                end
            end

            local elements = {
                {label = "Si", value = "yes"},
                {label = "No", value = "no"}
            }
            Wait(100)
            W.OpenMenu('Quieres modificar la casa #'..house..'?', "modify_menu", elements, function (data, name)
                W.DestroyMenu(name)
                if data.value then
                    local v = data.value
                    if v == "yes" then
                        W.OpenDialog("Precio", "dialog_quaassdasa", function(amount)
                            W.CloseDialog()
                            amount = tonumber(amount)
                            if amount and amount > 0 then
                                TriggerServerEvent("Ox-Housing:modifyHouse", house, amount)
                                W.DestroyAllMenus()
                                exports['ZC-HelpNotify']:close('house')
                                marker = nil
                                add = false
                                house = nil
                            end
                        end)
                    end
                end
            end)
        else
            W.Notify("Administracion", 'No hay casas cerca')
        end
    else
        W.Notify("Administracion", 'No tienes permisos para ejecutar este comando')
    end
end)

RegisterCommand("deletehouse", function()
    local OwnData = W.GetPlayerData()
    if(OwnData.group and OwnData.group == "admin")then
        if pointsdata[1] then
            local coords = GetEntityCoords(PlayerPedId())
            local dist
            local house
            for kk, vv in pairs(pointsdata) do
                for k, v in pairs(vv.points) do
                    if v.type == "entrada" or v.type == "puerta" then
                        local temp = #(vec3(v.coords.x, v.coords.y, v.coords.z) - vec3(coords.x, coords.y, coords.z))
                        if not dist or dist > temp then
                            dist = #(vec3(v.coords.x, v.coords.y, v.coords.z) - vec3(coords.x, coords.y, coords.z))
                            house = vv.id
                        end
                    end
                end
            end
    
            local elements2 = {
                {label = "Si", value = "yes"},
                {label = "No", value = "no"}
            }
            Wait(100)
            W.OpenMenu('Quieres borrar la casa #'..house..'?', "deletehouse_menu", elements2, function (data, name)
                W.DestroyMenu(name)
                if data.value then
                    local v = data.value
                    if v == "yes" then
                        TriggerServerEvent("Ox-Housing:deleteHouse", house)
                        W.DestroyAllMenus()
                        exports['ZC-HelpNotify']:close('house')
                        marker = nil
                        add = false
                        house = nil
                    end
                end
            end)
        else
            W.Notify("Administracion", 'No hay casas cerca')
        end
    end
end)