W = exports.ZCore:get()

W.RegItem('sprayremover', function(source, item)    
    local source = source
    local Player = W.GetPlayer(source)
    if not Player then return end
    local haveItem, dataItem = Player.getItem('sprayremover')
    if haveItem then
        TriggerClientEvent('rcore_spray:removeClosestSpray', source)
        Player.Notify('Pesca', 'Has quitado el spray', 'verify')
    else
        Player.Notify('Pesca', 'No tienes el kit para quitar el spray', 'error')
    end
end)

RegisterNetEvent('rcore_spray:remove')
AddEventHandler('rcore_spray:remove', function(pos)
    local Source = source
    local Player = W.GetPlayer(Source)
	local have, spray_remover = Player.getItem("sprayremover")
    
    if have then
        -- xPlayer.Functions.RemoveItem("spray_remover", 1)
			Player.removeItemFromInventory("sprayremover", 1, spray_remover.slotId)
        local sprayAtCoords = GetSprayAtCoords(pos)

        MySQL.Async.execute([[
            DELETE FROM sprays WHERE x=@x AND y=@y AND z=@z LIMIT 1
        ]], {
            ['@x'] = pos.x,
            ['@y'] = pos.y,
            ['@z'] = pos.z,
        })

        for idx, s in pairs(SPRAYS) do
            if s.location.x == pos.x and s.location.y == pos.y and s.location.z == pos.z then
                SPRAYS[idx] = nil
            end
        end
        TriggerClientEvent('rcore_spray:setSprays', -1, SPRAYS)

        local sprayAtCoordsAfterRemoval = GetSprayAtCoords(pos)

        -- ensure someone doesnt bug it so its trying to remove other tags
        -- while deducting loyalty from not-deleted-but-at-coords tag
        if sprayAtCoords and not sprayAtCoordsAfterRemoval then
            TriggerEvent('rcore_sprays:removeSpray', Source, sprayAtCoords.text, sprayAtCoords.location)
            W.SendToDiscord("graffiti", "ELIMINADO GRAFFITI", sprayAtCoords.text, source)
        end
    end
end)