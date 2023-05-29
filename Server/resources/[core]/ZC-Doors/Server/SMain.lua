local _doorCache = {}

isAllowed = function(id)
    local player = W.GetPlayer(id)
    if W.Groups[player.group] > 1 then
        return true
    end
    return false
end

W.CreateCallback("ZC-guille_doorlock:cb:getDoors", function(source, cb)
    local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
    doors = json['decode'](doors)
    cb(doors, _doorCache)
end)

RegisterServerEvent("guille_doorlock:server:addDoor", function(_doorCoords, _doorModel, _heading, type, _textCoords, dist, jobs, pin, item)
    local _src <const> = source
    if isAllowed(_src) then
        local usePin = false
        local useitem = false
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        if pin ~= "" then
            usePin = true
        end
        if item ~= "" then
            useitem = true
        end
        doors = json.decode(doors)
        local tableToIns <const> = {
            doorCoords = _doorCoords,
            _doorModel = _doorModel,
            _heading = _heading,
            _type = type,
            _textCoords = _textCoords,
            dist = dist,
            jobs = jobs,
            usePin = usePin,
            pin = pin,
            useitem = useitem,
            item = item
        }
        table['insert'](doors, tableToIns)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json['encode'](doors, { indent = true }), -1)
        TriggerClientEvent("guille_doorlock:client:refreshDoors", -1, tableToIns)
    end
end)

RegisterServerEvent("guille_doorlock:server:addDoubleDoor", function(_doorsDobule, type, _textCoords, dist, jobs, pin)
    local _src <const> = source
    if isAllowed(_src) then
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        local usePin = false
        if pin ~= "" then
            usePin = true
        end
        local tableToIns <const> = {
            _doorsDouble = _doorsDobule,
            _type = type,
            _textCoords = _textCoords,
            dist = dist,
            jobs = jobs,
            usePin = usePin,
            pin = pin,
        }
        table['insert'](doors, tableToIns)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json['encode'](doors, { indent = true }), -1)
        TriggerClientEvent("guille_doorlock:client:refreshDoors", -1, tableToIns)
    end
end)

RegisterServerEvent("guille_doorlock:server:updateDoor", function(id, type)
    _doorCache[id] = type
    TriggerClientEvent("guille_doorlock:client:updateDoorState", -1, id, type)
end)

RegisterServerEvent("guille_doorlock:server:syncRemove", function(id)
    local _src <const> = source
    if isAllowed(_src) then
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        table['remove'](doors, id)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json['encode'](doors, { indent = true }), -1)
        TriggerClientEvent("guille_doorlock:client:removeGlobDoor", -1, id)
    end
end)

RegisterCommand("door", function(source, args)  
    local _src <const> = source
    if isAllowed(_src) then
        TriggerClientEvent("guille_doorlock:client:setUpDoor", _src)
    end 
end, false)

RegisterCommand("deletedoor", function(source, args)  
    local _src <const> = source
    if isAllowed(_src) then
        TriggerClientEvent("guille_doorlock:client:deleteDoor", _src)
    end 
end, false)