RegisterNetEvent('cherry-medicoilegal:c:revivir', function()
        local Player = PlayerPedId()
        local Position = GetEntityCoords(Player)
        local Closest = W.GetPlayersInArea(Position, 3.0)
        local DeadPlayer = exports['ZC-Ambulance']:GetDeadPeople()

        for k,v in next, Closest do
            if v ~= PlayerId() then
                if DeadPlayer[GetPlayerServerId(v)] then
                    deadBody = GetPlayerServerId(v)
                end
            end
        end

        if deadBody then
            TriggerServerEvent('ZC-Ambulance:revivePlayer', deadBody)
        end
end)
