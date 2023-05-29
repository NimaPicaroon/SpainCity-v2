SmokeController = setmetatable({ }, SmokeController)
SmokeController.__index = SmokeController

SmokeController.getCigarretes = function(itemData, amount)
    if type(itemData) ~= 'table' then
        return
    end

    if type(amount) ~= 'number' then
        return
    end

    local self = {}
    self.source = source
    self.player = W.GetPlayer(self.source)
    self.itemData = itemData
    self.amount = amount

    if self.player and self.itemData and self.amount then
        self.player.updateItemdata('cigarretes', self.itemData.slotId, self.amount, 'remove')
        self.player.addItemToInventory('cigarrete', self.amount, false)
    end
end

RegisterNetEvent('smoke:getCigarretes', SmokeController.getCigarretes)

SmokeController.syncSmoke = function(networkId)
    if type(networkId) ~= 'number' then
        return
    end

    local self = {}
    self.networkId = networkId

    TriggerClientEvent('smoke:syncSmoke', self.networkId)
end

RegisterNetEvent('smoke:syncSmoke', SmokeController.syncSmoke)

W.CreateCallback('smoke:usedItem', function(source, callback, data)
    local src = source
    local ply = W.GetPlayer(src)

    if not ply then
        return
    end

    if not data then
        return
    end

    if data.paperRemove then
        ply.removeItemFromInventory(data.paperRemove.name, data.paperRemove.amount, data.paperRemove.slotId)
    
        if data.drugRemove then
            ply.removeItemFromInventory(data.drugRemove.name, 1, data.drugRemove.slotId)
        end

        if data.itemAdd then
            ply.addItemToInventory(data.itemAdd.name, data.itemAdd.amount, { type = data.itemAdd.metadataLabel })
        end

        return callback(true)
    end

    return callback(false)
end)

-- local vehicles = {
--     [1] = {
--         id = exports['ZC-Garages']:newUUID(),
--         owner = 'society_madrazo',
--         name = nil,
--         model = 'primo',
--         vehicleshop = 'CITY',
--         plate = 'ZZZ028',
--         stored = 1,
--         vehicle = {},
--         garage = 'GARAJE MADRAZO`S CARS'
--     },
-- }

-- Citizen.CreateThread(function()
--     Citizen.Wait(2000)

--     for i = 1, #vehicles do
--         exports.oxmysql:execute('INSERT INTO `owned_vehicles` (id, owner, name, model, vehicleshop, plate, stored, vehicle, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
--             vehicles[i].id,
--             vehicles[i].owner,
--             vehicles[i].name,
--             vehicles[i].model,
--             vehicles[i].vehicleshop,
--             vehicles[i].plate,
--             vehicles[i].stored,
--             json.encode(vehicles[i].vehicle),
--             vehicles[i].garage
--         })
--     end
-- end)