ThiefController = setmetatable({ }, ThiefController)
ThiefController._variables = {
    players = {},
}
ThiefController.__index = ThiefController

ThiefController.start = function(target, adminController, adminSrc)
    if type(target) ~= 'number' then
        return
    end

    local self = {}
    if(not adminController)then
        self.player = Core.GetPlayer(source)
    else
        self.player = Core.GetPlayer(adminSrc)
    end
    self.target = Core.GetPlayer(target)

    if ThiefController._variables.players[target] and not adminController then
        return self.player.Notify('Cacheo', 'Esta persona ya está siendo cacheada.', 'error')
    end
    if(not adminController)then
        ThiefController._variables.players[target] = true
    end
    TriggerClientEvent('thief:steal', self.player.src, self.target.identity.name..' '..self.target.identity.lastname, target, NetworkGetNetworkIdFromEntity(GetPlayerPed(target)), adminController or false)
end

RegisterNetEvent('thief:start', ThiefController.start)

RegisterNetEvent('thief:startAgain', function (target)
    ThiefController._variables.players[target] = true
end)

ThiefController.stop = function(src)
    src = tonumber(src)
    if type(src) ~= 'number' then
        return
    end

    local self = {}
    self.source = src
    Wait(500)
    ThiefController._variables.players[self.source] = false
end

RegisterNetEvent('thief:stop', ThiefController.stop)

ThiefController.stealItem = function(name, quantity, metadata, slotId, target, isAdminStealing)
    if type(name) ~= 'string' then
        return
    end

    if type(quantity) ~= 'number' then
        return
    end

    if type(target) ~= 'number' then
        return
    end

    local self = {}
    self.name = name
    self.quantity = quantity
    self.metadata = metadata or false
    self.slotId = slotId

    self.target = Core.GetPlayer(target)
    self.player = Core.GetPlayer(source)

    if self.player and self.target then
        if self.name == "money" then
            self.player.addMoney(self.name, self.quantity)
            self.target.removeMoney(self.name, self.quantity)
            local trans = {
                ['money'] = 'dinero en mano',
            }
            self.target.Notify('Cacheo', 'Te han quitado~y~ $'..self.quantity..'~b~ ('..trans[self.name]..')~w~.', 'error')
            self.player.Notify('Cacheo', 'Has recibido~y~ $'..self.quantity..'~b~ ('..trans[self.name]..')~w~.', 'verify')
            Core.SendToDiscord("thief", "ROBO DINERO", GetPlayerName(self.player.src)..' ha robado $'..self.quantity..' ('..trans[self.name]..') a '..GetPlayerName(self.target.src), source)
        else
            if self.player.canHoldItem(self.name, tonumber(self.quantity)) then
                self.player.addItemToInventory(self.name, self.quantity, self.metadata)
                self.target.removeItemFromInventory(self.name, self.quantity, self.slotId)
            else
                self.target.Notify('Cacheo', "El jugador que te intentó robar x" .. self.quantity .. " " .. Core.Items[self.name].label .. " lleva sus bolsillos llenos", 'error')
                return
            end
        end
    end

    if not Core.Items[self.name] then return end
    if(not isAdminStealing)then
        self.target.Notify('Cacheo', 'Te han quitado~y~ x'..self.quantity..'~b~ '..Core.Items[self.name].label..'~w~.', 'error')
        self.player.Notify('Cacheo', 'Has recibido~y~ x'..self.quantity..'~b~ '..Core.Items[self.name].label..'~w~.', 'verify')
        Core.SendToDiscord("thief_items", "ROBO ITEMS", GetPlayerName(self.player.src)..' ha robado x'..self.quantity..' ('..Core.Items[self.name].label..') a '..GetPlayerName(self.target.src), source)
    end
    --Core.SendToDiscord('thief_items', 'Robo', GetPlayerName(self.player.src)..' ha robado~y~ $'..self.quantity..'~b~ ('..Core.Items[self.name].label..')~w~ a~y~ '..GetPlayerName(self.target.src))
end

RegisterNetEvent('thief:stealItem', ThiefController.stealItem)

Core.CreateCallback('thief:getItems', function(source, callback, target)
    local player = Core.GetPlayer(target)

    return callback(player.getInventory().items, player.money)
end)

Core.CreateCallback('thief:isBeenSteal', function(source, callback, target)
    if ThiefController._variables.players[target] then
        return callback(true)
    end

    return callback(false)
end)