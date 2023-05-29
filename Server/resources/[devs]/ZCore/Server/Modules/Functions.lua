W.Functions = { }
W.Callbacks = { }
W.Commands = { }
W.Usables = { }
W.CThread = CreateThread
W.Weapons = {
    "WEAPON_PISTOL","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_SMG","weapon_combatshotgun","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_CARBINERIFLE","WEAPON_SPECIALCARBINERIFLE","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_REVOLVER","WEAPON_MARKSMANPISTOL","WEAPON_MACHINEPISTOL","WEAPON_MILITARYRIFLE","WEAPON_VINTAGEPISTOL","WEAPON_COMBATPDW","WEAPON_PISTOL_MK2","WEAPON_SNSPISTOL_MK2","WEAPON_FLAREGUN","WEAPON_STUNGUN","WEAPON_REVOLVER","WEAPON_FLARE","WEAPON_KNIFE","weapon_sawnoffshotgun","WEAPON_MICROSMG","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_MACHINEPISTOL","weapon_carbinerifle","WEAPON_ASSAULTRIFLE_Mk2","weapon_specialcarbinerifle_mk2","weapon_carbinerifle_mk2","weapon_pumpshotgun_mk2","weapon_smg_mk2","weapon_assaultrifle","weapon_specialcarbine","weapon_bullpuprifle","weapon_advancedrifle","weapon_assaultsmg","weapon_smg","weapon_smgmk2","weapon_gusenberg","weapon_sniperrifle","weapon_assaultshotgun","weapon_bullpupshotgun","weapon_pumpshotgun","weapon_heavyshotgun"
}

---comment
---@param cb any
---@return any
W.Thread = function(cb)
    return W.CThread(cb)
end

W.GetItems = function()
    return W.Items
end

---comment
---@param id any
---@param cb any
---@return any
W.GetIdentifier = function(id, cb)
    local license = nil
    for k,v in ipairs(GetPlayerIdentifiers(id))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end
    if license then
        if cb then
            return cb(license)
        else 
            return license
        end
    else
        if cb then
            return cb(false)
        else 
            return false
        end
    end
end

W.GetPlayerIdentifier = function (id, cb)
    local xPlayer = W.GetPlayer(id)
    return xPlayer.identifier
end

---comment
---@param id any
---@param cb any
---@return any
W.GetDiscord = function(id, cb)
    local license = nil
    for k,v in ipairs(GetPlayerIdentifiers(id))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            license = v
        end
    end
    if license then
        if cb then
            return cb(license)
        else 
            return license
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
---@param id any
---@param cb any
---@return any
W.GetSteam = function(id, cb)
    local steam = nil
    for k,v in ipairs(GetPlayerIdentifiers(id))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
        end
    end
    if steam then
        if cb then
            return cb(steam)
        else 
            return steam
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
---@param id any
---@param cb any
---@return any
W.GetPlayer = function(id, cb)
    local player = W.Plys[tonumber(id)]
    
    if player then
        if cb then 
            return cb(player)
        else
            return player
        end
    else
        return nil
    end
end

W.GetPlayerByIdentifier = function(identifier, cb)
    for k,v in pairs(W.Plys) do
        if v.identifier == identifier then
            if cb then
                return cb(W.Plys[k])
            else
                return W.Plys[k]
            end
        end
    end
end

W.GetPlayers = function(cb)
    local player = W.Plys

    if cb then 
        return cb(player)
    else
        return player
    end
end


---comment
---@param identifier any
---@param cb any
W.CheckIfPlayerExists = function(identifier, cb)
    if identifier and W.Players then
        if W.Players[identifier] then
            if cb then
                return cb(W.Players[identifier])
            else
                return W.Players[identifier]
            end
        else
            if cb then
                return cb(false)
            else
                return false
            end
        end
    end
end

W.GetRandomPosition = function()
    local coords = math.random(1, #W.SpawnPositions)

    return W.SpawnPositions[coords]
end

W.GetRandomPhoneNumber = function(source)
    math.randomseed(os.time()) -- Do not touch this

    -- You can change the number format below!
    local number = math.random(11111, 99999)
  
    return number
end

---comment
---@param id any
---@param identifier any
W.CreateNewPlayer = function(id, identifier, newData)
    local coords = W.GetRandomPosition()
    local phone = W.GetRandomPhoneNumber(id)

    if newData.charinfo.gender == 'Male' then
        newData.charinfo.gender = 'H'
    elseif newData.charinfo.gender == 'Female' then
        newData.charinfo.gender = 'M'
    end

    local identity = {
        name = newData.charinfo.name,
        lastname = newData.charinfo.lastname,
        gender = newData.charinfo.gender,
        birthdate = newData.charinfo.birthdate,
        nacionality = newData.charinfo.nacionality
    }

    if id and identifier and coords then
        local name = GetPlayerName(id)
        MySQL.Async.execute("INSERT INTO `players` (`token`, `name`, `discord`, `group`, `inventory`, `coords`, `skills`, `money`, `identity`, `status`, `skin`, `ped`, `job`, `gang`, `dimension`, `dead`, `phone`) VALUES (@token, @name, @discord, @g, @i, @c, @s, @m, @id, @status, @skin, @ped, @job, @gang, @dimension, @dead, @phone)", {
            ['@name']       = name,
            ['@token']      = identifier,
            ['@discord']    = W.GetDiscord(id),
            ['@ped'] = '',
            ['@g']          = "user",
            ['@i']          = json.encode({items = {}, slots = {}, totalWeight = 0}),
            ['@c']          = json.encode(coords),
            ['@s']          = json.encode({ stamina = 0, stress = 0, diving = 0, strength = 0 }),
            ['@m']          = json.encode({ money = 200, bank = 10000, blackmoney = 0, crypto = 0, coins = 0}),
            ['@id']         = json.encode(identity),
            ['@job']         = json.encode({salary = 50, name = 'unemployed', rank = 1, rankname = 'unemployed', ranklabel = 'En paro', label = 'Desempleado', duty = true}),
            ['@gang']         = json.encode({ }),
            ['@status']     = json.encode({ hunger = 100, thirst = 100, stress = 0 }),
            ['@skin'] = json.encode({["moles_2"]=0,["eyebrows_1"]=0,["bracelets_2"]=0,["makeup_4"]=0,["makeup_2"]=0,["mask_2"]=0,["lipstick_1"]=0,["chbbl"]=0,["pants_2"]=0,["decals_1"]=0,["glasses_1"]=0,["blush_3"]=0,["chest_2"]=0,["noset"]=0,["mask_1"]=0,["watches_2"]=0,["tshirt_1"]=0,["decals_2"]=0,["jbw"]=0,["helmet_1"]=-1,["blemishes_1"]=0,["makeup_3"]=0,["beard_3"]=0,["chain_2"]=0,["makeup_1"]=0,["nosebh"]=0,["eyeop"]=0,["blush_1"]=0,["helmet_2"]=0,["blush_2"]=0,["lipstick_4"]=0,["arms_2"]=0,["skin"]=0,["bags_1"]=0,["ears_2"]=0,["neckt"]=0,["lipstick_3"]=0,["complexion_1"]=0,["hair_color_2"]=0,["beard_4"]=0,["eye_color"]=0,["chw"]=0,["blemishes_2"]=0,["beard_1"]=0,["nosel"]=0,["eyebrows_4"]=0,["moles_1"]=0,["age_1"]=0,["tshirt_2"]=0,["eyebf"]=0,["arms"]=0,["bproof_2"]=0,["chho"]=0,["beard_2"]=0,["jbbl"]=0,["bodyb_1"]=0,["chbble"]=0,["torso_1"]=0,["noseh"]=0,["pants_1"]=0,["hair_2"]=0,["hair_color_1"]=0,["nosew"]=0,["bracelets_1"]=-1,["sex"]='mp_m_freemode_01', ["shoes_1"]=0,["chbw"]=0,["lipstick_2"]=0,["chest_3"]=0,["bodyb_2"]=0,["face_2"]=-1,["eyebrows_2"]=0,["chain_1"]=0,["eyebh"]=0,["eyebrows_3"]=0,["sun_1"]=0,["ears_1"]=-1,["cbw"]=0,["hair_1"]=0,["bproof_1"]=0,["bags_2"]=0,["cbh"]=0,["shoes_2"]=0,["torso_2"]=0,["nosepl"]=0,["face"]=0,["lipst"]=0,["chest_1"]=0,["complexion_2"]=0,["age_2"]=0,["sun_2"]=0,["watches_1"]=-1,["glasses_2"] = 0}),
            ['@bills'] = json.encode({ }),
            ['@dimension'] = 0,
            ['@dead'] = 0,
            ['@phone'] = phone
        }, function ()
            W.Plys[tonumber(id)] = W.CreatePlayer(id, name, identifier, W.GetDiscord(id), "user", coords, {items = {}, slots = {}, totalWeight = 0 }, { stamina = 0, stress = 0, diving = 0, strength = 0 }, { money = 200, bank = 10000, blackmoney = 0, crypto = 0, coins = 0 }, identity, { hunger = 100, thirst = 100, stress = 0 }, {["moles_2"]=0,["eyebrows_1"]=0,["bracelets_2"]=0,["makeup_4"]=0,["makeup_2"]=0,["mask_2"]=0,["lipstick_1"]=0,["chbbl"]=0,["pants_2"]=0,["decals_1"]=0,["glasses_1"]=0,["blush_3"]=0,["chest_2"]=0,["noset"]=0,["mask_1"]=0,["watches_2"]=0,["tshirt_1"]=0,["decals_2"]=0,["jbw"]=0,["helmet_1"]=-1,["blemishes_1"]=0,["makeup_3"]=0,["beard_3"]=0,["chain_2"]=0,["makeup_1"]=0,["nosebh"]=0,["eyeop"]=0,["blush_1"]=0,["helmet_2"]=0,["blush_2"]=0,["lipstick_4"]=0,["arms_2"]=0,["skin"]=0,["bags_1"]=0,["ears_2"]=0,["neckt"]=0,["lipstick_3"]=0,["complexion_1"]=0,["hair_color_2"]=0,["beard_4"]=0,["eye_color"]=0,["chw"]=0,["blemishes_2"]=0,["beard_1"]=0,["nosel"]=0,["eyebrows_4"]=0,["moles_1"]=0,["age_1"]=0,["tshirt_2"]=0,["eyebf"]=0,["arms"]=0,["bproof_2"]=0,["chho"]=0,["beard_2"]=0,["jbbl"]=0,["bodyb_1"]=0,["chbble"]=0,["torso_1"]=0,["noseh"]=0,["pants_1"]=0,["hair_2"]=0,["hair_color_1"]=0,["nosew"]=0,["bracelets_1"]=-1,["sex"]='mp_m_freemode_01', ["shoes_1"]=0,["chbw"]=0,["lipstick_2"]=0,["chest_3"]=0,["bodyb_2"]=0,["face_2"]=-1,["eyebrows_2"]=0,["chain_1"]=0,["eyebh"]=0,["eyebrows_3"]=0,["sun_1"]=0,["ears_1"]=-1,["cbw"]=0,["hair_1"]=0,["bproof_1"]=0,["bags_2"]=0,["cbh"]=0,["shoes_2"]=0,["torso_2"]=0,["nosepl"]=0,["face"]=0,["lipst"]=0,["chest_1"]=0,["complexion_2"]=0,["age_2"]=0,["sun_2"]=0,["watches_1"]=-1,["glasses_2"] = 0}, '', {name = 'unemployed', rank = 1, salary = 50, rankname = 'unemployed', ranklabel = 'En paro', label = 'Desempleado', duty = true}, {}, {}, 0, 0, phone, {}, 0, {})
            W.Plys[tonumber(id)].saveCachePlayer() 
            W.Print("INFO", "**NEW** player '"..id.."' loaded into the server.")
            W.TransferOldPermanentMetadata(identifier, name, tonumber(id))
            TriggerClientEvent("core:client:spawnAndCreatePlayer", tonumber(id), coords, nil, true, 0)
        end)
    end
end

W.TransferOldPermanentMetadata = function(identifier, name, id)
    if(not W.Metadata.AllData[identifier])then
        return
    end
    local newData = {}
    if #W.Plys[id].metadata > 0 then
        for k, v in pairs(W.Plys[id].metadata) do
            newData[k] = v
        end
    end
    for k, v in pairs(W.Metadata.AllData[identifier]) do
        if(v.permanent)then
            newData[k] = v
        end
    end
    W.Plys[id].metadata = newData
    W.Metadata.Register(identifier, newData, name, id)
end 

---comment
---@param name any
---@param group any
---@param cb any
W.RegisterCommand = function(name, group, cb, help, arguments)
    if W.Commands[name] ~= nil then
        W.Print("INFO", "Command ^3"..name.."^0 is alredy registered.")
    end

    RegisterCommand(name, function(source, args) 
        local src <const> = source
        if group == "rcon" then
            if src == 0 then
                cb(src, args)
            else
                W.Print("ERROR", "This command must be executed from RCON")
            end
        else
            if src == 0 then
                return W.Print("ERROR", "This command cannot be executed from RCON")
            end
            local ply = W.GetPlayer(src)
            if group == 'user' then
                cb(src, args, ply)
            else
                if W.Groups[ply.group] >= W.Groups[group] then
                    cb(src, args, ply)
                end
            end
        end
    end, false)
    W.Commands[name] = {name = name, help = help, arguments = arguments}
end

---comment
W.SaveAll = function()
    W.Thread(function()
        for k, v in pairs(W.Plys) do
            if v then
                v.savePlayer('all')
                Wait(W.SavePlayerIntervalBetween)
            end
        end
    end)
end

---comment
---@param name any
---@param todo any
W.CreateCallback = function(name, todo)
    --W.Print("INFO", "Registered new callback with name '"..name.."`'")
    W.Callbacks[name] = todo
end

W.HandleCallback = function(name, ...)
    local src <const> = source
    if W.Callbacks[tostring(name)] then
        W.Callbacks[tostring(name)](tonumber(src), function(...)
            TriggerClientEvent("core:client:handleCb", src, name, ...)
        end, ...)
    end
end

RegisterNetEvent("core:server:exCallback", W.HandleCallback)

W.RefreshItems = function()
    MySQL.ready(function()
        local count = 0
        MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
            for k, v in pairs(result) do
                W.Items[v.name] = {name = v.name, label = v.label, weight = v.weight, limit = v.limit, type = v.type}
                GlobalState.Items = W.Items
                count = count + 1
            end
            W.Print("INFO", ("Created %s items"):format(count))
            W.RegisterItems()
            TriggerEvent('ZC-Storage:server:updateItems', W.Items)
        end)
    end)
end

W.RefreshItems()

W.RegItem = function(name, cb)
    if W.Items[name] then
        W.Usables[name] = cb
    else
        W.Print('ERROR', 'El objeto no existe - '.. name)
    end
end

exports('RegisterItem', W.RegItem)

---comment
---@return table
W.GetItems = function ()
    return  W.Items
end

W.IsWeapon = function(name)
    if string.find(string.upper(name), 'WEAPON_') ~= nil or string.find(string.upper(name), 'GADGET_') ~= nil then
        return true
    end

    return false
end

W.IsKey = function(name)
    if string.find(string.upper(name), 'carkey') ~= nil or string.find(string.upper(name), 'house_keys') ~= nil then
        return true
    end

    return false
end

W.RegisterWeapons = function()
    for k,v in pairs(W.Weapons) do
        if W.Items[string.upper(v)] then
            W.RegItem(string.upper(v), function(player)
                player.addWeapon(string.upper(v))
            end)
        end
    end

    return false
end

local function RemoveStress(amount)
    local src = source
    local player = W.GetPlayer(src)

    player.removeStatus('stress', amount)
end

RegisterNetEvent('ZCore:removeStress', RemoveStress)

W.RegisterItems = function()
    local num = 0
    local shots, food = exports.rl_business:getConfig()

    for k,v in pairs(shots) do
        W.RegItem(k, function(player, item)
            player.removeItemFromInventory(k, 1, item.slotId)
            TriggerClientEvent("rl_business:serveProp", player.src, k)
        end)
    end
    
    for k,v in pairs(food) do
        W.RegItem(k, function(player, item)
            player.removeItemFromInventory(k, 1, item.slotId)
            TriggerClientEvent("rl_business:servePropEat", player.src, k)
        end)
    end

    W.RegItem('hifi', function(player, item)
        player.removeItemFromInventory('hifi', 1, item.slotId)
        TriggerClientEvent('myDj:place', player.src)
    end)
    W.RegItem('tunerchip', function(player, item)
        item.metadata = json.decode(item.metadata)

        if item.metadata and (item.metadata == 0) then
            player.removeItemFromInventory('tunerchip', 1, item.slotId)

            return player.Notify('Chip de Tuneo', 'Has gastado todos los usos del nitro', 'verify')
        end

        TriggerClientEvent('qb-tunerchip:client:openChip', player.src)
    end)

    W.RegItem('radio', function(player, item)
        TriggerClientEvent('radio:use', player.src)
    end)

    W.RegItem('pill', function(player, item)
        player.removeItemFromInventory('pill', 1, item.slotId)
        TriggerClientEvent('ZC-Ambulance:usePill', player.src)
    end)
    W.RegItem('pill2', function(player, item)
        player.removeItemFromInventory('pill2', 1, item.slotId)
        TriggerClientEvent('ZC-Ambulance:usePill2', player.src)
        Citizen.Wait(10000)
        player.removeStatus('stress', 20)
    end)
    W.RegItem('anxiolytic', function(player, item)
        player.removeItemFromInventory('anxiolytic', 1, item.slotId)
        TriggerClientEvent('ZC-Ambulance:useAnxiolytic', player.src)
    end)
    W.RegItem('bandage', function(player, item)
        TriggerClientEvent('ZC-Ambulance:useBandage', player.src, item)
    end)
    W.RegItem('carkey', function(player, item)
        item.metadata = json.decode(item.metadata)
        TriggerClientEvent('garage:useKeys', player.src, item.metadata)
    end)
    W.RegItem('sprayremover', function(player, item)
        TriggerClientEvent('rcore_spray:removeClosestSpray', player.src)
    end)    

    W.RegItem('sniper_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('shotgun_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('pistol_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('skorpion_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('uzi_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('boostingtablet', function(player, item)
        TriggerClientEvent("rahe-boosting:client:openTablet", player.src)
        --ExecuteCommand("e tablet2")
    end)

    W.RegItem('racingtablet', function(player, item)
        TriggerClientEvent('rahe-racing:client:openTablet', player.src)
        ExecuteCommand("e tablet2")
    end)

    W.RegItem('boombox', function(player, item)
        TriggerClientEvent('rahe-boombox:client:showMenu', player.src)
    end)

    W.RegItem('heavypistol_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('vintage_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('sns_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('subfusil_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('fusil_clip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useClip', player.src, item)
    end)

    W.RegItem('emptyclip', function(player, item)
        item.metadata = json.decode(item.metadata)

        TriggerClientEvent('inventory:useEmptyclip', player.src, item)
    end)

    W.RegItem('tabaccopack', function(player, item)
        item.metadata = json.decode(item.metadata)

        if item.metadata.cigarretes > 0 then
            TriggerClientEvent('smoke:usePack', player.src, item)
        else
            player.removeItemFromInventory(item.name, 1, item.slotId)
        end
    end)

    W.RegItem('cigarrete', function(player, item)
        local hasLighter = player.getItem('lighter')
        item.metadata = json.decode(item.metadata)

        if hasLighter then
            TriggerClientEvent('smoke:useCigarrete', player.src, item, 'cigarrete')
        else
            player.Notify('Tabaco', 'Necesitas un ~y~mechero~w~ para poder utilizar un ~y~cigarro~w~.', 'error')
        end
    end)

    W.RegItem('joint', function(player, item)
        local hasLighter = player.getItem('lighter')
        item.metadata = json.decode(item.metadata)

        if hasLighter then
            TriggerClientEvent('smoke:useCigarrete', player.src, item, 'joint')
        else
            player.Notify('Tabaco', 'Necesitas un ~y~mechero~w~ para poder utilizar un ~y~porro~w~.', 'error')
        end
    end)

    W.RegItem('bolsa_hermetica', function(player, item)
        local canUse = false
        local msg = ''
        local have, weed = player.getItem('cogollos_marihuana')
        if weed and weed.quantity >= 5 then
            player.removeItemFromInventory('bolsa_hermetica', 1, item.slotId)
            player.removeItemFromInventory('cogollos_marihuana', 5, weed.slotId)
            player.addItemToInventory("bolsa_marihuana", 1, false)
            canUse = true
            msg = "Has puesto x5 cogollos en la bolsa"
        else
          msg = "Necesitas x5 cogollos necesarios"
        end
        TriggerClientEvent('plt_drugs:UseBag', player.src, source, canUse, msg)
      end)

    W.RegItem("semillas", function(player, item)
        TriggerClientEvent('ry-weed:client:useitem', player.src, item.slotId)
    end)

    W.RegItem('bulletproof', function(player, item)
        TriggerClientEvent('ZC-Inventory:bulletproof', player.src)
        player.removeItemFromInventory('bulletproof', 1, item.slotId)
    end)

    W.RegItem('mounted_scope', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'mounted_scope', { name = 'mounted_scope', slotId = item.slotId })
    end)

    W.RegItem('camuflaje', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'camuflaje', { name = 'camuflaje', slotId = item.slotId })
    end)

    W.RegItem('scope', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'scope', { name = 'scope', slotId = item.slotId })
    end)

    W.RegItem('mediumscope', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'mediumscope', { name = 'mediumscope', slotId = item.slotId })
    end)

    W.RegItem('largescope', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'largescope', { name = 'largescope', slotId = item.slotId })
    end)

    W.RegItem('holografik_scope', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'holografik_scope', { name = 'holografik_scope', slotId = item.slotId })
    end)

    W.RegItem('culata', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'culata', { name = 'culata', slotId = item.slotId })
    end)

    W.RegItem('silenciador', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'silenciador', { name = 'silenciador', slotId = item.slotId })
    end)

    W.RegItem('botella_buceo', function(player, item)
        TriggerClientEvent('ZC-Customscripts:ox', player.src)
        player.removeItemFromInventory('botella_buceo', 1, item.slotId)
    end)

    W.RegItem('saco', function(player, item)
        TriggerClientEvent('esx_worek:naloz', player.src)
    end)

    W.RegItem('linterna', function(player, item)
        TriggerClientEvent('inventory:useAttachment', player.src, 'linterna', { name = 'linterna', slotId = item.slotId })
    end)

    W.RegItem('lockpick', function(player, item)
        TriggerClientEvent('hotwire:use', player.src, item.slotId)
        --W.SendToDiscord('lockpick', player.name.. ' ha usado un lockpick', 16711680)
    end)

    W.RegItem('pistol_box', function(player, item)
        player.removeItemFromInventory('pistol_box', 1, item.slotId)
        player.addItemToInventory('pistol_rounds', 250)
    end)

    W.RegItem('shotgun_box', function(player, item)
        player.removeItemFromInventory('shotgun_box', 1, item.slotId)
        player.addItemToInventory('shotgun_rounds', 250)
    end)

    W.RegItem('subfusil_box', function(player, item)
        player.removeItemFromInventory('subfusil_box', 1, item.slotId)
        player.addItemToInventory('subfusil_rounds', 250)
    end)

    W.RegItem('fusil_box', function(player, item)
        player.removeItemFromInventory('fusil_box', 1, item.slotId)
        player.addItemToInventory('fusil_rounds', 250)
    end)

    W.RegItem('sniper_box', function(player, item)
        player.removeItemFromInventory('sniper_box', 1, item.slotId)
        player.addItemToInventory('sniper_rounds', 250)
    end)

    W.RegItem('papeldeliar', function(player, item)
        TriggerClientEvent('smoke:usePaper', player.src, item)
    end)

    W.RegItem('repairkit', function(player, item)
        TriggerClientEvent('inventory:useRepairkit', player.src, item)
    end)

    -- W.RegItem('peluche_gato1', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)
    -- W.RegItem('peluche_gato2', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)

    -- W.RegItem('peluche_gato3', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)

    -- W.RegItem('peluche_gato4', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)

    -- W.RegItem('peluche_gato5', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)

    -- W.RegItem('peluche_gato6', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)

    -- W.RegItem('peluche_chicarosa', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)

    -- W.RegItem('peluche_chicaverde', function(player, item)
    --     ExecuteCommand("e teddy")
    -- end)




    num = num + 27

    MySQL.Async.fetchAll("SELECT * FROM toregister", {}, function(result)
        for k, v in pairs(result) do
            if v.type == 'food' then
                if W.Items[v.name] then
                    W.Food[v.name] = {Label = W.Items[v.name].label, g = v.g, Prop = v.prop, StatusHunger = v.hunger, Pos1 = 0.13, Pos2 = 0.05, Pos3 = 0.02, Pos4 = -50.0, Pos5 = 16.0, Pos6 = 60.0}
                end
            elseif v.type == 'drink' then
                if W.Items[v.name] then
                    W.Drink[v.name] = {CleanUpItem = '', ml = v.mL, Prop = v.prop, StatusDrink = v.thirst, Alcohol = 0.0, Shots = false , Pos1 = 0.0, Pos2 = -0.01, Pos3 = -0.02, Pos4 = 05.0, Pos5 = -10.0, Pos6 = 0.0}
                end
            end
            W.Props[v.name] = v.prop
        end
    end)

    Wait(1000)

    for k,v in pairs(W.Food) do
        if W.Items[k] then
            num = num + 1
            W.RegItem(k, function(player, itemSelect)
                local data = v
                TriggerClientEvent('Ox-Needs:eat', player.src, itemSelect, data, 'food')
                player.removeItemFromInventory(itemSelect.name, 1, itemSelect.slotId)
            end)
        end
    end

    for k,v in pairs(W.Drink) do
        if W.Items[k] then
            num = num + 1

            W.RegItem(k, function(player, itemSelect)
                local data = v
                TriggerClientEvent('Ox-Needs:eat', player.src, itemSelect, data, 'drink')
                player.removeItemFromInventory(itemSelect.name, 1, itemSelect.slotId)
            end)
        end
    end

    TriggerEvent('ZC-Storage:server:updateItems', W.Items)
    TriggerEvent('ZCore:refreshProps', W.Props)
    W.Print("INFO", ("'%s' items registered"):format(num))
    return false
end

W.SlotId = function()
    local id = math.random(1, 99999)

    return id
end

SetTimeout(1000, W.RegisterWeapons)

W.RemoveMetadata = function(item, toRemove)
    local player = W.GetPlayer(source)

    player.updateMetadata(item, toRemove)
    return false
end

RegisterNetEvent("ZCore:removeMetadata", W.RemoveMetadata)

W.Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

W.UpdateCoords = function(coords)
    local src <const> = source
    local ply = W.GetPlayer(src)
    
    if not ply then return end

    ply.coords = coords
end

RegisterNetEvent('core:updateCoords', W.UpdateCoords)

IGNORE_LOCKS = {}

W.ParseString = function(text)    
    if not text then
        return nil
    end
    
    return string.gsub(text, " ", "")
end

W.IgnoreLocks = function(plate)
    if type(plate) ~= 'string' then
        plate = GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(plate))
    end

    local plateParsed = W.ParseString(plate)
    
    if not plateParsed then
        return
    end

    if IGNORE_LOCKS[plateParsed] then
        return
    end

    if not IGNORE_LOCKS[plateParsed] then
        IGNORE_LOCKS[plateParsed] = true
    end

    GlobalState.IgnoreLocks = IGNORE_LOCKS
    --print('^5Lockpick^7 - New ignore locks vehicle has been added (^5'..plate..'^7)')
end

RegisterNetEvent('ZCore:ignoreLocks', W.IgnoreLocks)

W.SetNitroUse = function(slotId)
    local src = source
    local player = W.GetPlayer(src)

    if not player then
        return
    end

    player.updateItemdata('nitroUses', slotId, 1, 'remove')
end

RegisterNetEvent('ZCore:setNitroUse', W.SetNitroUse)