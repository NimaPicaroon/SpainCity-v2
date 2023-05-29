VehicleController = setmetatable({ }, VehicleController)
VehicleController._loaded = false
VehicleController._store = {}

VehicleController.__index = VehicleController

---Create/Sync vehicleshop data
---@param vehicleshop string - Name of the vehicleshop
VehicleController.load = function(source, vehicleshop, callback)
    if type(vehicleshop) ~= 'string' then
        return
    end

    if type(source) ~= 'number' then
        return
    end

    local self = {}
    self.source = source
    self.vehicleshop = vehicleshop

    self.vehicledata = VEHICLE_DATA.LIST[self.vehicleshop]
    self.vehiclespots = VEHICLE_DATA.SPOTS[self.vehicleshop]

    self.vehicle = nil
    self.vehiclecolor = nil

    if not VehicleController._store[self.vehicleshop] then
        VehicleController._store[self.vehicleshop] = 0
    end

    self.set = function(value)
        self.vehicle.spawned = true
        
        if self.vehicle.spawned then
            value.data = { model = self.vehicle.model, price = self.vehicle.price or 500, colour = self.vehiclecolor, properties = {}, entity = 0, scaleform = 0 }

            if #self.vehiclespots == VehicleController._store[self.vehicleshop] then
                TriggerClientEvent('vehicleshop:sync', self.source, self.vehicleshop, self.vehiclespots)
                TriggerClientEvent('vehicleshop:create', self.source, self.vehicleshop)

                return callback(true)
            end
        end
    end

    self.new = function()
        for k, v in pairs(self.vehiclespots) do
            if not v.data.model then
                self.vehiclecolor = VEHICLE_DATA.COLOURS[math.random(1, #VEHICLE_DATA.COLOURS)]
                self.vehicle = self.vehicledata[math.random(1, #self.vehicledata)]

                if not self.vehicle.spawned then
                    VehicleController._store[self.vehicleshop] = VehicleController._store[self.vehicleshop] + 1
                    self.set(v)
                end
            end
        end
    end 

    self.new()
end

---Load all vehicleshop types
VehicleController.init = function(_source)
    local self = {}
    self.source = source or _source

    self.load = function()
        VehicleController._loaded = true

        for types, _ in pairs(VEHICLE_DATA.LIST) do
            VehicleController.load(self.source, 'VIP', function() end)
            VehicleController.load(self.source, 'JDM', function() end)
            VehicleController.load(self.source, 'CITY', function() end)
            VehicleController.load(self.source, 'CITY2', function() end)
            VehicleController.load(self.source, 'MOTORCYCLES', function() end)
            VehicleController.load(self.source, 'VILLAGE', function() end)
            VehicleController.load(self.source, 'SANDY', function() end)
            VehicleController.load(self.source, 'BOATS', function() end)
        end
    end

    self.check = function()
        if not VehicleController._loaded then
            self.load()
        else
            for types, _ in pairs(VEHICLE_DATA.LIST) do
                TriggerClientEvent('vehicleshop:sync', self.source, types, VEHICLE_DATA.SPOTS[types])
                TriggerClientEvent('vehicleshop:create', self.source, types)
            end
        end
    end

    self.check()
end

RegisterNetEvent('vehicleshop:loaded', VehicleController.init)

VehicleController.buy = function(price, vehicleshop, spot, data)
    if type(price) ~= 'number' then
        return
    end
    
    if type(vehicleshop) ~= 'string' then
        return
    end

    local self = {}
    self.source = source
    self.player = W.GetPlayer(self.source)

    self.price = price
    self.vehicleshop = vehicleshop
    self.spot = spot
    self.data = data
    self.inserted = false

    self._init = function()
        self.player.removeMoney('bank', self.price)

        if not self.inserted then
            exports.oxmysql:execute('INSERT INTO `owned_vehicles` (`id`, `owner`, `model`, `vehicleshop`, `plate`, `stored`, `vehicle`, `garage`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', { exports['ZC-Garages']:newUUID(), self.player.identifier, self.data.model, self.vehicleshop, tostring(self.data.properties.plate), true, json.encode(self.data.properties), VEHICLE_DATA.GARAGES[self.vehicleshop] }, function()
                self.inserted = true
                
                self.player.addItemToInventory('carkey', 1, { model = self.data.model, plate = self.data.properties.plate })
                self.player.Notify('Concesionario', 'Has comprado un vehículo. Lo encontrarás en '..VEHICLE_DATA.GARAGES[self.vehicleshop]..'.', 'verify')
                W.SendToDiscord('vehicleshop', "Concesionario", self.player.name..' ha comprado '..self.data.model..' por $'..self.price..'.')
                TriggerEvent('garages:update', { 
                    id = exports['ZC-Garages']:newUUID(),
                    owner = self.player.identifier,
                    plate = self.data.properties.plate,
                    model = self.data.model,
                    properties = self.data.properties,
                    vehicleshop = self.vehicleshop,
                    garage = VEHICLE_DATA.GARAGES[self.vehicleshop],
                    update = false,
                    stored = true
                }, self.source)
            end)
        end
    end

    self.delete = function()
        if not VEHICLE_DATA.SPOTS[self.vehicleshop] then
            return
        end

        VEHICLE_DATA.SPOTS[self.vehicleshop][self.spot].data = {}
        VehicleController._store[self.vehicleshop] = VehicleController._store[self.vehicleshop] - 1

        return true
    end

    self._init()
end

RegisterNetEvent('vehicleshop:buy', VehicleController.buy)

VehicleController.give = function(plate, model)
    if type(source) ~= 'number' then
        return
    end

    if type(plate) ~= 'string' then
        return
    end

    if type(model) ~= 'string' then
        return
    end

    local self = {}
    self.source = source
    self.player = W.GetPlayer(self.source)

    self.plate = plate
    self.model = model

    self.player.addItemToInventory('carkey', 1, { model = self.model, plate = self.plate })
    self.player.removeMoney('money', 50)
end

RegisterNetEvent('vehicleshop:copyKey', VehicleController.give)

W.CreateCallback('vehicleshop:plateTaken', function(source, cb, plate)
    exports.oxmysql:execute('SELECT 1 FROM `owned_vehicles` WHERE `plate` = ?', { plate }, function(result)
        cb(result[1] ~= nil)
    end)
end)

W.CreateCallback('vehicleshop:vehicles', function(source, callback)
    local src = source
    local ply = W.GetPlayer(src)
    local vehicles = {}

    exports.oxmysql:execute('SELECT * FROM owned_vehicles WHERE owner = ?', { ply.identifier }, function(result)
        for i = 1, #result, 1 do
            table.insert(vehicles, { model = result[i].model, plate = result[i].plate, vehicleshop = result[i].vehicleshop })
        end

        return callback(vehicles)
    end)
end)

W.CreateCallback('vehicleshop:moneyCopy', function(source, callback, price)
    local src = source
    local ply = W.GetPlayer(src)
    local money = ply.getMoney('money')

    if money > 0 then
        if money >= price then
            return callback(true)
        else
            ply.Notify('Concesionario', 'No tienes dinero suficiente', 'error')
            
            return callback(false)
        end
    else
        ply.Notify('Concesionario', 'No tienes dinero suficiente', 'error')
            
        return callback(false)
    end
end)

W.CreateCallback('vehicleshop:money', function(source, callback, price)
    local src = source
    local ply = W.GetPlayer(src)
    local money = ply.getMoney('bank')

    if money > 0 then
        if money >= price then
            if exports['Ox-Banking']:hasAccount(ply.identifier) then
                return callback(true)
            else
                return callback(false, 'Necesitas una cuenta bancaria')
            end
        else
            return callback(false, 'No tienes dinero suficiente')
        end
    else
        return callback(false, 'No tienes dinero suficiente')
    end
end)

VehicleController.getPrice = function(model)
    local vehicleshops = {
        "CITY",
        "JDM",
        "BIKES",
        "CITY2",
        "CITY3",
        "CITY4",
        "VILLAGE",
        "MOTORCYCLES",
        "SANDY",
        "VIP",
        "BOATS"
    }
	local data
    for kk,vv in pairs(vehicleshops) do
		for k,v in pairs(VEHICLE_TYPES[vv]) do
			if model ~= 'emperor' then
			    if v.model == model then
                    data = {model = v.model, price = (v.price * 0.65), vehicleshop =  tostring(vv)}
			    end
			else
				data = {model = v.model, price = 4550, vehicleshop =  tostring(vv)}
			end
		end
	end

    return data
end

exports('getPrice', VehicleController.getPrice)