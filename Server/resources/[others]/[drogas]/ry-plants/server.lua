local W = exports.ZCore:get()

RegisterServerEvent('ry-weed:plantSeed')
AddEventHandler('ry-weed:plantSeed', function(coords)
    local timestamp = os.time()
    exports.oxmysql:execute('INSERT INTO plants (coords, timestamp, plantgender, water, fertilizer) VALUES (@coords, @timestamp, @plantgender, @water, @fertilizer)', {
        ['@coords'] = json.encode(coords),
        ['@timestamp'] = timestamp,
        ['@plantgender'] = 0,
        ['@water'] = 0,
        ['@fertilizer'] = 0,
    }, function(rowschanged)
        if rowschanged then
            exports.oxmysql:execute('SELECT * FROM plants WHERE id = @id', {["@id"] = rowschanged.insertId}, function(plant)
                TriggerClientEvent('ry-weed:trigger_zone', -1, 2, plant[1])
            end)
        end
    end)
end)

W.CreateCallback('ry-weed:getPlants', function(source, cb)
    exports.oxmysql:execute('SELECT * FROM plants', {}, function(plants)
        cb(plants)
    end)
end)

W.CreateCallback('ry-weed:removePlant', function(source, cb, pId)
    exports.oxmysql:execute('DELETE FROM plants WHERE id = @id', {["@id"] = pId}, function(plants)
        cb(true)
        TriggerClientEvent('ry-weed:trigger_zone', -1, 4, pId)
    end)
end)

W.CreateCallback('ry-weed:harvestPlant', function(source, cb, pId)
    local xPlayer = W.GetPlayer(source)
    local plant = getPlantById(pId)

    if not plant then
        return
    end

    local qua = 100 - tonumber(plant.water / 20) - tonumber(plant.fertilizer / 10)

    if xPlayer.addItemToInventory('ramas_marihuana', math.random(6, 8)) then
        exports.oxmysql:execute('DELETE FROM plants WHERE id = @id', {["@id"] = pId}, function(plants)
            cb(true)
            TriggerClientEvent('ry-weed:trigger_zone', -1, 4, pId)
        end)
        return
    end
end)

W.CreateCallback('ry-weed:addWater', function(source, cb, key)
    local xPlayer = W.GetPlayer(source)
    local have, water = xPlayer.getItem('agua_purificada')

    if not have then
        return cb(false)
    end

    xPlayer.removeItemFromInventory('agua_purificada', 1, water.slotId)
    exports.oxmysql:execute('UPDATE plants SET water = (water + @water) WHERE id = @id', {["@id"] = key, ['@water'] = math.random(PlantConfig.WaterAdd[1], PlantConfig.WaterAdd[2])}, function(rowschanged)
        exports.oxmysql:execute('SELECT * FROM plants WHERE id = @id', {["@id"] = key}, function(plant)
            cb(true)
            TriggerClientEvent('ry-weed:trigger_zone', -1, 3, plant[1])
        end)
    end)
end)

W.CreateCallback('ry-weed:addFertilizer', function(source, cb, key)
    local xPlayer = W.GetPlayer(source)
    local fert = 0
    local have, fertilizer = xPlayer.getItem('fertilizante')

    if not have then
        return cb(false)
    end

    fert = PlantConfig.PWeight
    xPlayer.removeItemFromInventory('fertilizante', 1, fertilizer.slotId)

    exports.oxmysql:execute('UPDATE plants SET fertilizer = (fertilizer + @fert)WHERE id = @id', {["@id"] = key, ["@fert"] = fert}, function(rowschanged)
        exports.oxmysql:execute('SELECT * FROM plants WHERE id = @id', {["@id"] = key}, function(plant)
            cb(true)
            TriggerClientEvent('ry-weed:trigger_zone', -1, 3, plant[1])
        end)
    end)
end)

W.CreateCallback('ry-weed:CheckItem', function(source, cb, item)
    local xPlayer = W.GetPlayer(source)
    local has, data = xPlayer.getItem(item)

    if not has then
        return cb(false)
    end

    if data.quantity > 0 then
        return cb(true)
    end
end)

getPlantById = function(plantId)
    local plants = {}
    local result = exports.oxmysql:executeSync('SELECT * FROM plants WHERE id = @id', {["@id"] = plantId})
    return result[1]
end

RegisterNetEvent('v:itemremove')
AddEventHandler('v:itemremove', function (name, count, slotId)
    local xPlayer = W.GetPlayer(source)
    xPlayer.removeItemFromInventory(name, count, slotId) 
end)