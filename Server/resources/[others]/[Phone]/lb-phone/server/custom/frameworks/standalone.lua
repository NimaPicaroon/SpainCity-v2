W = exports['ZCore']:get()

CreateThread(function()
    if Config.Framework ~= "standalone" then
        return
    end

    --- @param source number
    --- @return string | nil
    function GetIdentifier(source)
        for _, v in pairs(GetPlayerIdentifiers(source)) do
            if v:sub(1, #"license:") == "license:" then
                return v
            end
        end
    end

    ---Check if a player has a phone with a specific number
    ---@param source any
    ---@param number string
    ---@return boolean
    function HasPhoneItem(source, number)
        if not Config.Item.Require then
            return true
        end

        if GetResourceState("ox_inventory") == "started" then
            return (exports.ox_inventory:Search(source, "count", Config.Item.Name) or 0) > 0
        end

        local player = W.GetPlayer(source)
        local have = player.getItem(Config.Item.Name)
        if not have then
            return false
        end

        return MySQL.Sync.fetchScalar("SELECT 1 FROM phone_phones WHERE id=@id AND phone_number=@number", {
            ["@id"] = GetIdentifier(source),
            ["@number"] = number
        }) ~= nil
    end

    ---Get a player's character name
    ---@param source any
    ---@return string # Firstname
    ---@return string # Lastname
    function GetCharacterName(source)
        local player = W.GetPlayer(source)
        return player.identity.name, player.identity.lastname
    end

    ---Get an array of player sources with a specific job
    ---@param job string
    ---@return table # Player sources
    function GetEmployees(job)
        local employees = {}
        local players = W.GetPlayers()
        for _, v in pairs(players) do
            if v.job.name == job and v.job.duty then
                employees[#employees+1] = v.source
            end
        end
        return employees
    end

    ---Get the bank balance of a player
    ---@param source any
    ---@return integer
    function GetBalance(source)
        local ply = W.GetPlayer(source)
        local bankm = ply.getMoney('bank')
        return bankm
    end

    ---Add money to a player's bank account
    ---@param source any
    ---@param amount integer
    ---@return boolean # Success
    function AddMoney(source, amount)
        local player = W.GetPlayer(source)
        player.addMoney('bank', amount)
        return true
    end

    ---Remove money from a player's bank account
    ---@param source any
    ---@param amount integer
    ---@return boolean # Success
    function RemoveMoney(source, amount)
        local player = W.GetPlayer(source)
        player.removeMoney('bank', amount)
        return true
    end

    ---Send a message to a player
    ---@param source number
    ---@param message string
    function Notify(source, message)
        -- TriggerClientEvent("chat:addMessage", source, {
        --     color = { 255, 255, 255 },
        --     multiline = true,
        --     args = { "Phone", message }
        -- })
        local player = W.GetPlayer(source)
        player.Notify("Movil", message, "info")
    end

    -- GARAGE APP
    function GetPlayerVehicles(source, cb)
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@owner", {
            ["@owner"] = GetIdentifier(source)
        }, function(vehicles)
            local toSend = {}

            for _, v in pairs(vehicles) do
                if type(v.stored) ~= "boolean" then
                    v.stored = v.stored == 1
                end

                if GetResourceState("cd_garage") == "started" then
                    debugprint("Using cd_garage")
                    v.stored = v.in_garage or v.in_garage == 1
                    v.garage = v.garage_id
                elseif GetResourceState("loaf_garage") == "started" then
                    v.stored = 1
                end

                local newCar = {
                    plate = v.plate,
                    type = v.type,
                    location = v.stored and (v.garage or "Garage") or "out",
                    statistics = {}
                }

                if v.damages then
                    local damages = json.decode(v.damages)
                    if damages?.engineHealth then
                        newCar.statistics.engine = math.floor(damages.engineHealth / 10 + 0.5)
                    end

                    if damages?.bodyHealth then
                        newCar.statistics.body = math.floor(damages.bodyHealth / 10 + 0.5)
                    end
                end

                local vehicle = json.decode(v.vehicle)
                if vehicle.fuel then
                    newCar.statistics.fuel = math.floor(vehicle.fuel + 0.5)
                end

                newCar.model = vehicle.model

                toSend[#toSend+1] = newCar
            end

            cb(toSend)
        end)
    end

    function GetVehicle(source, cb, plate)
        local storedColumn, storedValue = "stored", 1
        if GetResourceState("cd_garage") == "started" then
            storedColumn = "in_garage"
        end
        MySQL.Async.fetchAll(([[
            SELECT * FROM owned_vehicles
            WHERE owner=@owner AND plate=@plate AND `type`="car" AND `%s`=@stored
        ]]):format(storedColumn), {
            ["@owner"] = GetIdentifier(source),
            ["@plate"] = plate,
            ["@stored"] = storedValue
        }, function(res)
            if not res[1] then
                return cb(false)
            end

            MySQL.Async.execute(("UPDATE owned_vehicles SET `%s`=0 WHERE plate=@plate"):format(storedColumn), {
                ["@plate"] = plate
            })

            cb(res[1])
        end)
    end

    function IsAdmin(source)
        return IsPlayerAceAllowed(source, "command.lbphone_admin") == 1
    end

     -- COMPANIES APP
     function GetJob(source)
        local ply = W.GetPlayer(source)
        local Job = ply.job.name
        return Job or "unemployed"
    end

    function RefreshCompanies()
        local openJobs = {}
        local players = W.GetPlayers()
        for _, v in pairs(players) do
            if not v.job.duty then
                goto continue
            end

            local job = v.job.name
            if not openJobs[job] then
                openJobs[job] = true
            end

            ::continue::
        end

        for i = 1, #Config.Companies.Services do
            local jobData = Config.Companies.Services[i]
            Config.Companies.Services[i].open = openJobs[jobData.job] or false
        end
    end
end)