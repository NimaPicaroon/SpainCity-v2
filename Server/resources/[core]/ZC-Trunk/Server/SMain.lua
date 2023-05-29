GLOBAL_TRUNKS = {}

W.CreateCallback('ZC-Trunk:isOpened', function(source, callback, plate)
    local src <const> = source
    local plate <const> = plate

    if not src or plate then
        return
    end

    
end)

local openedTrunks = {}

W.CreateCallback("ZC-Trunk:getOwners", function(source, cb, plate)
    if openedTrunks[plate] ~= true then
        cb(true)
        openedTrunks[plate] = true
    else
        cb(false)
    end
end)

RegisterNetEvent('ZC-Trunk:closeTrunk', function (plate)
    local src = source

    openedTrunks[plate] = nil
end)