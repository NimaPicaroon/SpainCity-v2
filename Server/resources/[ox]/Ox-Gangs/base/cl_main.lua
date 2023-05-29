GangsData = {}

RegisterCommand('gangs', function()
    local player = W.GetPlayerData()
    if player.group == 'admin' then
        SendNUIMessage({open = true, gangs = GangsData})
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('actualCoords', function(d, cb)
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)

    cb(json.encode(Coords))
end)

RegisterNUICallback('createGang', function(data, cb)
    W.TriggerCallback('Ox-Gangs:createGang', function(created, gangs)
        if created then
            cb(gangs)
        else
            W.Notify('BANDAS', 'Algo ha ~r~fallado', 'error')
        end
    end, data)
end)

RegisterNUICallback('deleteGang', function(data, cb)
    W.TriggerCallback('Ox-Gangs:deleteGang', function(deleted, gangs)
        if deleted then
            cb(gangs)
        else
            W.Notify('BANDAS', 'Algo ha ~r~fallado', 'error')
        end
    end, data)
end)

RegisterNetEvent("Ox-Gangs:gangsInfo", function(info)
    GangsData = info
end)