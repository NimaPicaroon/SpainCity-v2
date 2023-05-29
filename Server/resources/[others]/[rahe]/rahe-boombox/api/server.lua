--
--[[ Framework specific functions ]]--
--

local framework = shConfig.framework
local supportedFrameworks = { ESX = true, QB = true, CUSTOM = true }

if not supportedFrameworks[framework] then
    print("[^1ERROR^7] Invalid framework used in '/config/shared.lua' - please choose a supported value (ESX / QB / CUSTOM).")
end

local ESX, QBCore
if framework == 'ESX' then
    -- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif framework == 'QB' then
    QBCore = exports.ZCore:get()
end

function getPlayerIdentifier(playerId)
    if framework == 'ESX' then
        return tostring(ESX.GetPlayerFromId(playerId).identifier)
    elseif framework == 'QB' then
        return tostring(QBCore.GetPlayer(playerId).identifier)
    else
        -- Fill this out when using a custom framework
    end
end

-- This is used when sending logs to Discord to help understand who did what.
-- Example the final message looks for our server: 'Owner: Tyrone Baller (1536), INGAME ID: 744'
function getDiscordHelperMessage(playerId)
    local firstName, lastName, characterId

    if framework == 'ESX' then
        local player = ESX.GetPlayerFromId(playerId)
        if player then
            firstName = player.variables.firstName
            lastName = player.variables.lastName
            characterId = tostring(player.identifier)
        end
    elseif framework == 'QB' then
        local player = W.GetPlayer(playerId)
        if player then
            firstName = player.identity.name
            lastName = player.identity.lastname
            characterId = tostring(player.identifier)
        end
    else
        -- Fill this out when using a custom framework
    end

    return ('%s %s (%s), INGAME IG: %s'):format(firstName, lastName, characterId, playerId)
end

--
--[[ Other functions ]]--
--

-- Function that determines if the player can interact with music entities
-- You can use this in case you want to limit who can create boomboxes.
-- For example - if you want to sell the boombox permissions in your Tebex store, you should use this to check if the user has purchased the permission.
function canUseBoombox(playerId)
    return true
end

-- Function to get users steam hex id
function getPlayerSteamHexId(playerId)
    for k, identifier in pairs(GetPlayerIdentifiers(playerId)) do
        if string.find(identifier, 'steam') then
            return identifier
        end
    end
end

-- Function that determines if player is allowed to mark entities as permanent.
function isPlayerAllowedToMarkPermanent(playerId)
    local steamHexId = getPlayerSteamHexId(playerId)

    for _, v in ipairs(svConfig.permanentIdentifiers) do
        if v == steamHexId then
            return true
        end
    end

    return false
end

-- Function that determines if player is a superuser (is allowed to mark entities as permanent, delete entities).
function isPlayerSuperUser(playerId)
    local steamHexId = getPlayerSteamHexId(playerId)

    for _, v in ipairs(svConfig.adminSteamHexIds) do
        if v == steamHexId then
            return true
        end
    end

    return false
end

function notifyPlayer(playerId, message, type)
    TriggerClientEvent('rahe-boombox:client:notify', playerId, message, type)
end

-- If you don't use inventoryBased setting, this command can be used to create new music entities
RegisterCommand('music', function(source, args)
    if svConfig.inventoryBased then
        return
    end

    if not canUseBoombox(source) then
        notifyPlayer(source, translations.TEXT_NO_PERMISSIONS, G_NOTIFICATION_TYPE_INFORM)
        return
    end

    TriggerClientEvent('rahe-boombox:client:showMenu', source)
end)

-- Admin menu for overview of current boomboxes
RegisterCommand('boomboxes', function(source, args)
    if not isPlayerSuperUser(source) then
        return
    end

    openAdminMenu(source)
end)

-- If you use inventoryBased setting, you should this event to create new boomboxes.
-- This event should be called once item has been used
-- You can add your custom logic (progressbars etc), but the event should always call itemUsedInternal(playerId, itemId) function
RegisterNetEvent('rahe-boombox:server:itemUsed')
AddEventHandler('rahe-boombox:server:itemUsed', function(itemId, src)
    local playerId = source

    if not playerId or playerId == '' then
        playerId = src
    end

    itemUsedInternal(playerId, itemId)
end)

-- Fill out this function to fit your inventory resource.
-- This function is called whenever user stores the boombox.
function giveItem(playerId, itemId, amount)

end

-- Fill out this function to fit your inventory resource.
-- This function is called whenever user uses the boombox and a new music entity is created.
function removeItem(playerId, itemId, amount)

end

exports.ZCore:RegisterItem('boombox', function(source, item)    
    TriggerClientEvent('rahe-boombox:client:showMenu', source)
end)

-- Examples for creating usable items when using inventoryBased setting
-- Make sure these items actually exist in your inventory resource before running this.
-- After you created the items in your inventory resource, uncomment this down below or use it as example to run it anywhere else.

----------------------------- EXAMPLE -----------------------------
-- Citizen.CreateThread(function()
--     if not svConfig.inventoryBased then
--         return
--     end

--     for k, v in pairs(svConfig.speakerTypes) do
--         if framework == 'ESX' then
--             ESX.RegisterUsableItem(v.itemId, function(source)
--                 TriggerEvent('rahe-boombox:server:itemUsed', v.itemId, source)
--             end)
--         elseif framework == 'QB' then
--             QBCore.Functions.CreateUseableItem(v.itemId, function(source, item)
--                 TriggerEvent('rahe-boombox:server:itemUsed', v.itemId, source)
--             end)
--         elseif framework == 'CUSTOM' then
            
--         end
--     end
-- end)
--------------------------- EXAMPLE END ---------------------------