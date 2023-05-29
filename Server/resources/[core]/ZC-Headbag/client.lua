local HaveBagOnHead = false

function NajblizszyGracz() --This function send to server closestplayer
    local closestPlayer, closestDistance = W.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 2.0 then
        W.Notify("Saco",'~r~Nadie cerca')
    else
        if not HaveBagOnHead then
            TriggerServerEvent('esx_worek:sendclosest', GetPlayerServerId(closestPlayer))
            W.Notify("Saco",'~g~Bolsa colocada ~w~')
            TriggerServerEvent('esx_worek:closest')
        else
            W.Notify("Saco",'~r~Ya tiene una bolsa en la cabeza')
        end
    end
end

RegisterNetEvent('esx_worek:naloz')
AddEventHandler('esx_worek:naloz', function()
    OpenBagMenu()
end)

RegisterNetEvent('esx_worek:nalozNa') --This event put head bag on nearest player
AddEventHandler('esx_worek:nalozNa', function(gracz)
    Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
    AttachEntityToEntity(Worek, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    HaveBagOnHead = true
end)

AddEventHandler('playerSpawned', function() --This event delete head bag when player is spawn again
    DeleteEntity(Worek)
    SetEntityAsNoLongerNeeded(Worek)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end)

RegisterNetEvent('esx_worek:zdejmijc') --This event delete head bag from player head
AddEventHandler('esx_worek:zdejmijc', function(gracz)
    W.Notify("Saco",'~g~Te han quitado el saco de la cabeza')
    DeleteEntity(Worek)
    SetEntityAsNoLongerNeeded(Worek)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end)

function OpenBagMenu() --This function is menu function
    local elements = {
        {label = 'Colocar saco', value = 'puton'},
        {label = 'Retirar saco', value = 'putoff'},
    }

    W.OpenMenu('¿Que quieres hacer?', 'headbag', elements, function(data, name)
        W.DestroyMenu(name)
        if data.value == 'puton' then
            NajblizszyGracz()
        elseif data.value == 'putoff' then
          TriggerServerEvent('esx_worek:zdejmij')
        end
    end)
end

