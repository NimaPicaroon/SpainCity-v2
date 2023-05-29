StorageClass = setmetatable({ }, StorageClass)
StorageClass.__index = StorageClass

---Creating a new storage for the server (motels, police storages, etc...)
---@param name string
---@param inventory table
---@param weight integer
---@param maxWeight integer
function StorageClass:Create(name, inventory, weight, maxWeight, blackmoney, new)
    if not name then
        return
    end
    
    local self = {}
    self.name = tostring(name)
    self.inventory = inventory
    self.weight = tonumber(weight)
    self.maxWeight = tonumber(maxWeight) or STORAGE_DATA.defaultWeight
    self.blackmoney = tonumber(blackmoney)

    self.update = false
    self.new = new

    if self.new then    
        Wave.Print('INFO', 'New storage has been created '..self.name)
    end

    self.SQL = function()
        local sql = {}

        sql.save = function()
            exports.oxmysql:execute("UPDATE `storage` SET `data` = ?, `weight` = ?, `maxWeight` = ?, `blackmoney` = ? WHERE `name` = ?", { json.encode(self.inventory), self.weight, self.maxWeight, tonumber(self.blackmoney), self.name }, function()
                --Wave.Print('INFO', ''..self.name..' has been saved to database')
            end)

            self.update = false
        end

        return sql
    end

    --Blackmoney module
    self.Money = function()
        local blackmoney = {}

        ---Returning actual blackmoney of storage
        blackmoney.get = function()
            return self.blackmoney
        end

        ---Adding blackmoney for storage
        ---@param amount integer
        blackmoney.add = function(amount)
            amount = tonumber(amount)

            if amount > 0 then
                self.blackmoney = self.blackmoney + amount
                self.update = true

                return true
            end

            return false
        end

        ---Removing blackmoney for storage
        ---@param amount integer
        blackmoney.remove = function(amount)
            amount = tonumber(amount)

            if amount > 0 and (self:Money().get() >= amount) then
                self.blackmoney = self.blackmoney - amount
                self.update = true

                return true
            end

            return false
        end

        return blackmoney
    end

    ---Weight module
    self.Weight = function()
        local weight = {}

        ---Returning actual weight of storage
        weight.get = function()
            return self.weight
        end

        ---Returning actual max weight of storage
        weight.getMax = function()
            return self.maxWeight
        end

        ---Adding weight for storage
        ---@param max integer
        weight.add = function(calc)
            if not calc then
                return
            end

            self.weight = self.weight + calc
        end

        ---Removing weight for storage
        ---@param max integer
        weight.remove = function(calc)
            if not calc then
                return
            end

            self.weight = self.weight - calc

            if self.weight < 0 then
                self.weight = 0
            end
        end

        ---Setting max weight for storage
        ---@param max integer
        weight.setMax = function(max)
            if not max then
                return
            end

            self.maxWeight = max
        end
        
        return weight
    end

    self.delete = function()
        exports.oxmysql:execute('DELETE FROM `storage` WHERE `name` = ?', { self.name }, function() end)
    end

    ---Inventory module
    self.Inventory = function()
        local inventory = {}

        ---Returning actual inventory of storage
        inventory.get = function()
            if type(self.inventory) == 'string' then
                self.inventory = json.decode(self.inventory)
            end

            return self.inventory
        end

        ---Adding item for inventory storage
        ---@param name string
        ---@param amount integer
        ---@param metadata table
        ---@param slot integer
        ---@param player table
        inventory.add = function(name, amount, metadata, slot, player, house)
            local items = Wave.GetItems()
            local founded = false

            if not items then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: not-wave-items-founded', 'error')

                return false
            end

            if not items[name] then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: item-not-exist', 'error')

                return false
            end
                
            if not player then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: not-player-founded', 'error')

                return false
            end
            
            if not slot then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: not-slot-founded', 'error')

                return false
            end

            if STORAGE_DATA.blackListedItems[name] then
                player.Notify('Almacenamiento', 'Este item no se puede almacenar', 'error')

                return false
            end

            if items[name] then
                if type(metadata) == 'string' then
                    metadata = json.decode(metadata)
                end

                if self.weight + (items[name].weight * amount) > self.maxWeight then
                    player.Notify('Almacenamiento', 'No puedes almacenar más items (Almacenamiento completo)', 'error')

                    return false
                end

                if #self.inventory > 0 then
                    for index = 1, #self.inventory do
                        if self.inventory[index].item == name then
                            if (json.encode(self.inventory[index].metadata) == json.encode(metadata)) then
                                founded = true
    
                                if founded then
                                    Wave.Print('INFO', 'Item amount has been added at '..self.name..' storage ('..amount.. ' - '..name..')')
                                    self:Weight().add(items[name].weight * amount)
    
                                    self.inventory[index].quantity = self.inventory[index].quantity + amount
                                    self.update = true
    
                                    return true
                                end
                            end
                        end
                    end

                    if not founded then
                        Wave.Print('INFO', 'Item has been added at '..self.name..' storage ('..amount.. ' - '..name..')')
                        self:Weight().add(items[name].weight * amount)

                        table.insert(self.inventory, {
                            item = name,
                            quantity = amount,
                            slotId = slot,
                            type = items[name].type,
                            metadata = metadata
                        })

                        self.update = true

                        return true
                    end

                    return false
                else
                    Wave.Print('INFO', 'Item has been added at '..self.name..' storage ('..amount.. ' - '..name..')')
                    self:Weight().add(items[name].weight * amount)

                    table.insert(self.inventory, {
                        item = name,
                        quantity = amount,
                        slotId = slot,
                        type = items[name].type,
                        metadata = metadata
                    })

                    self.update = true

                    return true
                end
            end
        end

        ---Removing item for inventory storage
        ---@param name string
        ---@param amount integer
        ---@param slot integer
        ---@param player table
        inventory.remove = function(name, amount, slot, player)
            local items = Wave.GetItems()

            if not items then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: not-wave-items-founded', 'error')

                return false
            end

            if not items[name] then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: item-not-exist', 'error')

                return false
            end

            if not player then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: not-player-founded', 'error')

                return false
            end
            
            if not slot then
                player.Notify('Almacenamiento', 'Algo ha fallado, habla con un desarrollador. ID: not-slot-founded', 'error')

                return false
            end

            for index = 1, #self.inventory do
                if self.inventory[index].item == name then
                    if tonumber(self.inventory[index].slotId) == tonumber(slot) then
                        if (self.inventory[index].quantity - amount) < 0 then
                            player.Notify('Almacenamiento', 'No tienes tanta cantidad para retirar esto', 'error')
                            
                            return false
                        end
    
                        Wave.Print('INFO', 'Item has been removed at '..self.name..' storage ('..amount.. ' - '..name..')')
                        self:Weight().remove(items[name].weight * amount)
                        self.inventory[index].quantity = self.inventory[index].quantity - amount
                        if self.inventory[index].quantity == 0 then
                            table.remove(self.inventory, index)
                        end
                        
                        self.update = true
    
                        return true
                    end
                end
            end

            return false
        end
        GlobalState[self.name] = self

        return inventory
    end
    GlobalState[self.name] = self
    return self
end