function W.CreatePlayer(src, name, identifier, discord, group, coords, inventory, stats, money, identity, status, skin, ped, job, gang, bills, dimension, dead, phone, fade, vip, metadata)
    local self = {}

    self.src = src or 1
    self.name = name or "Name not found"
    self.identifier = identifier
    self.discord = discord or "No Discord"
    self.group = group or "user"
    self.coords = coords
    self.metadata = metadata or {}
    local id = identifier:gsub('%license:', '')
    self.id = id:gsub("%D+", "") or "None"
    self.inventory = inventory or { }
    self.stats = stats or { }
    self.money = money or { }
    self.identity = identity or { }
    self.status = status or { }
    self.skin = skin or {}
    self.ped = ped or ''
    self.maxWeight = 10
    self.job = job or { }
    self.gang = gang or {}
    self.bills = bills or {}
    self.dimension = dimension or 0
    self.dead = dead or 0
    self.phone = phone or 0
    self.fade = fade or {}
    self.vip = vip or 0

    self.update = false

    self.setVip = function(new)
        if not new then
            return
        end

        self.vip = tonumber(new)
        self.update = true
        self.updateData()
    end

    self.setJob = function (data)
        local lastJob = self.job
        self.job = data
        self.update = true
        TriggerClientEvent('ZCore:setJob', self.src, self.job, lastJob)
        TriggerEvent('ZCore:setJob', self.src, self.job, lastJob)
        self.updateData()
    end

    self.setGang = function (data)
        local lastGang = self.gang
        self.gang = data
        self.update = true
        TriggerClientEvent('ZCore:setGang', self.src, self.gang, lastGang)
        self.updateData()
    end

    self.setAssignation = function(assignation)
        local lastJob = self.job
        self.update = true
        self.job.assignation = assignation
        TriggerClientEvent('ZCore:setJob', self.src, self.job, lastJob)
        self.updateData()
    end

    self.setDuty = function(bool)
        local lastJob = self.job
        self.update = true
        self.job.duty = bool
        TriggerClientEvent('ZCore:setJob', self.src, self.job, lastJob)
        TriggerEvent('ZCore:setDuty', self.src, self.job)
        self.updateData()
    end

    self.getDimension = function()
        return self.dimension
    end

    self.setDimension = function(dimension)
        self.dimension = tonumber(dimension)
        SetPlayerRoutingBucket(self.src, self.dimension)
        self.update = true

        self.updateData()
    end

    self.setPed = function(pedModel)
        self.ped = pedModel
        self.update = true
        
        self.updateData()
    end

    self.saveCachePlayer = function()
        local data = {
            token = self.identifier,
            discord = self.discord,
            group = self.group,
            name = self.name,
            ped = self.ped,
            vip = self.vip,
            coords = json.encode(self.coords),
            inventory = json.encode(self.inventory),
            job = json.encode(self.job),
            gang = json.encode(self.gang),
            skills = json.encode(self.stats),
            money = json.encode(self.money),
            identity = json.encode(self.identity),
            status = json.encode(self.status),
            skin = json.encode(self.skin),
            bills = json.encode(self.bills),
            phone = tonumber(self.phone),
            dimension = tonumber(self.dimension),
            dead = tonumber(self.dead),
            metadata = json.encode(self.metadata),
            fade = json.encode(self.fade)
        }
        W.Print("INFO", "Player *" .. self.name .. "* was saved in players cache")
        W.PlayersCache[self.identifier] = data
        if(not W.Metadata.AllData[self.identifier])then
            W.Metadata.AllData[self.identifier] = {
                data = self.metadata or {},
                name = self.name,
                discord = self.discord,
            }
        end
        W.Metadata.AllData[self.identifier].data = self.metadata
        return data
    end
    --metadata
    self.updatePlayerMetadata = function(key, value)
		if not self.metadata then
			self.metadata = {}
		end
		if key and value then
			self.metadata[key] = value
			W.Metadata.OnlineData[self.identifier].data = self.metadata
            W.Metadata.AllData[self.identifier].data = self.metadata
            self.update = true
			return true
		end
		return false
    end

    self.getMetadata = function(key)
		if not self.metadata then
			self.metadata = {}
		end
		if key and self.metadata[key] then
			return self.metadata[key]
		end
		return false
    end

    ---comment
    self.savePlayer = function(reason)
        if reason == 'disconnect' then
            W.PlayersCache[self.identifier] = {
                token = self.identifier,
                discord = self.discord,
                group = self.group,
                name = self.name,
                ped = self.ped,
                vip = self.vip,
                coords = json.encode(self.coords),
                inventory = json.encode(self.inventory),
                job = json.encode(self.job),
                gang = json.encode(self.gang),
                skills = json.encode(self.stats),
                money = json.encode(self.money),
                identity = json.encode(self.identity),
                metadata = json.encode(self.metadata),
                status = json.encode(self.status),
                skin = json.encode(self.skin),
                bills = json.encode(self.bills),
                phone = tonumber(self.phone),
                dimension = tonumber(self.dimension),
                dead = tonumber(self.dead),
                fade = json.encode(self.fade)
            }
        end

        MySQL.Async.execute("UPDATE `players` SET `discord` = @discord, `inventory` = @inv, `group` = @g, `dimension` = @dimension, `name` = @name, `metadata` = @metadata, `coords` = @coords, `skills` = @stats, `money` = @money, `identity` = @identity, `status` = @status, `skin` = @skin, `ped` = @ped, `job` = @job, `gang` = @gang, `dead` = @dead, `bills` = @bills, `fade` = @fade, `phone` = @phone, `vip` = @vip WHERE `token` = @token", {
            ['@token'] = self.identifier,
            ['@discord'] = self.discord,
            ['@g'] = self.group,
            ['@name'] = self.name,
            ['@ped'] = self.ped,
            ['@vip'] = self.vip,
            ['@coords'] = json.encode(self.coords),
            ['@inv'] = json.encode(self.inventory),
            ['@job'] = json.encode(self.job),
            ['@gang'] = json.encode(self.gang),
            ['@stats'] = json.encode(self.stats),
            ["@metadata"] = json.encode(self.metadata),
            ['@money'] = json.encode(self.money),
            ['@identity'] = json.encode(self.identity),
            ['@status'] = json.encode(self.status),
            ['@skin'] = json.encode(self.skin),
            ['@bills'] = json.encode(self.bills),
            ['@dimension'] = tonumber(self.dimension),
            ['@dead'] = tonumber(self.dead),
            ['@phone'] = tonumber(self.phone),
            ['@fade'] = json.encode(self.fade)
        }, function ()
        end)

        -- self.updateData()
    end

    ---comment
    ---@param data any
    self.setIdentity = function(data)
        self.identity = data
        self.update = true
        self.updateData()
    end

    self.updateDead = function(val)
        self.dead = val
        self.update = true
    end

    ---comment
    ---@param g any
    ---@param cb any
    ---@return any
    self.setGroup = function(g, cb)
        if g then
            self.group = g
            self.update = true
            self.updateData()
            TriggerEvent('ZCore:updateGroup', self, self.src, self.group)
            TriggerClientEvent('ZCore:updateGroup', self.src, self.player, self.group)

            if cb then
                return cb(true)
            else
                return true
            end
        end
        if cb then
            return cb(false)
        else
            return false
        end
    end

    self.hasEnoughPerms = function(perms, callback)
        if W.Groups[self.group] >= W.Groups[perms] then
            return callback and callback(true) or true
        else
            return callback and callback(false) or false
        end
    end

    self.setInventory = function(inventory)
        RemoveAllPedWeapons(GetPlayerPed(self.src))
        if inventory then
            for k, v in pairs(inventory) do
                if W.IsWeapon(v.item) then
                    self.addWeapon(v.item)
                end
            end
        end
        self.inventory = inventory or { totalWeight = 0, slots = {}, items = {} }
        self.money.money = 0
        self.update = true

        self.updateData()
    end

    ---comment
    ---@param item any
    ---@param quantity any
    ---@param metadata any
    ---@return any
    self.removeItemFromInventory = function(item, quantity, slotId, metadata)
        quantity = tonumber(quantity)
        local removed = false
        local slot = 0

        if not W.Items[item] then
            return
        end

        if quantity and (tonumber(quantity) <= 0) then
            return false
        end

        for i = 1, #self.inventory.items do
            if self.inventory.items[i] then
                if self.inventory.items[i].item == item then
                    if slotId and self.inventory.items[i].slotId == slotId then
                        slot = slotId

                        if self.inventory.items[i].quantity - quantity < 0 then
                            return self.Notify('Inventario', 'No puedes quitarte más items de los que tienes', 'error')
                        end

                        self.inventory.items[i].quantity = self.inventory.items[i].quantity - quantity

                        if self.inventory.items[i].quantity == 0 then
                            if self.inventory.items[i].item == 'radio' then
                                TriggerClientEvent('radio:onRadioDrop', self.src)
                            end

                            table.remove(self.inventory.items, i)
                        end

                        removed = true

                        if W.IsWeapon(item) then
                            RemoveWeaponFromPed(GetPlayerPed(self.src), GetHashKey(item))
                        end
                    end
                end
            end
        end

        local slotRev = false

        if #(self.inventory.slots) > 0 then
            for k,v in pairs(self.inventory.slots) do
                if tonumber(v.slotId) == tonumber(slot) and not slotRev then
                    self.removeSlot(item, v.slot)
                    slotRev = true
                    removed = true
                end
            end
        end

        if removed then
            self.updateData()
            self.update = true

            return true
        end

        return false
    end

    self.canCarryItem = function(item, quantity)
        local found = false
        local itemData = W.Items[item]
        quantity = tonumber(quantity)
        if not itemData then
            return false
        end

        if itemData.limit == 0 then
            return true
        end

        if quantity > itemData.limit then
            return false
        end

        for i = 1, #self.inventory.items, 1 do
            if self.inventory.items[i].item == item then
                local quantityItem = self.inventory.items[i].quantity
                local more = quantityItem + quantity

                if more <= itemData.limit then
                    return true
                end

                return false
            end
        end

        return true
    end

    ---comment
    ---@param item any
    ---@param quantity any
    ---@param metadata any
    ---@return any
    self.addItemToInventory = function(item, quantity, metadata, slotId)
        local found = false
        quantity = tonumber(quantity)
        if not W.Items[item] then self.Notify("ERROR", "El item no existe", "error") end
        if not slotId then slotId = W.SlotId() end
        if type(metadata) == 'string' then metadata = json.decode(metadata) end
        if not metadata then 
            metadata = false
        end

        if quantity and (tonumber(quantity) <= 0) then
            return false
        end

        if self.canCarryItem(item, quantity) then
            if W.IsWeapon(item) then
                if not metadata then
                    metadata = W.DefaultMetadata["weapon"]
                    metadata.serialnumber = math.random(1000000, 9999999)
                    metadata.attachments = {}
                    metadata.life = 100
                end

                W.DefaultMetadata['weapon'].life = 100

                self.addWeapon(item)
                table.insert(self.inventory.items, {item = item, quantity = quantity, slotId = slotId, type = W.Items[item].type, metadata = metadata or W.DefaultMetadata['weapon'] })
                if W.Items[item] and W.Items[item].label then
                    self.Notify('Inventario', 'Has recibido ~y~x'..quantity..'~w~ de ~y~'..W.Items[item].label..'~w~.', 'verify')
                end
                self.updateData()
                self.update = true

                return true
            else
                for i = 1, #self.inventory.items, 1 do
                    if self.inventory.items[i].item == item then
                        if json.encode(self.inventory.items[i].metadata) == json.encode(metadata) then
                            found = true

                            self.inventory.items[i].quantity = self.inventory.items[i].quantity + quantity
                            if W.Items[item] and W.Items[item].label then
                                self.Notify('Inventario', 'Has recibido ~y~x'..quantity..'~w~ de ~y~'..W.Items[item].label..'~w~.', 'verify')
                            end
                            self.updateData()
                            self.update = true

                            return true
                        end
                    end
                end

                if not found then
                    table.insert(self.inventory.items, {item = item, quantity = quantity, slotId = slotId, type = W.Items[item].type, metadata = metadata or (W.DefaultMetadata[item] and W.DefaultMetadata[item] or false) })

                    if W.Items[item] and W.Items[item].label then
                        self.Notify('Inventario', 'Has recibido ~y~x'..quantity..'~w~ de ~y~'..W.Items[item].label..'~w~.', 'verify')
                    end
                    self.updateData()
                    self.update = true

                    return true
                end
            end
        else
            self.Notify("Inventario", 'No puedes llevar más items de este tipo', "error")
            return false
        end

        return false
    end

    self.updateMaxWeight = function (new)
        self.maxWeight = new
    end

    self.updatePed = function(new)
        self.ped = new
        self.update = true
        if(new ~= "")then
            TriggerClientEvent('ZC-Character:updateModel', self.src, new)
        else
            -- DropPlayer(self.src, 'Un administrador retiró tu ped seleccionada, para aplicar estos cambios debes reiniciar FiveM y volver a entrar al servidor.')
            self.Notify('NOTIFICACION', 'La ped ha sido quitada correctamente ahora tienes que reiniciar para que se aplique', 'verify')
        end
    end

    ---comment
    ---@param item any
    ---@param quantity any
    ---@return any
    self.canHoldItem = function(item, quantity)
        if not W.Items[item] then self.Notify("ERROR", "El item no existe", "error") return W.Print("ERROR", "The item does not exist") end
        if not quantity then self.Notify("ERROR", "Cantidad erronea", "error") return W.Print("ERROR", "No quantity") end
        local data = W.Items[item]

        if data.limit > 0 then
            local found = false
            for k, v in pairs(self.inventory.items) do
                if v.item == item then
                    found = true
                    if (v.quantity + quantity) <= data.limit then
                        if (self.inventory.totalWeight + (data.weight * quantity)) <= self.maxWeight then
                            return true
                        else
                            return self.Notify('INVENTARIO', '~r~No~w~ puedes llevar más peso', 'error')
                        end
                    else
                        return self.Notify('INVENTARIO', '~r~No~w~ puedes llevar más '..data.label, 'error')
                    end
                end
            end

            if not found then
                return true
            end
        else
            if (self.inventory.totalWeight + (data.weight * quantity)) <= self.maxWeight then
                return true
            else
                return self.Notify('INVENTARIO', '~r~No~w~ puedes llevar más peso', 'error')
            end
        end
    end

    ---comment
    ---@param name any
    self.addWeapon = function(name)
        local ammo = 0
        if name == "WEAPON_BZGAS" then
            ammo = 5
        elseif name == "WEAPON_PETROLCAN" then
            ammo = 4500
        end
        GiveWeaponToPed(GetPlayerPed(self.src), GetHashKey(name), ammo)
    end
    
    ---comment
    self.giveAllWeapons = function()
        RemoveAllPedWeapons(GetPlayerPed(self.src))
        if self.inventory.items then
            for k, v in pairs(self.inventory.items) do
                if W.IsWeapon(tostring(v.item)) then
                    self.addWeapon(v.item)
                end
            end
        end
    end

    ---comment
    self.clearLoadout = function()
        for k, v in pairs(self.inventory.items) do
            if W.IsWeapon(v.item) then
                self.removeItemFromInventory(v.item, v.quantity, v.slotId)
            end
        end
        RemoveAllPedWeapons(GetPlayerPed(self.src))
    end

    ---comment
    ---@param cb any
    ---@return any
    self.getInventory = function (cb)
        if cb then
            return cb(self.inventory)
        else
            return self.inventory
        end
    end

    self.getItem = function(name)
        local found = false

        for i = 1, #self.inventory.items, 1 do
            if self.inventory.items[i].item == name and not found then
                found = true

                return true, self.inventory.items[i]
            end
        end

        return false
    end

    self.getItemFromSlot = function(slotId)
        local found = false

        for i = 1, #self.inventory.items, 1 do
            print(self.inventory.items[i].slotId, slotId)
            if (tonumber(self.inventory.items[i].slotId) == tonumber(slotId)) and not found then
                found = true

                return self.inventory.items[i]
            end
        end

        return false
    end

    self.getHotbarItemFromSlot = function(slotId)
        local found = false
        for i = 1, #self.inventory.slots, 1 do
            if (tonumber(self.inventory.slots[i].slotId) == tonumber(slotId)) and not found then
                found = true

                return self.inventory.slots[i]
            end
        end
    end

    self.addComponent = function(slotId, attachment)
        local WeaponData = self.getItemFromSlot(slotId)
        local WeaponSlotData = self.getHotbarItemFromSlot(slotId)

        if not WeaponData or not WeaponSlotData then
            print('nigger')
            return false
        end

        if not W.Items[attachment.item] then
            print('nigger2')
            return false
        end

        --print('agregamos todo puta')
        WeaponData.metadata.attachments[#WeaponData.metadata.attachments+1] = { component = attachment.component, label = W.Items[attachment.item].label, item = attachment.item }
        WeaponSlotData.metadata.attachments[#WeaponSlotData.metadata.attachments+1] = { component = attachment.component, label = W.Items[attachment.item].label, item = attachment.item }
        self.updateData()
        self.update = true

        return true
    end

    self.removeSlot = function(item, slot, slotToAdd)
        local found = false
        for k,v in pairs(self.inventory.slots) do
            if tonumber(v.slot) == tonumber(slot) and not found then
                found = true
                table.remove(self.inventory.slots, k)
            end
        end

        if slotToAdd then
            self.updateSlot(item, slotToAdd)
        end
    end

    self.updateSlot = function(item, slot)
        for k,v in pairs(self.inventory.slots) do
            if tonumber(v.slot) == tonumber(slot) then
                table.remove(self.inventory.slots, k)
            end
        end
        table.insert(self.inventory.slots, {slot = slot, name = item.name, label = item.label, metadata = item.metadata, slotId = item.slotId, type = item.type})
        self.updateData()
        self.update = true
    end
    
    ---comment
    ---@param name any
    ---@param cb any
    ---@return any
    self.getStat = function (name, cb)
        if self.stats[name] then
            if cb then
                return cb(self.stats[name])
            else
                return self.stats[name]
            end
        else
            if cb then
                return cb(false)
            else
                return false
            end
        end
    end

    ---comment
    ---@param name any
    ---@param toAdd any
    ---@param cb any
    self.addStat = function(name, toAdd, cb)
        if not self.stats[name] then
            self.stats[name] = 0
        end

        if self.stats[name] then
            if (tonumber(self.stats[name]) + tonumber(toAdd)) > 100 then
                self.stats[name] = 100
            else
                self.stats[name] = self.stats[name] + tonumber(toAdd) 
            end
            self.updateData()
            self.update = true
        else
            W.Print("ERROR", "The stat does not exist")
        end
    end

    ---comment
    ---@param name any
    ---@param toAdd any
    ---@param cb any
    self.removeStat = function(name, toAdd, cb)
        if self.stats[name] then
            if (tonumber(self.stats[name]) - tonumber(toAdd)) < 0 then
                self.stats[name] = 0
            else
                self.stats[name] = self.stats[name] - tonumber(toAdd) 
            end
            self.updateData()
            self.update = true
        else
            W.Print("ERROR", "The stat does not exist")
        end
    end

    self.removeForAllStats = function(toAdd, cb)
        for k, v in pairs(self.stats) do
            if tonumber(self.stats[k]) > 40 then
                if (tonumber(self.stats[k]) - tonumber(toAdd)) < 0 then
                    self.stats[k] = 0
                else
                    self.stats[k] = self.stats[k] - tonumber(toAdd) 
                end
            end
        end

        self.updateData()
        self.update = true
    end

    ---comment
    ---@param type any
    ---@return any
    self.getMoney = function(type)
        if self.money[type] then
            return self.money[type]
        else
            return nil
        end
    end

    ---comment
    ---@param type any
    ---@param amount any
    ---@return any
    self.addMoney = function(type, amount)
        if amount and (tonumber(amount) <= 0) then
            return
        end

        if self.money[type] then
            self.money[type] = self.money[type] + tonumber(amount)
            self.updateData()
            self.update = true
        else
            return nil
        end
    end

    ---comment
    ---@param type any
    ---@param amount any
    ---@return any
    self.removeMoney = function(type, amount)
        if amount and (tonumber(amount) <= 0) then
            return
        end

        if self.money[type] then
            self.money[type] = self.money[type] - tonumber(amount)

            if self.money[type] < 0 then
                self.money[type] = 0
            end

            self.updateData()
            self.update = true
        else
            return nil
        end
    end

    ---comment
    ---@param title any
    ---@param content any
    ---@param t any
    self.Notify = function (title, content, t)
        local t = t
        if not t then t = "info" end
        TriggerClientEvent("core:client:Notify", self.src, title, content, t)
    end

    self.addStatus = function(type, add)
        if type == 'stress' then
            if (tonumber(self.status.stress) + tonumber(add)) > 100 then
                self.status.stress = 100
            else
                self.status.stress = self.status.stress + add
            end
        elseif type == 'hunger' then
            if (tonumber(self.status.hunger) + tonumber(add)) > 100 then
                self.status.hunger = 100
            else
                self.status.hunger = self.status.hunger + add
            end
        elseif type == 'thirst' then
            if (tonumber(self.status.thirst) + tonumber(add)) > 100 then
                self.status.thirst = 100
            else
                self.status.thirst = self.status.thirst + add
            end
        end

        self.updateData()
        self.update = true
    end

    self.removeStatus = function(type, remove)
        if type == 'stress' then
            if (tonumber(self.status.stress) - tonumber(remove)) < 0 then
                self.status.stress = 0
            else
                self.status.stress = self.status.stress - remove
            end
        elseif type == 'hunger' then
            if (tonumber(self.status.hunger) - tonumber(remove)) < 0 then
                self.status.hunger = 0
            else
                self.status.hunger = self.status.hunger - remove
            end
        elseif type == 'thirst' then
            if (tonumber(self.status.thirst) - tonumber(remove)) < 0 then
                self.status.thirst = 0
            else
                self.status.thirst = self.status.thirst - remove
            end
        end

        self.updateData()
        self.update = true
    end

    self.updateStatus = function(status)
        self.status = status
        self.updateData()
        self.update = true
    end

    self.stackItem = function(data)
        local found = false
        local quantity = 0

        for index, value in pairs(self.inventory.items) do
            if value.item == data.name then
                if json.encode(value.metadata) == json.encode(data.metadata) then

                    if value.slotId ~= data.slotId then
                        found = true
                        quantity = value.quantity

                        TriggerClientEvent('needs:cancel', self.src)
                        self.removeItemFromInventory(data.name, 1, data.slotId)
                        self.removeItemFromInventory(value.item or value.name, value.quantity, value.slotId)
                        self.addItemToInventory(value.item or value.name, quantity + 1, value.metadata, value.slotId)

                        self.updateData()
                        self.update = true

                        return true
                    end
                end
            end
        end
    end

    self.updateItemdata = function(typeData, slotId, quantity, action)
        if typeData and action then
            local found = false

            for index, value in pairs(self.inventory.items) do
                if value.slotId == tonumber(slotId) and not found then
                    found = true

                    if not value.metadata[typeData] then
                        return false
                    end
                    if action == 'more' then
                        value.metadata[typeData] = value.metadata[typeData] + quantity
                    elseif action == 'remove' then
                        value.metadata[typeData] = value.metadata[typeData] - quantity
                    end
                end
            end

            for index, value in pairs(self.inventory.slots) do
                if value.slotId == tonumber(slotId) then
                    found = true

                    if not value.metadata[typeData] then
                        return false
                    end
                    if action == 'more' then
                        value.metadata[typeData] = value.metadata[typeData] + quantity
                    elseif action == 'remove' then
                        value.metadata[typeData] = value.metadata[typeData] - quantity
                    end
                end
            end

            if found then
                self.updateData()
                self.update = true

                return true
            end

            return false
        end

        return false
    end

    self.updateRounds = function(item, amount)
        local found = false
        
        for i = 1, #self.inventory.items, 1 do
            if (tonumber(self.inventory.items[i].slotId) == tonumber(item)) and not found then
                found = true

                self.inventory.items[i].metadata.bullets = amount
                self.updateData()
                
                return true
            end
        end
    end

    self.updateRoundsSlot = function(item, amount)
        local found = false
        for i = 1, #self.inventory.slots, 1 do
            if (tonumber(self.inventory.slots[i].slotId) == tonumber(item)) and not found then
                found = true

                self.inventory.slots[i].metadata.bullets = amount
                self.updateData()
                
                return true
            end
        end
    end

    self.payBill = function(billId)
        if self.bills[tostring(billId)] then
            self.bills[tostring(billId)].payed = true
        end

        self.update = true
        TriggerClientEvent('billing:add', self.src, self.bills)
    end

    self.addBill = function(billId, data)
        if not self.bills[tostring(billId)] then
            self.bills[tostring(billId)] = data
        end

        self.update = true
        TriggerClientEvent('billing:add', self.src, self.bills)
    end

    self.updateBills = function(bills)
        self.bills = bills
        self.update = true
    end

    ---comment
    ---@param skin any
    self.updateSkin = function (skin)
        self.skin = skin
        self.update = true
    end

    self.updateFade = function(fade)
        self.fade = fade
        self.update = true
    end

    self.updateData = function()
        self.inventory.totalWeight = 0
        for k, v in pairs(self.inventory.items) do
            if W.Items[v.item] then
                self.inventory.totalWeight =  self.inventory.totalWeight + (W.Items[v.item].weight * v.quantity)
            end
        end
        local newData = {job = self.job, gang = self.gang, maxWeight = self.maxWeight, inventory = self.inventory, name = self.name, identifier = self.identifier, group = self.group, money = self.money, status = self.status, identity = self.identity, stats = self.stats, dimension = self.dimension, bills = self.bills, skin = self.skin, vip = self.vip }
        TriggerClientEvent('ZCore:updateData', self.src, newData, W.Items)
    end

    self.useItem = function(item)
        if not item then
            return
        end
        if W.Usables[item.name] then
            self.Notify('NOTIFICACION', 'Has usado ~y~x1 '..W.Items[item.name].label, 'verify')
            W.Usables[item.name](self, item)
        else
            self.Notify('NOTIFICACION', 'El objeto ~r~no~w~ se puede usar', 'error')
        end
    end

    self.updateData()
    local newData = {job = self.job, gang = self.gang, maxWeight = self.maxWeight, inventory = self.inventory, name = self.name, identifier = self.identifier, group = self.group, money = self.money, status = self.status, identity = self.identity, stats = self.stats, dimension = self.dimension, bills = self.bills, skin = self.skin, vip = self.vip }
    TriggerClientEvent('ZCore:updateData', self.src, newData, W.Items)

    return self
end