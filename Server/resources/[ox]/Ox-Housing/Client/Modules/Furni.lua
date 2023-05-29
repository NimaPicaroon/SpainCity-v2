countOfObj = 0
createdSpawnedObj = {}

function posFurni(id, coordsShell, houseShell)
    W.DestroyAllMenus()
    local objCreated = false
    local start = 1
    local currentcategory = 1
    if xPlayer.gang and xPlayer.gang.name and housesData[id].gang ~= '' then
        table.insert(Housing['furni']['Categories'], {'ilegal', 'Bandas'})
        table.insert(Housing['furni']['Categories'], {'ilegal', 'Bandas'})
    end
    CreateThread(function()
        local he = GetEntityCoords(PlayerPedId())
        local heading = 0.00
        local alt = 0.00
        local changed = true
        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para comprar el mueble', 'furniture')
        exports['ZC-HelpNotify']:open('Usa <strong>DELETE</strong> para terminar', 'furniture11')
        exports['ZC-HelpNotify']:open('Usa <strong>MOUSE WHEEL</strong> para cambiar la altura', 'furniture5')
        exports['ZC-HelpNotify']:open('Usa <strong>⇦ ⇨</strong> para cambiar el mueble', 'furniture2')
        exports['ZC-HelpNotify']:open('Usa <strong>⇧ ⇩</strong> para cambiar la categoría', 'furniture20')
        exports['ZC-HelpNotify']:open('Usa <strong>G</strong> para ajustar la altura', 'furniture30')
        exports['ZC-HelpNotify']:open('Mantén <strong>CLICK</strong> para rotar el mueble', 'furniture3')
        while true do
            local category = Housing['furni']['Categories'][currentcategory]
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            Wait(0)
            if not objCreated then
                local hash = GetHashKey(Housing['furni'][category[1]][start][2])
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Wait(1)
                end
                furni = CreateObject(hash, coords, 100.00, false, false)
                SetEntityCollision(furni, false, false)
                SetEntityAlpha(furni, 230, 0)
                objCreated = true
            end
            if changed then
                exports['ZC-HelpNotify']:close('furniture4')
                changed = false
                exports['ZC-HelpNotify']:open('<strong style:"color: yellow">$' ..Housing['furni'][category[1]][start][3]..'</strong> Categoría: <strong style:"color: yellow">' ..category[2]..'</strong>', 'furniture4')
            end

            if IsControlPressed(0, 25) then
                heading = heading + 0.75
            end
            if IsControlPressed(0, 348) then
                heading = heading - 0.75
            end
            if IsControlJustPressed(0, 96) then
                alt = alt + 0.05
            end
            if IsControlJustPressed(0, 97) then
                alt = alt - 0.05
            end
            SetEntityHeading(furni, heading)
            SetEntityCoords(furni, coords.x, coords.y, he.z + alt)
            if IsControlJustPressed(1, 175) then
                changed = true
                if start == #Housing['furni'][category[1]]  then
                    start = 1
                else
                    start = start + 1
                end
                DeleteObject(furni)
                if IsModelInCdimage(Housing['furni'][category[1]][start][2]) then
                    local hash = GetHashKey(Housing['furni'][category[1]][start][2])
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
                    furni = CreateObject(hash, coords, 100.00, false, false)
                    SetEntityAlpha(furni, 230, 0)
                    --alt = 0.00
                else
                    W.Notify("ERROR", 'El modelo no existe -> '..Housing['furni'][category[1]][start][2], 'error')
                end
            end

            if IsControlJustPressed(1, 172) then
                changed = true
                if currentcategory == #Housing['furni']['Categories'] then
                    currentcategory = 1
                else
                    currentcategory = currentcategory + 1
                end
                start = 1
                category = Housing['furni']['Categories'][currentcategory]
                DeleteObject(furni)
                if IsModelInCdimage(Housing['furni'][category[1]][start][2]) then
                    local hash = GetHashKey(Housing['furni'][category[1]][start][2])
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
                    furni = CreateObject(hash, coords, 100.00, false, false)
                    SetEntityCollision(furni, false, false)
                    SetEntityAlpha(furni, 230, 0)
                    --alt = 0.00
                else
                    W.Notify("ERROR", 'El modelo no existe -> '..Housing['furni'][category[1]][start][2], 'error')
                end
            end

            if IsControlJustPressed(1, 173) then
                changed = true
                if currentcategory == 1 then
                    currentcategory = #Housing['furni']['Categories']
                else
                    currentcategory = currentcategory - 1
                end
                start = 1
                category = Housing['furni']['Categories'][currentcategory]

                DeleteObject(furni)
                if IsModelInCdimage(Housing['furni'][category[1]][start][2]) then
                    local hash = GetHashKey(Housing['furni'][category[1]][start][2])
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
                    furni = CreateObject(hash, coords, 100.00, false, false)
                    SetEntityCollision(furni, false, false)
                    SetEntityAlpha(furni, 230, 0)
                    --alt = 0.00
                else
                    W.Notify("ERROR", 'El modelo no existe -> '..Housing['furni'][category[1]][start][2], 'error')
                end
            end

            if IsControlJustPressed(1, 174) then
                changed = true
                if start == 1 then
                    start = #Housing['furni'][category[1]]
                else
                    start = start - 1
                end
                DeleteObject(furni)
                if IsModelInCdimage(Housing['furni'][category[1]][start][2]) then
                    local hash = GetHashKey(Housing['furni'][category[1]][start][2])
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
                    furni = CreateObject(hash, coords, 100.00, false, false)
                    SetEntityCollision(furni, false, false)
                    SetEntityAlpha(furni, 230, 0)
                   -- alt = 0.00
                else
                    W.Notify("ERROR", 'El modelo no existe -> '..Housing['furni'][category[1]][start][2], 'error')
                end
            end

            if IsControlJustPressed(1, 47) then
                local objCoords = GetEntityCoords(furni)
                SetEntityCoords(furni, objCoords.x, objCoords.y, (objCoords.z-(objCoords.z-GetEntityHeightAboveGround(furni))))
                alt = alt - GetEntityHeightAboveGround(furni)
            end

            SetEntityCollision(furni, false, false)
            if IsControlJustPressed(1, 38) then
                countOfObj = countOfObj + 1
                local hash = GetHashKey(Housing['furni'][category[1]][start][2])
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Wait(1)
                end
                SetEntityCoords(furni, coords.x, coords.y, he.z + alt)
                local coords = GetEntityCoords(furni)
                local sheshs = GetEntityHeading(furni)
                FreezeEntityPosition(furni, true)
                SetEntityHeading(furni, heading)
                TriggerServerEvent("Ox-Housing:server:addFurni", id, Housing['furni'][category[1]][start][2], vector3(coords.x, coords.y, coords.z), sheshs, Housing['furni'][category[1]][start][3])
            end

            if IsControlJustPressed(0, 194) then
                DeleteObject(furni)
                exports['ZC-HelpNotify']:close('furniture')
                exports['ZC-HelpNotify']:close('furniture11')
                exports['ZC-HelpNotify']:close('furniture2')
                exports['ZC-HelpNotify']:close('furniture20')
                exports['ZC-HelpNotify']:close('furniture3')
                exports['ZC-HelpNotify']:close('furniture4')
                exports['ZC-HelpNotify']:close('furniture5')
                exports['ZC-HelpNotify']:close('furniture30')
                editing = false
                break
            end
        end
    end)
end

RegisterNetEvent("Ox-Housing:client:syncFur")
AddEventHandler("Ox-Housing:client:syncFur", function(hash, coords, heading)
    local hash = GetHashKey(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(1)
    end
    obj = CreateObject(hash, coords.x, coords.y, coords.z, heading, false, false)
    FreezeEntityPosition(obj, true)
    SetEntityHeading(obj, heading)
    table.insert(objectsCreated, {obj = obj, heading = heading, coords = vector3(coords.x, coords.y, coords.z)}) 
end)
