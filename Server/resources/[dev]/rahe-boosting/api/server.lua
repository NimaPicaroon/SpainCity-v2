--
--[[ Framework specific functions ]]--
--
W = exports.ZCore:get()
local framework = shConfig.framework
local supportedFrameworks = { ESX = true, QB = true, CUSTOM = true }

if not supportedFrameworks[framework] then
    print("[^1ERROR^7] Invalid framework used in '/config/shared.lua' - please choose a supported value (ESX / QB / CUSTOM).")
end

local ESX, QBCore
if framework == 'ESX' then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function getPlayerIdentifier(playerId)
    if framework == 'ESX' then
        return tostring(ESX.GetPlayerFromId(playerId).identifier)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            return tostring(Player.PlayerData.citizenid)
        end

        return -1
    else
        -- CUSTOM
        local Player = W.GetPlayer(playerId)
         if Player then
             return tostring(Player.identifier)
         end
    end
end

function getPlayerMoney(playerId)
    if framework == 'ESX' then
        return ESX.GetPlayerFromId(playerId).getMoney()
    elseif framework == 'QB' then
        return QBCore.Functions.GetPlayer(playerId).PlayerData.money.cash
    else
        -- CUSTOM
        local player = W.GetPlayer(playerId)
        return  player.getMoney('money', amount)
    end
end

function removePlayerMoney(playerId, amount)
    if framework == 'ESX' then
        ESX.GetPlayerFromId(playerId).removeMoney(amount)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        Player.Functions.RemoveMoney('cash', amount)
    else
        -- CUSTOM
        local player = W.GetPlayer(playerId)
        return  player.removeMoney('money', amount)
    end
end

function givePlayerMoney(playerId, amount)
    if framework == 'ESX' then
        ESX.GetPlayerFromId(playerId).addMoney(amount)
    elseif framework == 'QB' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        Player.Functions.AddMoney('cash', amount)
    else
        -- CUSTOM
        local player = W.GetPlayer(playerId)
        return  player.addMoney('money', amount)
    end
end

function giveItem(playerId, itemId, amount)
    if framework == 'ESX' then

    elseif framework == 'QB' then

    else
        -- CUSTOM
        local player = W.GetPlayer(playerId)
        return  player.addItemToInventory(itemId.name, amount, metadata, itemId.slotId)
    end
end

-- Use this variable if you want to set the police count with an event from another resource. If it's not nil, it will be used.
local policeCount

function getOnDutyPoliceAmount()
    if policeCount or framework == 'QB' then
        if not policeCount then -- If the QB framework has yet not set the police count.
            policeCount = 0
        end

        return policeCount
    elseif framework == 'ESX' then
        return exports["esx_service"]:GetInServiceCount("police")
    else
        -- CUSTOM
        return exports['Ox-References']:getPolices()
    end
end

-- This is event is only relevant if you're using QB. If you're using QB, please check the readme to make sure you have triggered this event in qb-policejob.
AddEventHandler('police:SetCopCount', function(amount)
    policeCount = amount
end)

--
--[[ General]]--
--

function notifyPlayer(playerId, message, type)
    TriggerClientEvent('rahe-boosting:client:notify', playerId, message, type)
end

-- The event which will be triggered when a player successfully completes his VIN scratch boosting contract.
-- This event must be used to give a vehicle to the player.
AddEventHandler('rahe-boosting:server:vinScratchSuccessful', function(playerId, vehicleModel, vehicleModelName, licensePlate, vehicleProperties, contractOwnerIdentifier)

end)

-- Function that determines if player is a superuser (is allowed to use the admin panel).
function isPlayerSuperUser(playerIdentifier, playerId)
    if svConfig.adminPrincipal and IsPlayerAceAllowed(playerId, 'boosting.admin') then
        return true
    end

    for _, v in ipairs(svConfig.adminIdentifiers) do
        if v == playerIdentifier then
            return true
        end
    end

    return false
end

-- W.RegisterItem('racingtablet', function(source, item)    
--     -- TriggerClientEvent('rahe-boombox:client:showMenu', source)
--     TriggerClientEvent('rahe-racing:client:openTablet', source)
-- end)