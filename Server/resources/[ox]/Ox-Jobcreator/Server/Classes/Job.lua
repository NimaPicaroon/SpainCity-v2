---@param name any
---@param label any
---@param ranks any
---@param points any
---@param options any
---@param blips any
---@param publicvehicles any
---@param privatevehicles any
---@return table
JOB.CreateJob = function(name, label, ranks, points, options, blips, publicvehicles, privatevehicles, wardrobe, shop, money, blackmoney)
    local self = { }

    self.name = name or "None"
    self.label = label or "None"
    self.ranks = ranks or { }
    self.points = points or { }
    self.options = options or { }
    self.blips = blips or { }
    self.publicvehicles = publicvehicles or { }
    self.privatevehicles = privatevehicles or { }
    self.inventory = {}

    TriggerEvent('storage:get', function(inventory)
        if inventory then
            self.inventory = inventory
        end
    end, tostring(name), 10000000)

    self.shop = shop or {}
    self.money = money or 0
    self.blackmoney = blackmoney or 0
    self.wardrobe = wardrobe or { }
    self.allmembers = { }
    self.update = false

    self.addBlackmoney = function(quantity)
        if quantity > 0 then
            self.blackmoney = self.blackmoney + quantity

            GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
            
            GlobalState.JobsData = JOB.Jobs

            for k, v in pairs(JOB.Jobs[self.name].players) do
                if v then
                    TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
                end
            end

            self.update = true

            return true
        end

        return false
    end

    self.removeBlackmoney = function(quantity)
        if quantity > 0 and (self.blackmoney - quantity) >= 0 then
            self.blackmoney = self.blackmoney - quantity

            GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
            
            GlobalState.JobsData = JOB.Jobs

            for k, v in pairs(JOB.Jobs[self.name].players) do
                TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
            end

            self.update = true

            return true
        end
        return false
    end

    ---comment
    ---@param newMarkers any
    ---@param cb any
    ---@return boolean or void
    self.updateMarkers = function (newMarkers, cb)
        self.points = newMarkers
        GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
        
        GlobalState.JobsData = JOB.Jobs

        if JOB.Jobs[self.name].players then
            for k, v in pairs(JOB.Jobs[self.name].players) do
                if v then
                    TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
                end
            end
        end
        self.update = true
        JOB.ExportDatabaseByJob(self.name, "markers")
        if cb then
            return cb(true)
        else
            return true
        end
    end

    self.updateSalaryByRankNumber = function(rank, newSalary)
        if(not self.ranks[rank])then
            return
        end
        self.ranks[rank].salary = tonumber(newSalary) or self.ranks[rank].salary or 0
        GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
        GlobalState.JobsData = JOB.Jobs
        self.update = true
        JOB.ExportDatabaseByJob(self.name, "ranks")
    end

    ---comment
    ---@param newVehs any
    ---@param cb any
    ---@return any
    self.updatePublicVehs = function (newVehs, cb)
        self.publicvehicles = newVehs
        GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
        
        GlobalState.JobsData = JOB.Jobs
        if JOB.Jobs[self.name].players then
            for k, v in pairs(JOB.Jobs[self.name].players) do
                if v then
                    TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
                end
            end
        end
        self.update = true
        JOB.ExportDatabaseByJob(self.name, "public_vehs")

        if cb then
            return cb(true)
        else
            return true
        end
    end

    self.updateShop = function (shop, cb)
        self.shop = shop
        GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
        
        GlobalState.JobsData = JOB.Jobs
        if JOB.Jobs[self.name].players then
            for k, v in pairs(JOB.Jobs[self.name].players) do
                if v then
                    TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
                end
            end
        end
        self.update = true
        JOB.ExportDatabaseByJob(self.name, "shop")
        if cb then
            return cb(true)
        else
            return true
        end
    end

    ---comment
    ---@param newOptions any
    ---@param cb any
    ---@return any
    self.updateOptions = function (newOptions, cb)
        self.options = newOptions
        GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
        
        GlobalState.JobsData = JOB.Jobs
        if JOB.Jobs[self.name].players then
            for k, v in pairs(JOB.Jobs[self.name].players) do
                if v then
                    TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
                end
            end
        end
        self.update = true
        JOB.ExportDatabaseByJob(self.name, "options")
        if cb then
            return cb(true)
        else
            return true
        end
    end

    ---comment
    self.addItemToInv = function(item, quantity, metadata, slotId, src)
        if self.inventory:Inventory().add(item, quantity, metadata, slotId, W.GetPlayer(src)) then
            return true
        end

        return false
    end

    self.fetchMembers = function ()
        self.allmembers = { }
        MySQL.Async.fetchAll("SELECT * FROM `players`", {}, function (data)
            for k, v in pairs(data) do
                local ParsedData = json.decode(v.job)
                if ParsedData.name == self.name then
                    table.insert(self.allmembers, { name = v.name, license = v.token, rank = ParsedData.rank, rankname = ParsedData.rankname })
                end
            end
        end)
    end

    self.addOutfit = function (skin, name)
        table.insert(self.wardrobe, {name = name, skin = json.encode(skin)})

        self.update = true
    end

    self.deleteOutfit = function (data)
        for k,v in pairs(self.wardrobe) do
            if data.name == v.name and data.skin == v.skin then
                table.remove(self.wardrobe, k)
            end
        end

        self.update = true
    end

    self.getMoney = function()
        return self.money
    end

    self.addMoney = function(quantity)
        if quantity > 0 then
            self.money = self.money + quantity

            GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
            
            GlobalState.JobsData = JOB.Jobs
            for k, v in pairs(JOB.Jobs[self.name].players) do
                TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
            end

            self.update = true
        end
    end

    self.removeMoney = function(quantity, callback)
        local money = self.getMoney()

        if money - quantity < 0 then
            if callback then
                return callback(false, 'No puedes retirar esta cantidad de dinero, no hay suficiente en los fondos.')
            end
        elseif money - quantity >= 0 then
            self.money = self.money - quantity

            GlobalState[self.name.."-guille"] = JOB.Jobs[self.name]
            
            GlobalState.JobsData = JOB.Jobs
            for k, v in pairs(JOB.Jobs[self.name].players) do
                TriggerClientEvent("jobcreatorv2:client:initData", tonumber(v))
            end
            self.update = true

            if callback then
                return callback(true)
            end
        end
    end

    return self
end

