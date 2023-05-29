UnitsRadar = {
    active = {},
    subscribers = {},
    callsigns = {},
	__index = self,
	init = function(o)
		o = o or {active = {}, subscribers = {}, callsigns = {}}
		setmetatable(o, self)
		self.__index = self
		return o
	end 
}

function UnitsRadar:subscribe(serverID) -- Allows to "spectate" units radar without being shown on the map
    self.subscribers['source-'..serverID] = { source = serverID }
end

function UnitsRadar:unsubscribe(serverID) 
    self.subscribers['source-'..serverID] = nil
end

function UnitsRadar:addUnit(serverID, type, number, subscribe)
    type = tonumber(type) or 0
    self.active['source-'..serverID] = {
        type = type,
        number = number,
        source = tonumber(serverID)
    }
    if subscribe ~= false then
        self:subscribe(serverID)
    end
end

function UnitsRadar:setUnitType(serverID, type)
    type = tonumber(type)
    if not type then
        return
    end
    if self.active['source-'..serverID] then
        self.active['source-'..serverID].type = type
    end
end

function UnitsRadar:removeUnit(serverID, unsubscribe)
    if self.active['source-'..serverID] then
        self.active['source-'..serverID] = nil

        if unsubscribe ~= false then
            TriggerClientEvent('police:removeBlips', serverID)

            self:unsubscribe(serverID)
        end
        for k, v in pairs(self.subscribers) do
            if v and v.source then
                TriggerClientEvent('police:removeUnit', v.source, serverID)
            end
        end
        -- sendMessage(serverID, "You're now shown off-duty.", "Radar")
    end
end

function UnitsRadar:hide()
    if self.blips then
        self.blips = false
    end
end

function UnitsRadar:hideUnit(serverID)
    if self.active['source-'..serverID] then
        self:removeUnit(serverID, false)
    end
end

function UnitsRadar:showUnit(serverID)
    if not self.active['source-'..serverID] then
        self:addUnit(serverID, nil, nil, false)
        self:requestInfo(serverID)
    end
end

function UnitsRadar:requestInfo(serverID)
    if self.active['source-'..serverID] then
        TriggerClientEvent('police:requestUnitInfo', serverID)
    end
end

function UnitsRadar:updateBlips(frequency)
    frequency = tonumber(frequency) or 3000
    self.blips = true
    Citizen.CreateThread(function()
        while self.blips do
            Citizen.Wait(frequency)
            
            for k, v in pairs(self.active) do
                local playerPed = GetPlayerPed(v.source)
                self.active[k].coords = GetEntityCoords(playerPed)
                self.active[k].heading = math.ceil(GetEntityHeading(playerPed))
            end
            for k, v in pairs(self.subscribers) do
                if v and v.source then
                    TriggerClientEvent('police:updateBlips', v.source, self.active)
                end
            end
        end

        for k, v in pairs(self.subscribers) do
            if v and v.source then
                TriggerClientEvent('police:removeBlips', v.source)
            end
        end
    end)
    return function()
        self.blips = false
    end
end

UnitsRadar:updateBlips()

--================================--
--              SYNC              --
--================================--

RegisterNetEvent('playerDropped')
AddEventHandler('playerDropped', function()
    UnitsRadar:removeUnit(source)
end)

RegisterNetEvent('police:addUnit')
AddEventHandler('police:addUnit', function(serverID, type, number, subscribe)
    serverID = tonumber(serverID)
    if source > 0 or not serverID or serverID < 1 or not GetPlayerIdentifier(serverID, 0) then
        return
    end
    type = tonumber(type) or 1
    UnitsRadar:addUnit(serverID, type, number, subscribe)
end)
RegisterNetEvent('police_refs:addUnit')
AddEventHandler('police_refs:addUnit', function()
    UnitsRadar:addUnit(source)
    --UnitsRadar:updateBlips()
    TriggerClientEvent("myx:showNotification", source, "Has activado la referencia")
end)

RegisterNetEvent('police:hideUnit')
AddEventHandler('police:hideUnit', function(serverID)
    serverID = tonumber(serverID)
    if source > 0 or not serverID or serverID < 1 then
        return
    end
    UnitsRadar:hideUnit(serverID)
end)

RegisterNetEvent('police:showUnit')
AddEventHandler('police:showUnit', function(serverID)
    serverID = tonumber(serverID)
    if source > 0 or not serverID or serverID < 1 then
        return
    end
    UnitsRadar:shotUnit(serverID)
end)

RegisterNetEvent('police:subscribe')
AddEventHandler('police:subscribe', function(serverID)
    serverID = tonumber(serverID)
    if source > 0 or not serverID or serverID < 1 then
        return
    end
    UnitsRadar:subscribe(serverID)
end)

RegisterNetEvent('police:unsubscribe')
AddEventHandler('police:unsubscribe',function(serverID)
    serverID = tonumber(serverID)
    if source > 0 or not serverID or serverID < 1 then
        return
    end
    UnitsRadar:unsubscribe(serverID)
end)

RegisterNetEvent('police:removeUnit')
AddEventHandler('police:removeUnit',function(serverID, type)
    serverID = tonumber(serverID)
    if source > 0 or not serverID or serverID < 1 then
        return
    end

    UnitsRadar:removeUnit(serverID)
end)


--================================--
--            COMMANDS            --
--================================--

RegisterCommand("r", function(source, args)
    local xPlayer = W.GetPlayer(source)
    if xPlayer.job.name == "police" then
        if args[1] ~= nil then
            UnitsRadar:removeUnit(source)
            UnitsRadar:addUnit(source, args[1])
            -- UnitsRadar:updateBlips()
            xPlayer.Notify('Referencias', "Has activado la referencia en el color " .. args[1], 'verify')
        else
            UnitsRadar:removeUnit(source)
            UnitsRadar:addUnit(source, 1)
            -- UnitsRadar:updateBlips()
            xPlayer.Notify('Referencias', "Has activado la referencia", 'verify')
        end
    end
end)

RegisterCommand("removeBlip", function(source)
    local xPlayer = W.GetPlayer(source)
    if xPlayer.job.name == "police" then
        UnitsRadar:removeUnit(source) 
    end
end)

RegisterCommand("activeBlip", function(source)
    local xPlayer = W.GetPlayer(source)
    if xPlayer.job.name == "police" then
        UnitsRadar:addUnit(source, 0)
    end
end)

RegisterCommand("nr", function(source)
    local xPlayer = W.GetPlayer(source)
    if xPlayer.job.name == "police" then
        UnitsRadar:removeUnit(source)
        UnitsRadar:addUnit(source, 0)
        xPlayer.Notify("REFERENCIAS", "Has puesto la referencia blanca", "verify")
    end
end)

--================================--
--         AUTO-SUBSCRIBE         --
--================================--

Polices = { }

exports('getPolices', function()
    return Polices
end)

RegisterNetEvent('references:addUnit', function()
    local src = source
    local ply = W.GetPlayer(src)

    if not ply then
        return
    end

    if ply.job.name == 'police' and ply.job.duty then
        Polices[source] = { source = src }
        UnitsRadar:addUnit(src, 0)
    end
end)

AddEventHandler('ZCore:playerLoaded', function(source, player)
    if player and player.job.name == 'police' and player.job.duty then
        Polices[source] = { source = source }
    end
end)

AddEventHandler('ZCore:setJob', function(source, newJob, lastJob)
    if lastJob.name == 'police' and newJob.name ~= 'police' then
        Polices[source] = nil
        UnitsRadar:removeUnit(source)

        return
    end

    if lastJob.name ~= 'police' and newJob.name == 'police' and newJob.duty then
        Polices[source] = { source = source }
        UnitsRadar:addUnit(source, 0)

        return
    end
end)

AddEventHandler('ZCore:setDuty', function(source, newJob, lastJob)
    local src = source
    local player = W.GetPlayer(src)

    if newJob.name == 'police' and player.job.duty then
        Polices[source] = { source = source }
        UnitsRadar:addUnit(src, 0)
        
        return
    elseif newJob.name == 'police' and not player.job.duty then
        Polices[source] = { source = source }
        UnitsRadar:removeUnit(src)

        return
    end
end)

AddEventHandler("playerDropped", function()
    local src = source

    if Polices[src] then
        Polices[src] = nil
        UnitsRadar:removeUnit(src) 
    end
end)