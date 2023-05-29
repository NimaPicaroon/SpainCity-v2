--IDS

local disPlayerNames = 3
local showIds = false
local playerDistances = {}
local admin = false

RegisterCommand("ids",function()
    if not showIds then
        showIds = true
        ShowIds()
        GetPeopleNear()
    end
end, false)

RegisterCommand("noids",function()
    if showIds then
        showIds = false
    end
end, false)

RegisterCommand("idadmin", function()
    local data = W.GetPlayerData()
    if data.group == 'mod' or data.group == 'admin' then
        local ped = PlayerPedId()
        if not admin then
            W.Notify("ADMINISTRACIÓN", "IDS de administrador activadas", 'verify')
            TriggerServerEvent("customscript:chr7logon", GetPlayerServerId(ped))
            admin = true
            showIds = true
            ShowIds()
            GetPeopleNear()
            disPlayerNames = 50
        else
            admin = false
            showIds = false
            disPlayerNames = 3
            W.Notify("ADMINISTRACIÓN", "IDS de administrador desactivadas", 'verify')
            TriggerServerEvent("customscript:chr7logoff", GetPlayerServerId(ped))
        end
    else
        W.Notify("ADMINISTRACIÓN", "No tienes permiso para este comando", 'warn')
    end
end)

ShowIds = function()
    Citizen.CreateThread(function()
        while showIds do
            local wait = 1000
            local Players = GetActivePlayers()
            for k, v in ipairs(Players) do
                local Ped = GetPlayerPed(v)
                local ServerId = GetPlayerServerId(v)

                if Ped ~= PlayerPedId() then
                    if (playerDistances[v] ~= nil and playerDistances[v] < disPlayerNames) then
                        local x2, y2, z2 = table.unpack(GetEntityCoords(Ped, true))
                        wait = 0
                        if admin then
                            if NetworkIsPlayerTalking(v) then
                                W.ShowText(vec3(x2, y2, z2+1.04), '~y~['..ServerId..']~w~ -' .. GetPlayerName(v), 0.8, 8)
                            else
                                W.ShowText(vec3(x2, y2, z2+1.04), '~y~['..ServerId..']~w~ -' .. GetPlayerName(v), 0.8, 8)
                            end
                        else
                            if NetworkIsPlayerTalking(v) then
                                W.ShowText(vec3(x2, y2, z2+1.2), '~y~['..ServerId..']', 0.8, 8)
                            else
                                W.ShowText(vec3(x2, y2, z2+1.2), '~y~['..ServerId..']', 0.8, 8)
                            end
                        end
                    end
                end
            end

            Citizen.Wait(wait)
        end
    end)
end

GetPeopleNear = function()
    Citizen.CreateThread(function()
        while showIds do
            local Players = GetActivePlayers()
            for k, v in ipairs(Players) do
                local Ped = GetPlayerPed(v)
                if Ped ~= PlayerPedId() then
                    local x1, y1, z1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                    local x2, y2, z2 = table.unpack(GetEntityCoords(Ped, true))
                    local distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                    playerDistances[v] = distance
                end
            end

            Citizen.Wait(1000)
        end
    end)
end