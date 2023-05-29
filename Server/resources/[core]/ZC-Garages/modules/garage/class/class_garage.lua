GarageClass = setmetatable({ }, GarageClass)
GarageClass.__index = GarageClass

function GarageClass:create(data)
    local self = {}
    self.id = data.id
    self.owner = tostring(data.owner)
    self.name = data.name

    self.plate = data.plate
    self.model = data.model

    if type(data.vehicle) == 'string' then
        self.properties = json.decode(data.vehicle) or {}
    else
        self.properties = data.vehicle or {}
    end

    self.vehicleshop = tostring(data.vehicleshop)
    self.garage = tostring(data.garage)
    self.update = false
    self.stored = true

    self.Name = function()
        local name = {}

        name.get = function()
            return self.name
        end

        name.set = function(new)
            if not new then
                return
            end

            self.name = new
            self.update = true
        end

        return name
    end

    self.Store = function()
        local store = {}

        store.get = function()
            return self.stored
        end

        store.set = function(bool)
            if type(bool) ~= 'boolean' then
                return
            end

            self.stored = bool
            self.update = true
        end

        return store
    end

    self.Owner = function()
        local owner = {}

        owner.get = function()
            return self.owner
        end

        owner.set = function(new)
            if type(new) ~= 'string' then
                return
            end

            self.owner = new
            self.update = true
        end

        return owner
    end

    self.Properties = function()
        local properties = {}

        properties.get = function()
            return self.properties
        end

        properties.set = function(props)
            self.properties = props
            self.update = true
        end

        properties.plate = function(plate)
            if type(plate) ~= 'string' then
                return
            end

            self.plate = plate
            self.update = true
        end

        return properties
    end

    self.Garage = function()
        local garage = {}

        garage.get = function()
            return self.garage
        end

        garage.set = function(new)
            self.garage = new
            self.update = true
        end

        return garage
    end

    return self
end