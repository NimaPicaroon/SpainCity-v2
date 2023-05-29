W.Connection = { }
W.Players = {}
W.PlayersSource = {}
W.PlayersCache = {}
W.Maintenance = false

RegisterCommand("mantenimiento", function(src)
    if src == 0 then
        W.Maintenance = not W.Maintenance
        if(W.Maintenance)then
            W.Print("INFO", "Maintenance status changed: Active")
        else
            W.Print("INFO", "Maintenance status changed: Resting")
        end
    end
end)

MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT `name`, `token`, `discord`, `group`, `coords`, `inventory`, `skills`, `money`, `identity`, `status`, `skin`, `metadata`, `ped`, `job`, `gang`, `bills`, `dimension`, `dead`, `phone`, `fade`, `vip` FROM `players`', {}, function (result)
        for _, row in ipairs(result) do
            W.PlayersCache[row.token] = row
            W.Metadata.AllData[row.token] = {
                data = json.decode(row.metadata) or {},
                name = row.name,
                discord = row.discord,
            }
        end
    end)
end) 

W.Connection.LoadPlayer = function(source, newData)
    local src <const> = tonumber(source)
    CreateThread(function()
        W.GetIdentifier(src, function(identifier)
            if identifier then
                local data = W.PlayersCache[identifier]
                local name = GetPlayerName(src)

                if data and data.token then
                    if type(data.identity) == 'string' then
                        data.identity = json.decode(data.identity)
                    end

                    if W.Maintenance and data.group ~= "admin" then
                        DropPlayer(src, 'Servidor en mantenimiento')
                        return false
                    end

                    local inventory = json.decode(data.inventory)

                    for key, value in next, inventory.items do
                        if not W.Items[value.item] then
                            print('Item deleted is '..value.item..'.')
                            inventory[key] = nil
                        end
                    end
                    
                    local bills = json.decode(data.bills)
                    W.Plys[src] = W.CreatePlayer(src, name, identifier, data.discord, data.group, json.decode(data.coords), inventory, json.decode(data.skills), json.decode(data.money), data.identity, json.decode(data.status), json.decode(data.skin), data.ped, json.decode(data.job), json.decode(data.gang), bills, tonumber(data.dimension), tonumber(data.dead), tonumber(data.phone), json.decode(data.fade), tonumber(data.vip), json.decode(data.metadata) or {})
                    W.PlayersSource[src] = { disconnected = false, source = src }
                    W.Metadata.Register(identifier, json.decode(data.metadata) or {}, name, src)
                    W.Print("INFO", "Player ^5"..src.."^7 have been loaded")
                    TriggerClientEvent("core:client:spawnAndCreatePlayer", src, json.decode(data.coords), data.ped, false, data.dimension)
                    W.SendToDiscord("access", "Jugador accediendo al servidor", "ZCore", src)
                    Wait(150)
                    TriggerClientEvent("ZCore:createDrops", src, W.NewDrops, W.NewObjects)
                    TriggerClientEvent("ZCore:registerSuggestions", src, W.Commands)
                    TriggerEvent("ZCore:playerLoaded", src, W.Plys[src])

                    return true
                else
                    W.CreateNewPlayer(src, identifier, newData)
                    W.PlayersSource[src] = { disconnected = false, source = src }
                    Wait(300)
                    TriggerClientEvent("ZCore:createDrops", src, W.NewDrops, W.NewObjects)
                    TriggerClientEvent("ZCore:registerSuggestions", src, W.Commands)
                    TriggerEvent("ZCore:playerLoaded", src, W.Plys[src])

                    return true
                end
            else
                DropPlayer(src, 'Algo ha fallado, abre ticket en Wave (ID: identifier-not-exists)')

                return false
            end
        end)

        return false
    end)
end

W.Connection.ClearCacheInfo = function(token, ckmode)
    if(token and W.PlayersCache[token])then
        W.Print("INFO", "Player with ^5"..token.."^7 had cleared his cache")
        W.PlayersCache[token] = nil
        if(ckmode)then
            W.SaverQueue.CKMode[token] = false
        end
    end
end

W.Connection.UpdateCacheInfo = function(token, key, value)
    if(token and W.PlayersCache[token])then
        W.Print("INFO", "Cache of player with ^5"..token.."^7 has been updated")
        W.PlayersCache[token][key] = value
    end
end

RegisterNetEvent("core:server:updateCacheInfo", W.Connection.UpdateCacheInfo)

W.Connection.GetCacheInfo = function(token, key)
    if(token and W.PlayersCache[token])then
        if(key)then
            return W.PlayersCache[token][key]
        else
            return W.PlayersCache[token]
        end
    end
end

RegisterNetEvent("core:server:getCacheInfo", W.Connection.UpdateCacheInfo)