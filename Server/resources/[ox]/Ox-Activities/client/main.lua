-- Variables

local started = false
local blip
local points = {}
activity = nil
lastSkin = {}

-- Fin variables

-- Functions

function createPeds()
    Wait(1000)
    points = Config.Act.Points

    for k,v in pairs(points) do
        local hash = GetHashKey(v.ped)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end
        ped = CreatePed("PED_TYPE_CIVMALE", v.ped, v.coords, v.h, false, false)
        DecorSetInt(ped, 'SPAWNEDPED', 1)
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        blip = AddBlipForCoord(v.coords)
        SetBlipSprite(blip, 280)
        SetBlipColour(blip, 0)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.bliptext)
        EndTextCommandSetBlipName(blip)
    end
end

local chothes = {
	['elec'] = {skin_female = {['bags_1'] = 48, ['bags_2'] = 0, ['tshirt_1'] = 54, ['tshirt_2'] = 0, ['torso_1'] = 73, ['torso_2'] = 0, ['shoes_1'] = 26, ['shoes_2'] = 0, ['pants_1'] = 4, ['pants_2'] = 1, ['helmet_1'] = 60, ['helmet_2'] = 0, ['arms'] = 83, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 19, ['bproof_2'] = 5, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = -1, ['glasses_2'] = -1}, skin_male = {['bags_1'] = 89, ['bags_2'] = 1, ['tshirt_1'] = 90, ['tshirt_2'] = 0, ['torso_1'] = 2, ['torso_2'] = 5, ['shoes_1'] = 51, ['shoes_2'] = 3, ['pants_1'] = 86, ['pants_2'] = 6, ['helmet_1'] = 60, ['helmet_2'] = 1, ['arms'] = 63, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = 15, ['glasses_2'] = 9}},
    ['mech'] = {skin_female = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 220, ['tshirt_2'] = 0, ['torso_1'] = 383, ['torso_2'] = 0, ['shoes_1'] = 26, ['shoes_2'] = 0, ['pants_1'] = 142, ['pants_2'] = 0, ['helmet_1'] = 60, ['helmet_2'] = 8, ['arms'] = 240, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = -1, ['glasses_2'] = -1}, skin_male = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 182, ['tshirt_2'] = 0, ['torso_1'] = 364, ['torso_2'] = 0, ['shoes_1'] = 27, ['shoes_2'] = 0, ['pants_1'] = 135, ['pants_2'] = 0, ['helmet_1'] = 60, ['helmet_2'] = 8, ['arms'] = 195, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = -1, ['glasses_2'] = -1}},
    ['farm'] = {skin_female = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 14, ['tshirt_2'] = 0, ['torso_1'] = 247, ['torso_2'] = 0, ['shoes_1'] = 69, ['shoes_2'] = 0, ['pants_1'] = 1, ['pants_2'] = 0, ['helmet_1'] = 20, ['helmet_2'] = 0, ['arms'] = 4, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = -1, ['mask_2'] = -1, ['glasses_1'] = 51, ['glasses_2'] = 0}, skin_male = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 238, ['torso_2'] = 0, ['shoes_1'] = 66, ['shoes_2'] = 6, ['pants_1'] = 43, ['pants_2'] = 0, ['helmet_1'] = -30, ['helmet_2'] = 0, ['arms'] = 5, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = 41, ['glasses_2'] = 0}},
    ['gan'] =  {skin_female = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 14, ['tshirt_2'] = 0, ['torso_1'] = 247, ['torso_2'] = 0, ['shoes_1'] = 69, ['shoes_2'] = 0, ['pants_1'] = 1, ['pants_2'] = 0, ['helmet_1'] = 20, ['helmet_2'] = 0, ['arms'] = 4, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = -1, ['mask_2'] = -1, ['glasses_1'] = 51, ['glasses_2'] = 0}, skin_male = {['bags_1'] = 0, ['bags_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 238, ['torso_2'] = 0, ['shoes_1'] = 66, ['shoes_2'] = 6, ['pants_1'] = 43, ['pants_2'] = 0, ['helmet_1'] = -30, ['helmet_2'] = 0, ['arms'] = 5, ['decals_1'] = 0, ['decals_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0, ['mask_1'] = 0, ['mask_2'] = 0, ['glasses_1'] = 41, ['glasses_2'] = 0}},
}

function start()
    started = false
    local zone
    local add = false
    while true do
        local wait = 1000
        local pcoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(points) do
            local dist = #(pcoords - v.coords)
            if dist < 2 and not started then
                zone = v.recogn
                if not add then
                    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar con el '..zone, 'activities')
                    add = true
                end
                if v.recogn == "Portuario" then
                    wait = 0
                    if IsControlJustPressed(1, 38) then
                        exports['ZC-HelpNotify']:close('activities')
                        activity = v.recogn
                        started = true
                        lastSkin = exports['ZC-Character']:GetSkin()
                        local sex = lastSkin['sex']
                        if sex == "mp_m_freemode_01" then
                            TriggerEvent("ZC-Character:loadSkin", chothes['mech'].skin_male, false)
                        else
                            TriggerEvent("ZC-Character:loadSkin", chothes['mech'].skin_female, false)
                        end
                        mechStart(v.coords, v.carspawn, v.veh, v.carh)
                    end
                elseif v.recogn == "Electricista" then
                    wait = 0
                    if IsControlJustPressed(1, 38) then
                        exports['ZC-HelpNotify']:close('activities')
                        started = true
                        activity = v.recogn
                        lastSkin = exports['ZC-Character']:GetSkin()
                        local sex = lastSkin['sex']
                        if sex == "mp_m_freemode_01" then
                            TriggerEvent("ZC-Character:loadSkin", chothes['elec'].skin_male, false)
                        else
                            TriggerEvent("ZC-Character:loadSkin", chothes['elec'].skin_female, false)
                        end
                        elecStart(v.coords, v.carspawn, v.veh, v.carh)
                    end
                elseif v.recogn == "Granjero" then
                    wait = 0
                    if IsControlJustPressed(1, 38) then
                        exports['ZC-HelpNotify']:close('activities')
                        started = true
                        activity = v.recogn
                        lastSkin = exports['ZC-Character']:GetSkin()
                        local sex = lastSkin['sex']
                        if sex == "mp_m_freemode_01" then
                            TriggerEvent("ZC-Character:loadSkin", chothes['farm'].skin_male, false)
                        else
                            TriggerEvent("ZC-Character:loadSkin", chothes['farm'].skin_female, false)
                        end
                        farmStart(v.coords, v.carspawn, v.veh, v.carh)
                    end
                elseif v.recogn == "Ganadero" then
                    wait = 0
                    if IsControlJustPressed(1, 38) then
                        exports['ZC-HelpNotify']:close('activities')
                        started = true
                        activity = v.recogn
                        lastSkin = exports['ZC-Character']:GetSkin()
                        local sex = lastSkin['sex']
                        if sex == "mp_m_freemode_01" then
                            TriggerEvent("ZC-Character:loadSkin", chothes['gan'].skin_male, false)
                        else
                            TriggerEvent("ZC-Character:loadSkin", chothes['gan'].skin_female, false)
                        end
                        ganStart(v.coord, v.carspawn, v.veh, v.carh)
                    end
                end
            else
                if zone == v.recogn then
                    zone = nil
                end
            end
        end

        if add and not zone then
            add = false
            exports['ZC-HelpNotify']:close('activities')
        end
        Wait(wait)
    end
end

CreateThread(createPeds)
CreateThread(start)

InActivity = function()
    return activity
end

exports('InActivity', InActivity)