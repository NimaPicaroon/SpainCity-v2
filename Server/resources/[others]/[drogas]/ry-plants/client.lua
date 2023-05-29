local W = exports.ZCore:get()

local WeedPlants = {}
local ActivePlants = {}
local BurnStart = false
local inZone = 0
local setDeleteAll = false

Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(PlayerPedId())
        if WeedPlants == nil then WeedPlants = {} end
        for idx,plant in ipairs(WeedPlants) do
            if idx % 100 == 0 then
                Wait(0) --Process 100 per frame
            end
            --convert timestamp -> growth percent
            local plantcoords = json.encode(plant.coords)
            local plantGrowth = getPlantGrowthPercent(plant)
            if not setDeleteAll then
                local curStage = getStageFromPercent(plantGrowth)
                local isChanged = (ActivePlants[plant.id] and ActivePlants[plant.id].stage ~= curStage)

                if isChanged then
                    removeWeed(plant.id)
                end

                if not ActivePlants[plant.id] or isChanged then
                    local weedPlant = createWeedStageAtCoords(curStage, plant.coords)
                    ActivePlants[plant.id] = {
                        object = weedPlant,
                        stage = curStage
                    }
                end
            else
                removeWeed(plant.id)
            end
        end
        if setDeleteAll then
            WeedPlants = {}
            setDeleteAll = false
        end
        Wait(inZone > 0 and 500 or 1000)
    end
end)

Citizen.CreateThread(function()
    for id,zone in ipairs(WeedZones) do
        exports["veny-polyzone"]:AddCircleZone("ry-weed:weed_zone", zone[1], zone[2])
    end
end)

RegisterNetEvent('ry-weed:client:useitem')
AddEventHandler('ry-weed:client:useitem', function(slotId)
    if inZone > 0 then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        Citizen.Wait(5000)
        ClearPedTasks(PlayerPedId())
        local plyCoords = GetEntityCoords(PlayerPedId())
        local offsetCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.7, 0)
        local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(offsetCoords.x, offsetCoords.y, offsetCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z - 2, 1, 0, 4)
        local retval, hit, endCoords, _, materialHash, _ = GetShapeTestResultIncludingMaterial(rayHandle)
        TriggerServerEvent("ry-weed:plantSeed", endCoords)
        TriggerServerEvent('v:itemremove', 'semillas', 1, slotId)
    else
        DisplayHelpText("You can't plant weed here")
    end
end)

RegisterNetEvent('ry-weed:trigger_zone')
AddEventHandler("ry-weed:trigger_zone", function (type, pData)
    --Update all plants
    if type == 1 then
        for _,plant in ipairs(WeedPlants) do
            local keep = false
            for _,newPlant in ipairs(pData) do
                if plant.id == newPlant.id then
                    keep = true
                    break
                end
            end

            if not keep then
                removeWeed(plant.id)
            end
        end
        WeedPlants = pData
    end
    --New plant being added
    if type == 2 then
        WeedPlants[#WeedPlants+1] = pData
    end
    --Plant being harvested/updated
    if type == 3 then
        for idx,plant in ipairs(WeedPlants) do
            if plant.id == pData.id then
                WeedPlants[idx] = pData
                break
            end
        end
    end
    --Plant being removed
    if type == 4 then
        for idx,plant in ipairs(WeedPlants) do
            if plant.id == pData then
                table.remove(WeedPlants, idx)
                removeWeed(plant.id)
                break
            end
        end
    end
end)


AddEventHandler("ry-weed:checkPlant", function(test)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local object = nil
    local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
    for k,v in ipairs(PlantConfig.GrowthObjects) do
        local closestObject = GetClosestObjectOfType(x1, y1, z1, 2.0, v.hash, false, false, false)
        if closestObject ~= nil and closestObject ~= 0 then
            object = closestObject
            break
        end
    end
    local plantId = getPlantId(object)

    if not plantId then return end
    showPlantMenu(plantId)
end)


AddEventHandler('ry-weed:addWater', function(data)
    playPourAnimation()
    local plyCoords = GetEntityCoords(PlayerPedId())
    local buckethash = CreateObject('prop_bucket_01a', plyCoords.x, plyCoords.y, plyCoords.z, true, false, 0)
    AttachEntityToEntity(buckethash, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -200.0, -15.0, 40.0, false, true, true, true, 0, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
        W.TriggerCallback('ry-weed:addWater', function(success) 
            if not success then
                notify("Could not add water.")
            end
        end, data)
    Wait(200)
    DeleteObject(buckethash)

end)

AddEventHandler('ry-weed:addFertilizer', function (data)
    playPourAnimation()
    local plyCoords = GetEntityCoords(PlayerPedId())
    local buckethash = CreateObject('prop_bucket_01a', plyCoords.x, plyCoords.y, plyCoords.z, true, false, 0)
    AttachEntityToEntity(buckethash, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -200.0, -15.0, 40.0, false, true, true, true, 0, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
        W.TriggerCallback('ry-weed:addFertilizer', function(success)
            if not success then
                DisplayHelpText("You can't add the fertilizer.")
            end
        end, data)
    Wait(200)
    DeleteObject(buckethash)
end)

AddEventHandler('ry-weed:addMaleSeed', function(data)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    local plyCoords = GetEntityCoords(PlayerPedId())
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
        W.TriggerCallback('ry-weed:addMaleSeed', function(success)
            if not success then
                notify("You can't add the water.")
            end
        end, data)
    Wait(200)
end)

AddEventHandler('ry-weed:removePlant', function(data)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    local plyCoords = GetEntityCoords(PlayerPedId())
    Citizen.Wait(2200)
    ClearPedTasks(PlayerPedId())
    Citizen.Wait(12000)
    local getFertilizer = getPlantGrowthPercent(getPlantById(data)) > 2.0
    W.TriggerCallback('ry-weed:removePlant', function(success) 
        if not success then
        else
            removeWeed(data)
        end
    end, data)
    BurnStart = false
end)

AddEventHandler("ry-weed:pickPlant", function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local object = nil
    local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
    for k,v in ipairs(PlantConfig.GrowthObjects) do
        local closestObject = GetClosestObjectOfType(x1, y1, z1, 30.0, v.hash, false, false, false)
        if closestObject ~= nil and closestObject ~= 0 then
            object = closestObject
            break
        end
    end
    local plantId = getPlantId(object)
    if not plantId then return end
    local plant = getPlantById(plantId)
    local growth = getPlantGrowthPercent(plant)
    if growth < PlantConfig.HarvestPercent then
        DisplayHelpText("This plant is not ready to be harvested.")
        return
    end
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    local plyCoords = GetEntityCoords(PlayerPedId())
    -- local buckethash = CreateObject('prop_bucket_01a', plyCoords.x, plyCoords.y, plyCoords.z, true, false, 0)
    -- AttachEntityToEntity(buckethash, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -200.0, -15.0, 40.0, false, true, true, true, 0, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
        W.TriggerCallback('ry-weed:harvestPlant', function(cb)
            if not cb then
                --print('za')
            end
        end, plantId)
        --DeleteObject(buckethash)
end)

AddEventHandler("veny-polyzone:enter", function(zone, data)
    if zone == "ry-weed:weed_zone" then
        inZone = inZone + 1
        if inZone == 1 then
            W.TriggerCallback('ry-weed:getPlants', function(cb)
                WeedPlants = cb
            end)
        end
    end
end)

AddEventHandler("veny-polyzone:exit", function(zone, data)
    if zone == "ry-weed:weed_zone" then
        inZone = inZone - 1
        if inZone < 0 then inZone = 0 end
        if inZone == 0 then
            setDeleteAll = true
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for idx,plant in pairs(ActivePlants) do
        DeleteObject(plant.object)
    end
end)

function createWeedStageAtCoords(pStage, pCoords)
    local model = PlantConfig.GrowthObjects[pStage].hash
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    coords = json.decode(pCoords)
    local plantObject = CreateObject(model, coords.x, coords.y, coords.z + PlantConfig.GrowthObjects[pStage].zOffset, 0, 0, 0)
    FreezeEntityPosition(plantObject, true)
    SetEntityHeading(plantObject, math.random(0, 360) + 0.0)
    return plantObject
end

function removeWeed(pPlantId)
    if ActivePlants[pPlantId] then
        DeleteObject(ActivePlants[pPlantId].object)
        ActivePlants[pPlantId] = nil
    end
end

function getStageFromPercent(pPercent)
    local growthObjects = #PlantConfig.GrowthObjects - 1
    local percentPerStage = 100 / growthObjects
    return math.floor((pPercent / percentPerStage) + 1.5)
end

function getPlantGrowthPercent(pPlant)
    local timeDiff = (GetCloudTimeAsInt() - pPlant.timestamp) / 60
    local genderFactor = (pPlant.plantgender == 1 and PlantConfig.MaleFactor or 1)
    local fertilizerFactor = pPlant.fertilizer >= 50 and PlantConfig.FertilizerFactor or 1.0
    local growthFactors = (PlantConfig.GrowthTime * genderFactor * fertilizerFactor)
    local growth = math.min((timeDiff / growthFactors) * 100, 100.0)
    return growth
end

function getPlantId(pEntity)
    for plantId,plant in pairs(ActivePlants) do
        if plant.object == pEntity then
            return plantId
        end
    end
end

function getPlantById(pPlantId)
    for _,plant in pairs(WeedPlants) do
        if plant.id == pPlantId then
            return plant
        end
    end
end

function playPourAnimation()
    RequestAnimDict("weapon@w_sp_jerrycan")
    while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
end
local zbab = nil

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
        local pData = W.GetPlayerData()
        local playerPed = PlayerPedId()
        for k,v in ipairs(PlantConfig.GrowthObjects) do
            local closestObject = GetClosestObjectOfType(x1, y1, z1, 1.0, v.hash, false, false, false)
            if closestObject ~= nil and closestObject ~= 0 then
                local job = pData.job.name
                object = closestObject
                local wc = GetEntityCoords(closestObject)
                zbab = closestObject
                sleep = 5
                local plantId = getPlantId(object)
                local plant = getPlantById(plantId)
                local growth = getPlantGrowthPercent(plant)
                local water = math.min(plant.water, 100)
                if job == "police" or job == "judge" then
                    DrawText3D('~INPUT_PICKUP~ Quemar la planta ', vector3(wc.x,wc.y,wc.z+1.5))
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('ry-weed:removePlant', plantId)
                        Citizen.Wait(7100)
                        BurnStart = true
                    end
                else
                    if growth < 95 then
                        DrawText3D('~INPUT_PICKUP~ Información', vector3(wc.x,wc.y,wc.z+2))
                        if IsControlJustPressed(0, 38) then
                            Citizen.Wait(250)
                            DrawText2D(growth, plant, water)
                        end
                    else
                        DrawText3D('~INPUT_PICKUP~ Recolectar    ~INPUT_REPLAY_SCREENSHOT~ información', vector3(wc.x,wc.y,wc.z+2))
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent('ry-weed:pickPlant')
                        end
                        if IsControlJustPressed(0, 303) then
                            DrawText2D(growth, plant, water)
                        end
                    end
                    if IsControlJustPressed(0, 49) then
                        W.TriggerCallback('ry-weed:CheckItem', function(success)
                            if success then
                                TriggerEvent('ry-weed:addWater', plantId)
                            else
                                W.Notify('Plantas', 'Necesitas agua para hacer esto', 'error')
                            end
                        end, 'agua_purificada')
                    end
                    if IsControlJustPressed(0, 74) then
                        W.TriggerCallback('ry-weed:CheckItem', function(succes)
                            if succes then
                                TriggerEvent('ry-weed:addFertilizer', plantId)
                            else
                                W.Notify('Plantas', 'Necesitas fertilizante para hacer esto', 'error')
                            end
                        end, 'fertilizante')
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function DrawText3D(msg, coords)
    AddTextEntry('Text', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('Text')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function DrawText2D(qwe, asd, su)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName("Crecimiento : %".. string.format("%.2f", qwe)) 
    AddTextComponentSubstringPlayerName('\nWater: ' .. string.format("%.2f", su) .. '%' or "hembra" .. '\nAgua: %' .. string.format("%.2f", su) .. '')
    AddTextComponentSubstringPlayerName("\n~INPUT_ARREST~ Agua\n~INPUT_VEH_HEADLIGHT~ Fertilizante") 
    EndTextCommandDisplayHelp(0, false, true, 0)
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        local particleDictionary = "core"
        local particleName = "fire_wrecked_plane_cockpit"
        
        RequestNamedPtfxAsset(particleDictionary)
        while not HasNamedPtfxAssetLoaded(particleDictionary) do
            Citizen.Wait(1)
        end 
        
        StartParticleFxLoopedAtCoord(particleName, GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, 0.0, 0.0, 0.0, 1.5, false, false, false, 0) 
        --print("asd")
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if BurnStart == true then
            sleep = 5 
            local particleDictionary = "core"
            local particleName = "fire_wrecked_plane_cockpit"
            local loopAmount = 25
            
            RequestNamedPtfxAsset(particleDictionary)

            while not HasNamedPtfxAssetLoaded(particleDictionary) do
                Citizen.Wait(0)
            end
            
            local particleEffects = {}
            for x=0,loopAmount do
                UseParticleFxAssetNextCall(particleDictionary)
                local particle = StartParticleFxLoopedOnEntity(particleName, zbab, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, false, false, false)
                table.insert(particleEffects, 1, particle)
                Citizen.Wait(0)
            end

            Citizen.Wait(1000)
            for _,particle in pairs(particleEffects) do
                -- Stopping each particle effect.
                StopParticleFxLooped(particle, true)
            end
        else
            sleep = 1500
        end
        Citizen.Wait(sleep)
    end
end)
