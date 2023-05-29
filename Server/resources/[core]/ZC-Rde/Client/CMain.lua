RdeController = setmetatable({ }, RdeController)
RdeController.__data = {}
function RdeController:Init()
    Citizen.CreateThread(function()
        RdeController.__data = GlobalState.Zones
        while true do 
            Citizen.Wait(4000)
            for k, v in pairs(RdeController.__data) do
                local playerPed = GetPlayerPed(-1)
                local playerCoords = GetEntityCoords(playerPed)
                local distance = #(playerCoords - vector3(v.data.coords.x, v.data.coords.y, v.data.coords.z))
                if(distance < Cfg.Customization.radius and not RdeController.__data[k].sended)then
                    if(Cfg.Customization.type == "chat")then
                        RdeController.__data[k].sended = true
                        RdeController:SendChat(v, k)
                    elseif(Cfg.Customization.type == "notification")then
                        RdeController:SendNotification(v, k)
                    end
                end
            end
        end
    end)
end

function RdeController:SendChat(v, k)
    -- TriggerEvent('chat:addMessage', { 
    --     args = {Cfg.Customization.header, v.data.message}, 
    --     color = Cfg.Customization.color
    -- })
    TriggerEvent('chat:addMessage', {
        template = Cfg.Customization.template:format(v.data.message),
        args = {Cfg.Customization.header, v.data.message}
    })
end

function RdeController:SendNotification(v, k)
    W.Notify(Cfg.Customization.header, v.data.message)
end

RegisterNetEvent('ZC-Rde:add', function(zoneKey, zoneData)
    RdeController.__data[zoneKey] = zoneData
end)

RegisterNetEvent('ZC-Rde:remove', function(zoneKey)
    RdeController.__data[zoneKey] = nil
end)

RdeController:Init()