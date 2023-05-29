function CreateHouse(pOwner, id, price, points, bought, furniture, blackmoney, shell, ownerData, style, gang, key_code)
    local this      = {}
    this.owner      = pOwner
    this.ownerData  = ownerData
    this.id         = id
    this.price      = price
    this.points     = points
    this.bought     = bought
    this.furniture  = furniture
    this.blackmoney = blackmoney
    this.shell      = shell
    this.style      = style
    this.gang       = gang
    this.key_code = key_code or false
    this.inventory  = {}

    __init = function()
        local weight = 10000
        local gangs = exports['Ox-Gangs']:GetGangs()

        if this.gang ~= '' and gangs and gangs[this.gang] and gangs[this.gang].level and Housing.Weights[gangs[this.gang].level] then
            weight = Housing.Weights[gangs[this.gang].level]
        end

        TriggerEvent('storage:get', function(inventory)
            if inventory then
                this.inventory = inventory
            end
        end, "house"..this.id, weight) 
    end

    __init()

    this.addBlackmoney = function(quantity)
        if quantity > 0 then
            this.blackmoney = this.blackmoney + quantity
            MySQL.Async.execute("UPDATE `housing` SET `blackmoney` = ? WHERE `id` = ?", {
                this.blackmoney,
                this.id
            })
            return true
        end

        return false
    end

    this.removeBlackmoney = function(quantity)
        if quantity > 0 and (this.blackmoney - quantity) >= 0 then
            this.blackmoney = this.blackmoney - quantity
            MySQL.Async.execute("UPDATE `housing` SET `blackmoney` = ? WHERE `id` = ?", {
                this.blackmoney,
                this.id
            })
            return true
        end
        return false
    end

    this.changeKeyCode = function()
        local newCode = this.generateKeyCode()
        this.key_code = newCode
        MySQL.Async.execute("UPDATE `housing` SET `key_code` = ? WHERE `id` = ?", {
            this.key_code,
            this.id
        })
        return true
    end

    this.generateKeyCode = function()
        return math.random(1000000, 9999999)
    end

    function this.houseInfo()

        local info = {}

        function info.getOwner(cb)
            if cb then
                return cb(this.owner)
            else
                return this.owner
            end
        end

        function info.getId(cb)
            if cb then
                return cb(this.id)
            else
                return this.id
            end
        end

        function info.getPrice(cb)
            if cb then
                return cb(this.price)
            else
                return this.price
            end
        end

        function info.getPoints(cb)
            if cb then
                return cb(this.points)
            else
                return this.points
            end
        end

        function info.isBought(cb)
            if cb then
                return cb(this.bought)
            else
                return this.bought
            end
        end

        function info.getFurniture(cb)
            if cb then
                return cb(this.furniture)
            else
                return this.furniture
            end
        end

        function info.getInv(cb)
            if cb then
                return cb(this.inventory)
            else
                return this.inventory
            end
        end

        function info.getShell(cb)
            if cb then
                return cb(this.shell)
            else
                return this.shell
            end
        end

        function info.getVehicles(cb, identifier)
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE garage=@garage AND owner=@identifier', {
                ["@garage"] = 'house'..this.id,
                ["@identifier"] = identifier
            }, function(data)
                local vehicules = {}
                if data then
                    for _, v in pairs(data) do
                        local vehicle = json.decode(v.vehicle)

                        table.insert(vehicules, {
                            vehicle = vehicle,
                            state = v.state,
                            plate = v.plate
                        })
                    end
                    while #vehicules < #data do
                        Wait(10)
                    end
                    return cb(vehicules)
                else
                    return cb(vehicules)
                end
            end)
        end

        function info.getStyle(cb)
            if cb then
                return cb(this.style)
            else
                return this.style
            end
        end

        return info

    end

    function this.houseManagement()
        local mng = {}

        function mng.ownHouse(identifier, _src, cb)
            local newInfo = {
                bought = 1,
                price = this.price,
                shell = this.shell,
            }
            this.owner = {identifier = identifier, name = GetPlayerName(_src)}
            this.bought = 1
            table.insert(this.ownerData, {owner = {identifier = identifier, name = GetPlayerName(_src)}})
            MySQL.Async.execute("UPDATE players SET have_house = @id WHERE token = @identifier", {
                ["@identifier"] = identifier,
                ["@id"] = this.id
            })
            local xPlayer = W.GetPlayer(_src)
            if this.gang == '' then
                if xPlayer.canHoldItem("house_keys", 1) then
                    this.changeKeyCode()
                    xPlayer.addItemToInventory("house_keys", 1, { house = id, house_owner = GetCharacterName(_src), house_key_code = Houses[id].key_code})
                else
                    xPlayer.Notify('INVENTARIO', 'No puedes recibir nada más', 'error')
                    return false
                end
            end
            MySQL.Async.execute("UPDATE housing SET owners = @owners, info = @info WHERE id = @id", {
                ['@owners'] = json.encode(this.ownerData),
                ['@info'] = json.encode(newInfo),
                ['@id'] = this.id,
            }, function(row)
                if cb then
                    return cb(true)
                else
                    return true
                end
            end)
            if cb then
                return cb(false)
            else
                return false
            end
        end

        function mng.sellHouse(_src, identifier, cb)
            local newInfo = {
                bought = 0,
                price = this.price,
                shell = this.shell,
            }
            this.owner = {}
            this.ownerData = {}
            this.furniture = {}
            this.blackmoney = {}
            this.paints = {}
            this.bought = 0
            this.gang = ''
            if identifier then
                MySQL.Async.execute("UPDATE players SET have_house = '0' WHERE token = @identifier", {
                    ["@identifier"] = identifier
                })
            end
            TriggerEvent("storage:delete", "house" .. this.id)
            MySQL.Async.execute("UPDATE housing SET owners = @owners, furniture = @furniture, blackmoney = @blackmoney, paints = @paints, gang = @gang, info = @info WHERE id = @id", {
                ['@owners'] = json.encode(this.ownerData),
                ['@info'] = json.encode(newInfo),
                ['@furniture'] = json.encode(this.furniture),
                ['@blackmoney'] = 0,
                ['@paints'] = json.encode(this.paints),
                ['@gang'] = this.gang,
                ['@id'] = this.id
            }, function(row)
                MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE garage=@garage', {
                    ["@garage"] = 'house'..this.id
                }, function(data)
                    if data[1] then
                        MySQL.Async.execute("UPDATE owned_vehicles SET stored = 'false', garage = 'OUT' WHERE garage = @garage", {
                            ['@garage'] = 'house'..this.id
                        }, function(row)
                            if row then
                                if cb then
                                    return cb(true)
                                else
                                    return true
                                end
                            end
                        end)
                    else
                        if cb then
                            return cb(true)
                        else
                            return true
                        end
                    end
                end)
            end)
            if cb then
                return cb(false)
            else
                return false
            end
        end

        function mng.saveVehicle(identifier, properties, plate, cb)
            MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate", {
                ['@owner'] = identifier,
                ['@plate'] = plate,
            }, function(result)
                if #result ~= 0 then
                    MySQL.Async.execute("UPDATE owned_vehicles SET vehicle = @vehicles, stored='true', garage=@garage WHERE plate = @plate", {
                        ['@vehicles'] = json.encode(properties),
                        ['@garage'] = 'house'..this.id,
                        ['@plate'] = plate
                    }, function(row)
                        if row then
                            if cb then
                                return cb(true)
                            else
                                return true
                            end
                        end
                    end)
                else
                    if cb then
                        return cb(false)
                    else
                        return false
                    end
                end
            end)
        end

        function mng.getVehicle(veh, cb)
            MySQL.Async.execute("UPDATE owned_vehicles SET stored='false', garage='OUT' WHERE plate = @plate", {
                ['@plate'] = veh.plate
            }, function(row)
                if row then
                    if cb then
                        return cb(true)
                    else
                        return true
                    end
                end
            end)
            if cb then
                return cb(false)
            else
                return false
            end
        end

        function mng.addFurni(obj, coords, heading, cb)
            table.insert(this.furniture, {object = {obj = obj, coords = coords, heading = heading}})
            MySQL.Async.execute("UPDATE housing SET furniture = @furni WHERE id = @id", {
                ['@furni'] = json.encode(this.furniture),
                ['@id'] = this.id
            }, function(row)
                if cb then
                    return cb(true)
                else 
                    return true
                end
            end)
            if cb then
                return cb(false)
            else
                return false
            end
        end

        function mng.deleteFurni(coords, cb)
            for k,v in pairs(this.furniture) do
                local dist = #(vector3(v.object.coords.x, v.object.coords.y, v.object.coords.z) - coords)
                if dist < 0.15 then
                    table.remove(this.furniture, k)
                    log("Delete furniture")
                end
            end
            MySQL.Async.execute("UPDATE housing SET furniture = @furni WHERE id = @id", {
                ['@furni'] = json.encode(this.furniture),
                ['@id'] = this.id
            }, function(row)
                if cb then
                    return cb(true)
                else 
                    return true
                end
            end)
            if cb then
                return cb(false)
            else
                return false
            end
        end

        
        function mng.addItemToInv(type, name, count, label, cb)
            local found = false
            if #this.inventory >= 1 then
                for k, v in pairs(this.inventory) do
                    if v.type == "item_account" and type == "item_account" and name == v.name then
                        table.insert(this.inventory, {type = type, label = label, name = name, count = v.count + count})
                        table.remove(this.inventory, k)
                        found = true
                        break
                    elseif v.type == "item_standard" and type == "item_standard" and name == v.name then
                        table.insert(this.inventory, {type = type, label = label, name = name, count = v.count + count})
                        table.remove(this.inventory, k)
                        found = true
                        break
                    end
                end
                
            end
            if not found then
                table.insert(this.inventory, {type = type, label = label, name = name, count = count})
            end
            MySQL.Async.execute("UPDATE housing SET inventory=@inventory WHERE id = @id", {
                ['@inventory'] = json.encode(this.inventory),
                ['@id'] = this.id
            }, function(rows)
                if rows then
                    if cb then
                        return cb(true)
                    else
                        return true
                    end
                end
            end)
            if cb then
                cb(false)
            else
                return false
            end
        end
        
        function mng.removeItemOfInv(type, name, count, cb)
            local found = false
            if #this.inventory >= 1 then
                for k, v in pairs(this.inventory) do
                    if v.type == "item_account" and type == "item_account" then
                        if v.name == name then
                            if v.count >= 1 then
                                this.inventory[k]['count'] = v.count - count
                                if this.inventory[k]['count'] == 0 then
                                    table.remove(this.inventory, k)
                                end
                                found = true
                                break
                            else
                                table.remove(this.inventory, k)
                                found = true
                                break
                            end

                        end
                    elseif v.type == "item_standard" and type == "item_standard" then
                        if v.name == name then
                            if v.count == 0 then
                                table.remove(this.inventory, k)
                            end
                            if v.count > 1 then
                                this.inventory[k]['count'] = v.count - count
                                if this.inventory[k]['count'] == 0 then
                                    table.remove(this.inventory, k)
                                end
                                found = true
                                break
                            else
                                table.remove(this.inventory, k)
                                found = true
                                break
                            end
                        end
                    elseif v.type == "item_weapon" and type == "item_weapon" then
                        if v.name == name then
                            table.remove(this.inventory, k)
                            found = true
                            break
                        end
                    end
                end
            end
            MySQL.Async.execute("UPDATE housing SET inventory=@inventory WHERE id = @id", {
                ['@inventory'] = json.encode(this.inventory),
                ['@id'] = this.id
            }, function(rows)
                if rows then
                    if cb then
                        return cb(true)
                    else
                        return true
                    end
                end
            end)
            if cb then
                cb(false)
            else
                return false
            end
        end

        function mng.changeStyle(type, initTxd, initTxn, url)
            local found = false
            for k, v in pairs(this.style) do
                if v.style.type == type then
                    log("Remplacing new wall")
                    table.insert(this.style, {style = {type = type, initTxd = initTxd, initTxn = initTxn, url = url}})
                    table.remove(this.style, k)
                    found = true
                    break
                end
            end
            if not found then
                log("Putting new wall")
                table.insert(this.style, {style = {type = type, initTxd = initTxd, initTxn = initTxn, url = url}})
            end
            MySQL.Async.execute("UPDATE housing SET paints = @paints WHERE id = @id", {
                ['@paints'] = json.encode(this.style),
                ['@id'] = this.id,
            }, function(rows)
                if rows then
                    if cb then
                        return cb(true)
                    else
                        return true
                    end
                end
            end)
            if cb then
                cb(false)
            else
                return false
            end
        end
        return mng

    end

    return this

end