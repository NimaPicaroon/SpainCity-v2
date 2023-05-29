local cam = nil
local charPed = nil
W = exports.ZCore:get()

-- Main Thread

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(200)
    end

    Wait(3000)
    TriggerServerEvent('MultiCharacters:client:chooseChar')
end)


-- Functions

local function skyCam(bool)
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z, 0.0 ,0.0, Config.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

local function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    skyCam(bool)
    Wait(1000)
    DoScreenFadeIn(500)
end

-- RegisterCommand('debug', function()
--     openCharMenu(true)
-- end)

-- Events

AddEventHandler('ZCore:playerLoaded', function()
    SendNUIMessage({
        action = "stopMusic"
    })
end)

RegisterNetEvent('MultiCharacters:client:closeNUIdefault', function(new) -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    openCharMenu()
    TriggerEvent("ZCore:playerLoaded")
    Wait(1000)
    if new then
        TriggerEvent('ZC-Character:openMenu')
    end
end)

RegisterNetEvent('MultiCharacters:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('MultiCharacters:client:chooseChar', function()
    TriggerEvent('LoadingScreen:shutdown')
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    local interior = GetInteriorAtCoords(Config.Interior.x, Config.Interior.y, Config.Interior.z - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1000)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    openCharMenu(true)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    openCharMenu(false)
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('MultiCharacters:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    DoScreenFadeOut(10)
    TriggerServerEvent("MultiCharacters:server:loadUserData")
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
end)

RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData.cData
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        W.TriggerCallback('MultiCharacters:server:getSkin', function(skinData, pedModel)
            if skinData then
                local model = GetHashKey(skinData.sex)

                if pedModel and (IsModelInCdimage(GetHashKey(pedModel)) and IsModelValid(GetHashKey(pedModel))) then
                    model = GetHashKey(pedModel)
                end

                CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)

                    local RandomAnims = {
                        "WORLD_HUMAN_HANG_OUT_STREET", 
                        "WORLD HUMAN STAND IMPATIENT", 
                        "WORLD_HUMAN_STAND_MOBILE", 
                        "WORLD_HUMAN_SMOKING_POT", 
                        "WORLD_HUMAN_LEANING", 
                        "WORLD_HUMAN_DRUG DEALER_HARD", 
                        "WORLD_HUMAN_SUPERHERO", 
                        "WORLD_HUMAN_TOURIST_MAP", 
                        "WORLD_HUMAN YOGA", 
                        "WORLD_HUMAN_BINOCULARS", 
                        "WORLD HUMAN BUM WASH", 
                        "WORLD_HUMAN_CONST_DRILL", 
                        "WORLD_HUMAN_MOBILE_FILM_SHOCKING", 
                        "WORLD HUMAN MUSCLE FLEX", 
                        "WORLD_HUMAN_MUSICIAN", 
                        "WORLD_HUMAN_PAPARAZZI", 
                        "WORLD_HUMAN_PARTYING",
                    }
                    local PlayAnim = RandomAnims[math.random(#RandomAnims)] 
                    SetPedCanPlayAmbientAnims(charPed, true) 
                    TaskStartScenarioInPlace(charPed, PlayAnim, 0, true)

                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    TriggerEvent('ZC-Character:loadSkin', skinData, false, nil, IsModelInCdimage(GetHashKey(pedModel)) and pedModel or skinData.sex, true, charPed)
                end)
            else
                CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    model = joaat(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
            cb("ok")
        end, cData.citizenid)
    else
        CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
        cb("ok")
    end
end)

RegisterNUICallback('setupCharacters', function(data, cb)
    W.TriggerCallback("MultiCharacters:server:setupCharacters", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
        cb("ok")
    end)
end)

RegisterNUICallback('removeBlur', function(data, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "Hombre" then
        cData.gender = "H"
    elseif cData.gender == "Mujer" then
        cData.gender = "M"
    end
    TriggerServerEvent('MultiCharacters:server:createCharacter', cData)
    Wait(500)
    cb("ok")
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('MultiCharacters:server:deleteCharacter', data.citizenid)
    TriggerEvent('MultiCharacters:client:chooseChar')
    cb("ok")
end)