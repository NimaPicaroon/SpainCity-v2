local isWithinObject = false
local oElement = {}
local InUse = false
local PlyLastPos = 0
local Anim = 'sentarse'
local AnimScroll = 0
local tumbado = false
local haveDeadBody = false
local canRevive = true

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

CreateThread(function()
    local pausa = 500
    while true do

        Wait(pausa)
        pausa = 500

	if tumbado then
        local playerPed = PlayerPedId()
        pausa = 0
		DisableControlAction(0, Keys['SPACE'], true) -- Jump
		DisableControlAction(0, Keys['LEFTSHIFT'], true) -- Jump
		DisableControlAction(0, Keys['M'], true) -- Jump
        DisableControlAction(0, Keys['G'], true) -- Jump
        DisableControlAction(0, Keys['F3'], true) -- Jump
        DisableControlAction(0, Keys['H'], true) -- Jump
		FreezeEntityPosition(playerPed, true)
	end

        if isWithinObject and oElement.fObject ~= 0 then
            local ply = PlayerPedId()
            local objectCoords = oElement.fObjectCoords
            local playerCoords = GetEntityCoords(ply)
            local distanceDiff = #(objectCoords - playerCoords)
            if (distanceDiff < 2.0 and not InUse) then
                if (oElement.fObjectIsBed) then
                    pausa = 0
                    if not haveDeadBody then
                        -- // ARROW RIGHT
                        if IsControlJustPressed(0, 175) then -- right
                            if (AnimScroll ~= 2) then
                                AnimScroll = AnimScroll + 1
                            end
                            if AnimScroll == 1 then
                                Anim = "de espaldas"
                            elseif AnimScroll == 2 then
                                Anim = "boca abajo"
                            end
                        end

                        if IsControlJustPressed(0, 174) then -- left
                            if (AnimScroll ~= 0) then
                                AnimScroll = AnimScroll - 1
                            end
                            if AnimScroll == 1 then
                                Anim = "de espaldas"
                            elseif AnimScroll == 0 then
                                Anim = "sentarse"
                            end
                        end

                        if (Anim == 'sentarse') then
                            W.ShowText(objectCoords + vector3(0,0,1.3), '~y~Camilla por 300$\n~w~'..Cfg.Text.SitOnBed .. ' | ' .. Cfg.Text.SwitchBetween, 0.5, 8)
                        else
                            W.ShowText(objectCoords + vector3(0,0,1.3), '~y~Camilla por 300$\n~w~'..Cfg.Text.LieOnBed .. ' ~g~' .. Anim .. '~w~ | ' .. Cfg.Text.SwitchBetween, 0.5, 8)
                        end

                        if IsControlJustPressed(0, Cfg.objects.ButtonToLayOnBed) then
                            TriggerServerEvent('ChairBedSystem:Server:Enter', oElement, oElement.fObjectCoords)
                        end
                    else
                        if not Amb.Variables.DeadPeople[haveDeadBody] then haveDeadBody = false end
                        W.ShowText(objectCoords + vector3(0,0,1.3), '~y~Camilla\n~w~ [~y~E~w~] Llamar a los médicos de rescate ~g~$1000', 0.5, 8)

                        if IsControlJustPressed(0, 38) then
                            local OwnData = W.GetPlayerData()
                            if OwnData.job.name == "police" then
                                TriggerServerEvent('ZC-Ambulance:revivePlayerFromPolice', haveDeadBody, 'bank')
                            else
                                if OwnData.money.money >= 1000  then
                                    TriggerServerEvent('ZC-Ambulance:revivePlayer', haveDeadBody, 'money')
                                elseif OwnData.money.bank >= 1000 then
                                    TriggerServerEvent('ZC-Ambulance:revivePlayer', haveDeadBody, 'bank')
                                else
                                    W.Notify('SEGURO MÉDICO', 'No tienes ~r~suficiente~w~ dinero en tu cuenta ni en efectivo', 'error')
                                end
                            end
                        end
                    end
                end
            end

            if (InUse) then
                W.ShowText(objectCoords + vector3(0,0,1.3), '~y~Camilla\n~w~'..Cfg.Text.Standup, 0.5, 8)
                if IsControlJustPressed(0, 73) then
                    InUse = false
                    tumbado = false
                    TriggerServerEvent('ChairBedSystem:Server:Leave', oElement.fObjectCoords)
                    ClearPedTasksImmediately(ply)
                    FreezeEntityPosition(ply, false)

                    local x, y, z = table.unpack(PlyLastPos)
                    if GetDistanceBetweenCoords(x, y, z, playerCoords) < 10 then
                        SetEntityCoords(ply, PlyLastPos)
                    end
                end
            end
        end
    end
end)

local objetos = {
    "v_med_bed2",
    "v_med_bed1",
    "v_med_emptybed"
}

CreateThread(function()
    Wait(100)
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        for i = 1, #objetos do
            local x = GetClosestObjectOfType(playerCoords, 1.2, GetHashKey(objetos[i]), false, false, false)
            local closestObject = nil

            if DoesEntityExist(x) then
                closestObject = x

                local coordsObject = GetEntityCoords(closestObject)
                local distanceDiff = #(coordsObject - playerCoords)

                for _, element in pairs(Cfg.objects.locations) do
                    if (distanceDiff < 3.0 and closestObject ~= 0) then
                        if (distanceDiff < 2.0) then
                            oElement = {
                                fObject = closestObject,
                                fObjectCoords = coordsObject,
                                fObjectcX = element.verticalOffsetX,
                                fObjectcY = element.verticalOffsetY,
                                fObjectcZ = element.verticalOffsetZ,
                                fObjectDir = element.direction,
                                fObjectIsBed = element.bed
                            }
                            isWithinObject = true

                            if canRevive then
                                local closestPlayer = W.GetPlayersInArea(playerCoords, 1.5)
                                for k,v in pairs(closestPlayer) do
                                    if v ~= PlayerId() then
                                        if Amb.Variables.DeadPeople[GetPlayerServerId(v)] then
                                            haveDeadBody = GetPlayerServerId(v)
                                        end
                                    end
                                end
                            end
                        else
                            haveDeadBody = false
                        end
                        break
                    else
                        isWithinObject = false
                        haveDeadBody = false
                    end
                end
            else
                sleep = 1000
            end
        end
        Wait(sleep)
    end
end)

GetDeadPeople = function ()
    return Amb.Variables.DeadPeople
end

exports('GetDeadPeople', GetDeadPeople)

CreateThread(function()
    while true do
        Wait(5000)
        if InUse then
            print('Can health')
            if oElement.fObjectIsBed then
                print('Healing player...')
                local ply = PlayerPedId()
                local health = GetEntityHealth(ply)
                if health < 200 then
                    SetEntityHealth(ply, health + 3)

                    if health > 200 then
                        SetEntityHealth(ply, 200)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(v, coords)
    local object = v.fObject
    local vertx = v.fObjectcX
    local verty = v.fObjectcY
    local vertz = v.fObjectcZ
    local dir = v.fObjectDir
    local isBed = v.fObjectIsBed
    local objectcoords = coords

    local ped = PlayerPedId()
    PlyLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(object, true)
    FreezeEntityPosition(ped, true)
    InUse = true
    if not isBed then
        if Cfg.objects.SitAnimation.dict ~= nil then
            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
            SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
            local dict = Cfg.objects.SitAnimation.dict
            local anim = Cfg.objects.SitAnimation.anim
            AnimLoadDict(dict, anim, ped)
        else
            TaskStartScenarioAtPosition(ped, Cfg.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
        end
    else
        if Anim == 'de espaldas' then
            if Cfg.objects.BedBackAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Cfg.objects.BedBackAnimation.dict
                local anim = Cfg.objects.BedBackAnimation.anim
                tumbado = true
                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Cfg.objects.BedBackAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
                tumbado = true
            end
        elseif Anim == 'boca abajo' then
            if Cfg.objects.BedStomachAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Cfg.objects.BedStomachAnimation.dict
                local anim = Cfg.objects.BedStomachAnimation.anim

                Animation(dict, anim, ped)
                tumbado = true
            else
                TaskStartScenarioAtPosition(ped, Cfg.objects.BedStomachAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
                tumbado = true
            end
        elseif Anim == 'sentarse' then
            if Cfg.objects.BedSitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Cfg.objects.BedSitAnimation.dict
                local anim = Cfg.objects.BedSitAnimation.anim
                tumbado = true
                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Cfg.objects.BedSitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
                tumbado = true
            end
        end
    end
end)

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end
