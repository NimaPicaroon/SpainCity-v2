local encode = json.encode
local decode = json.decode
Gangs = { }
setmetatable(Gangs, {})

CreateGang = function (name, label, points, blip, ranks, wardrobe, level, vehicles, money, blackmoney)
    local self = { }
    self.name = name or 'Not name'
    self.label = label or 'Not label'
    self.points = points or {}
    self.ranks = ranks or {}
    self.blip = blip or {}
    self.level = tonumber(level) or 1
    self.wardrobe = wardrobe or {}
    self.vehicles = vehicles or {}
    self.players  = {}
    self.inventory = {}
    self.money = tonumber(money) or 0
    self.blackmoney = tonumber(blackmoney) or 0
    self.update = false

    TriggerEvent("ZC-Storage:server:getInventory", function (exist)
        if exist then
            self.inventory = exist
        else
            TriggerEvent('ZC-Storage:server:createInventory', tostring(name), Config.Weights[self.level], function(storage)
                self.inventory = storage
            end)
        end
    end, tostring(name))

    function self.saveGang()
        MySQL.Async.execute("UPDATE `gangs` SET `label` = ?, `points` = ?, `blip` = ?, `ranks` = ?, `wardrobe` = ?, `level` = ?, `vehicles` = ?, `money` = ?, `blackmoney` = ? WHERE `name` = ?", {
            self.label,
            encode(self.points),
            encode(self.blip),
            encode(self.ranks),
            encode(self.wardrobe),
            self.level,
            encode(self.vehicles),
            self.money,
            self.blackmoney,
            self.name
        })
        self.updated = false
    end

    self.deleteOutfit = function (data)
        for k,v in pairs(self.wardrobe) do
            if data.name == v.name and data.skin == v.skin then
                table.remove(self.wardrobe, k)
            end
        end

        JOB.Execute("UPDATE gangs SET wardrobe = ? WHERE name = ?", {
            encode(self.wardrobe),
            self.name
        })
    end

    self.addBlackmoney = function(quantity)
        if quantity > 0 then
            self.money = self.money + quantity
            self.update = true
            return true
        end

        return false
    end

    self.removeBlackmoney = function(quantity)
        if quantity > 0 and (self.money - quantity) >= 0 then
            self.money = self.money - quantity
            self.update = true
            return true
        end
        return false
    end

    self.editGang = function (data)
        self.name = data.name or 'Not name'
        self.label = data.label or 'Not label'
        self.points = data.points or {}
        self.ranks = data.ranks or {}
        self.blip = data.blip or {}
        self.level = tonumber(data.level) or 1
        self.wardrobe = data.wardrobe or {}
        self.vehicles = data.vehicles or {}
        self.saveGang()
        for k, v in pairs(self.players) do
            TriggerClientEvent("Ox-Gangs:fetchGang", tonumber(v), self)
        end
        TriggerClientEvent('Ox-Gangs:gangsInfo', -1, Gangs)
        return true, Gangs
    end

    W.Print("INFO", ("Gang '%s' created"):format(self.name))
    return self
end

CreateThread(function()
    MySQL.ready(function ()
        Wait(2000)
        MySQL.Async.fetchAll("SELECT * FROM `gangs`", { }, function (result)
            for i = 1, #result do
                Gangs[result[i].name] = CreateGang(result[i].name, result[i].label, decode(result[i].points), decode(result[i].blip), decode(result[i].ranks), decode(result[i].wardrobe), tonumber(result[i].level), decode(result[i].vehicles), tonumber(result[i].money), tonumber(result[i].blackmoney))
            end
        end)
        Wait(1000)
        TriggerClientEvent('Ox-Gangs:gangsInfo', -1, Gangs)
    end)
end)

W.CreateCallback("Ox-Gangs:editGang", function(source, cb, data)
    local Gang = Gangs[data.name]
    if Gang then
        cb(Gang.editGang(data))
    else
        cb(false)
    end
end)

W.CreateCallback("Ox-Gangs:createGang", function(source, cb, data)
    MySQL.Async.execute("INSERT INTO `gangs` (name, label, points, blip, ranks, wardrobe, level, vehicles, money, blackmoney) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {
        data.name,
        data.label,
        encode(data.points),
        encode(data.blip),
        encode(data.ranks),
        encode({}),
        data.level,
        encode({}),
        0,
        0
    }, function ()
        Gangs[data.name] = CreateGang(data.name, data.label, data.points, data.blip, data.ranks, {}, data.level, {}, 0, 0)
        cb(true, Gangs)
        TriggerClientEvent('Ox-Gangs:gangsInfo', -1, Gangs)
    end)
end)

exports('GetGangs', function()
    return Gangs
end)

W.CreateCallback("Ox-Gangs:deleteGang", function(source, cb, name)
    if Gangs[name] then
        TriggerEvent('ZC-Storage:server:deleteInventory', tostring(name))
        for k,v in pairs(Gangs[name].players) do
            RemoveGang(v)
        end
        Gangs[name] = nil
        MySQL.Async.execute('DELETE FROM gangs WHERE name = @name', {
            ['@name'] = name,
        })
        cb(true, Gangs)
        TriggerClientEvent('Ox-Gangs:gangsInfo', -1, Gangs)
    else
        cb(false)
    end
end)

W.Thread(function()
    while true do
        local wait = 5 --[[Mins]] * 60 --[[60 seconds in a min]] * 1000 --[[1 sec]]
        Wait(wait)
        local num = 0
        for k,v in pairs(Gangs) do
            if v.updated then
                v:saveGang()
                num = num + 1
            end
        end
        TriggerClientEvent('Ox-Gangs:gangsInfo', -1, Gangs)
        W.Print("INFO", ("'%s' Gangs saved"):format(num))
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        for k,v in pairs(Gangs) do
            v:saveGang()
        end
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(45000)
            for k,v in pairs(Gangs) do
                v:saveGang()
            end
        end)
    end
end)