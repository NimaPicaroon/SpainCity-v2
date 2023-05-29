RegisterNetEvent('core:updateStatus', function(status)
    local src = source
    local ply = W.GetPlayer(src)

    if not ply then
        return
    end

    ply.updateStatus(status)
end)

W.RemoveStatus = function(status, amount)
    local src <const> = source
    local ply = W.GetPlayer(src)

    if not ply then
        return
    end

    if not ply.status[status] then
        return
    end

    if ply.status[status] <= 0 then
        ply.status[status] = 0
    else
        ply.status[status] = ply.status[status] - tonumber(amount)
    end

    ply.updateStatus(ply.status)
end

RegisterNetEvent('core:server:removeStatus', W.RemoveStatus)

W.ResetStatus = function (id)
    if not id then
        local src <const> = source
        local player = W.GetPlayer(src)
        local status = { hunger = 100, thirst = 100, stress = 0 }
        player.updateStatus(status)
    else
        local player = W.GetPlayer(id)
        local status = { hunger = 100, thirst = 100, stress = 0 }
        player.updateStatus(status)
    end
end

RegisterNetEvent("core:server:statusRef", W.ResetStatus)

W.CreateItem = function(options)
    local xPlayer = W.GetPlayer(source)

    if options.selthirst == '❌' then
        options.selthirst = 'nothing'
        options.thirst = 0
    end

    if options.selhunger == '❌' then
        options.selhunger = 'nothing'
        options.hunger = 0
    end

    if options.selstress == '❌' then
        options.selstress = 'nothing'
        options.stress = 0
    end

    if options.seldrunk == '❌' then
        options.seldrunk = 'nothing'
        options.drunk = 0
    end

    if options.metadata == '❌' then
        options.metadata = 0
    end

    if options.metadata2 == '❌' then
        options.metadata2 = 0
    end

    MySQL.Async.execute("INSERT INTO items (`name`, `label`, `weight`, `limit`, `type`) VALUES (@name, @label, @weight, @limit, @type)",
    {
        ['@name'] = options.name,
        ['@label'] = options.label,
        ['@limit'] = options.limit,
        ['@type'] = options.type,
        ['@weight'] = 0.1
    })
    Wait(500)
    MySQL.Async.execute("INSERT INTO toregister (`name`, `thirst`, `hunger`, `stress`, `drunk`, `selthirst`, `selhunger`, `selstress`, `seldrunk`, `type`, `prop`, `mL`, `g`) VALUES (@name, @thirst, @hunger, @stress, @drunk, @selthirst, @selhunger, @selstress, @seldrunk, @type, @prop, @mL, @g)",
    {
        ['@name'] = options.name,
        ['@thirst'] = options.thirst,
        ['@hunger'] = options.hunger,
        ['@stress'] = options.stress,
        ['@drunk'] = options.drunk,
        ['@selthirst'] = options.selthirst,
        ['@selhunger'] = options.selhunger,
        ['@selstress'] = options.selstress,
        ['@seldrunk'] = options.seldrunk,
        ['@mL'] = tonumber(options.metadata),
        ['@g'] = tonumber(options.metadata2),
        ['@type'] = options.toeattodrink,
        ['@prop'] = options.prop
    })

    Wait(2500)
    W.RefreshItems()
    xPlayer.Notify("CREADOR", 'Has creado el item correctamente', 'verify')
end

RegisterNetEvent("ZCore:createItem", W.CreateItem)