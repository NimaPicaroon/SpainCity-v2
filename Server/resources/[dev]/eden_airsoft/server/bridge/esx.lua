W = exports['ZCore']:get()

---Check if player has usable weapons
---@param playerId number
---@return boolean
Framework.PlayerHasRealWeapons = function(playerId)
    local xPlayer = W.GetPlayer(playerId)
    local weapons = {}
    for k, v in pairs(xPlayer.inventory.items) do
        if W.IsWeapon(v.item) then
            xPlayer.removeItemFromInventory(v.item, v.quantity, v.slotId)
            weapons[k] = v.item
        end
    end
    return weapons ~= nil and #weapons > 0
end

---Charge user in order to pay for the match
---@param playerId number
---@param amount number price of the match
---@return boolean
Framework.ChargeUser = function(playerId, amount)
    local xPlayer = W.GetPlayer(playerId)
    if not xPlayer then return false end
    if (xPlayer.getMoney('bank') >= amount) then
        xPlayer.removeMoney('bank', amount)
        return true
    end
    return false
end

---Get required data from player
---@param playerId number
---@return table<string, string>
Framework.GetPlayerData = function(playerId)
    local xPlayer = W.GetPlayer(playerId)
    return {
        source = playerId,
        identifier = xPlayer.identifier,
        name = xPlayer.name,
        firstName = xPlayer.firstName,
        lastName = xPlayer.lastName,
    }
end