RegisterServerEvent('esx_worek:closest')
AddEventHandler('esx_worek:closest', function()
    local player = W.GetPlayer(source)
    local have, saco = player.getItem('saco')
    if have then
        --player.removeItemFromInventory('saco', 1, saco.slotId)
        TriggerClientEvent('esx_worek:nalozNa', najblizszy)
    end
end)

RegisterServerEvent('esx_worek:sendclosest', function(closestPlayer)
    najblizszy = closestPlayer
end)

RegisterServerEvent('esx_worek:zdejmij', function()
    --local player = W.GetPlayer(source)
    --player.addItemToInventory('saco', 1, false)
    TriggerClientEvent('esx_worek:zdejmijc', najblizszy)
end)