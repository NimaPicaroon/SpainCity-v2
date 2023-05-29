JOB.Callbacks = { }
JOB.Variables = {
    IsOpen = false,
    PlayerId = GetPlayerServerId(PlayerId()),
    IsChanging = false,
    OwnJob = nil,
    Handcuff = false,
    IsDragging = false,
}

JOB.OpenUi = function()
    SendNUIMessage({ type = "open" })
    JOB.RefreshData()
    SetNuiFocus(true, true)
    JOB.Variables['IsOpen'] = true
end

RegisterNetEvent("jobcreatorv2:client:openUi", JOB.OpenUi)

RegisterNUICallback("createJob", function(data, cb)
    W.Notify('Jobcreator', 'Has creado un nuevo job!', 'verify')
    TriggerServerEvent("jobcreatorv2:server:sendNewJobData", data.data)

    cb(json.encode("Hey!"))
end)

RegisterNetEvent("jobcreatorv2:client:initData", JOB.HandleAll)

JOB.Markers = {
    pressed = false,

    ---comment
    ---@param coords any
    ['armory'] = function (coords)
        if JOB.Variables.OwnJob.duty then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Armario\n~w~Abrir armario', 0.5, 8)
            if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                JOB.Markers.pressed = true
                JOB.OpenArmory(false)

                Citizen.SetTimeout(1000, function()
                    JOB.Markers.pressed = false
                end)
            end
        end
    end,
    ['duty'] = function(coords)
        W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Servicio\n~w~Entrar/Salir de servicio', 0.5, 8)
        if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
            JOB.Markers.pressed = true
            JOB.Duty()

            Citizen.SetTimeout(1000, function()
                JOB.Markers.pressed = false
            end)
        end
    end,
    ---comment
    ---@param coords any
    ['getheli'] = function (coords)
        if JOB.Variables.OwnJob.duty then
            if IsPedInAnyVehicle(PlayerPedId()) then
                W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~g~Garaje\n~w~Guardar helicóptero', 0.8, 8)

                if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                    JOB.Markers.pressed = true
                    DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
        
                    Citizen.SetTimeout(1000, function()
                        JOB.Markers.pressed = false
                    end)
                end
            else
                W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~g~Garaje\n~w~Sacar helicóptero', 0.8, 8)
                if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                    JOB.Markers.pressed = true

                    local OwnData = W.GetPlayerData()
                    local JobData = GlobalState[OwnData.job.name.."-guille"]
                    
                    local VehData = {}
                    for k, v in pairs(JobData['publicvehicles']) do
                        if GetVehicleClassFromName(GetHashKey(v)) == 15 then
                            table.insert(VehData, {label = JOB.FirstToUpper(v), value = v})
                        end
                    end
                    if #VehData == 0 then
                        return W.Notify('ERROR', "No hay helicópteros", 'error')
                    end
                    JOB.OpenMenu("Helicópteros", "vehs_menu", VehData, function (data, name)
                        local v = data.value
                        JOB.SpawnVehicle(v)
                        W.DestroyMenu(name)
                    end)

                    Citizen.SetTimeout(1000, function()
                        JOB.Markers.pressed = false
                    end)
                end
            end
        end
    end,
    ---comment
    ---@param coords any
    ['getvehs'] = function (coords)
        if JOB.Variables.OwnJob.duty then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~g~Garaje\n~w~Ver vehículos', 0.8, 8)
            if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                local vehiclesNames = {}

                JOB.Markers.pressed = true

                local OwnData = W.GetPlayerData()
                local JobData = GlobalState[OwnData.job.name.."-guille"]
                
                local VehData = {}
                for k, v in pairs(JobData['publicvehicles']) do
                    if GetVehicleClassFromName(GetHashKey(v)) ~= 15 then
                        local label = GetLabelText(GetDisplayNameFromVehicleModel(v))

                        if OwnData.job.name == 'police' then
                            if label == 'NULL' then
                                if Cfg.Vehicles['police'][v] then
                                    label = Cfg.Vehicles['police'][v].label
                                else
                                    label = v
                                end
                            end
                        else
                            if label == 'NULL' then
                                label = v
                            end
                        end

                        table.insert(VehData, {label = label, value = v})
                    end
                end

                if #VehData == 0 then
                    return W.Notify('ERROR', "No tienes vehículos", 'error')
                end
                JOB.OpenMenu("Vehículos", "vehs_menu", VehData, function (data, name)
                    local v = data.value
                    JOB.SpawnVehicle(v)
                    W.DestroyMenu(name)
                end)

                Citizen.SetTimeout(1000, function()
                    JOB.Markers.pressed = false
                end)
            end
        end
    end,
    ---comment
    ---@param coords any
    ['savevehs'] = function (coords)
        if JOB.Variables.OwnJob.duty then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1.2), '~r~Garaje\n~w~Guardar vehículos', 0.8, 8)
            if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                JOB.Markers.pressed = true
                CreateThread(function ()
                    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                    TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                    Wait(2000)
                    DeleteVehicle(Vehicle)
                end)
        
                Citizen.SetTimeout(1000, function()
                    JOB.Markers.pressed = false
                end)
            end
        end
    end,
    ---comment
    ---@param coords any
    ['boss'] = function (coords, isBoss)
        if JOB.Variables.OwnJob.duty then
            if isBoss then
                W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Jefe\n~w~Opciones de jefe', 0.5, 8)
                if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                    JOB.Markers.pressed = true
                    if isBoss then
                        JOB.BossMenu()
                    end
            
                    Citizen.SetTimeout(1000, function()
                        JOB.Markers.pressed = false
                    end)
                end
            end
        end
    end,
    ---comment
    ---@param coords any
    ['shop'] = function (coords, isBoss)
        if JOB.Variables.OwnJob.duty then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Tienda\n~w~Ver la tienda', 0.5, 8)
            if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                JOB.Markers.pressed = true

                if isBoss then
                    local OwnData = W.GetPlayerData()
                    local JobData = GlobalState[OwnData.job.name.."-guille"]

                    local ShopData = {}
                    for k, v in pairs(JobData['shop']) do
                        table.insert(ShopData, {label = GlobalState.Items[v[1]].label..' - $'..v[2]..'', name = v[1], price = tonumber(v[2])})
                    end
                    if #ShopData == 0 then
                        return W.Notify('ERROR', "No tienes objetos que comprar", 'error')
                    end
                    JOB.OpenMenu("Tienda", "shop_menu", ShopData, function (data, name)
                        W.DestroyMenu(name)
                        W.OpenDialog('Cantidad a comprar', 'qssss', function(quantity)
                            W.CloseDialog()
            
                            if tonumber(quantity) and tonumber(quantity) > 0 then
                                TriggerServerEvent("jobcreatorv2:server:buyItem", data.name, data.price, quantity, JOB.Variables.OwnJob.name)
                            else
                                W.Notify('ERROR', 'Introduce una cantidad válida', 'error')
                            end
                        end)
                    end)
                else
                    W.Notify('ERROR', '~r~No eres jefe para poder utilizar esto.', 'error')
                end
        
                Citizen.SetTimeout(1000, function()
                    JOB.Markers.pressed = false
                end)
            end
        end
    end,

    ['wardrobe'] = function (coords)
        if JOB.Variables.OwnJob.duty then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Vestuario\n~w~Ver conjuntos', 0.5, 8)
            if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                JOB.Markers.pressed = true
                
                JOB.OpenWardrobe(JOB.Variables.OwnJob)
        
                Citizen.SetTimeout(1000, function()
                    JOB.Markers.pressed = false
                end)
            end
        end
    end,

    ['clothing'] = function (coords)
        if JOB.Variables.OwnJob.duty then
            W.ShowText(vector3(coords.x, coords.y, coords.z + 1), '~y~Vestuario\n~w~Cambiar accesorios', 0.5, 8)
            if IsControlJustPressed(1, 38) and not JOB.Markers.pressed then
                JOB.Markers.pressed = true
                
                TriggerEvent('ZC-Character:openMenu', 'clothes')
        
                Citizen.SetTimeout(1000, function()
                    JOB.Markers.pressed = false
                end)
            end
        end
    end,
}

---comment
---@param str string
---@return string
JOB.FirstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

---comment
---@param vehicle any
JOB.SpawnVehicle = function (vehicle)
    local veh = GetHashKey(vehicle)
    if not HasModelLoaded(veh) and IsModelInCdimage(veh) then
		RequestModel(veh)

		while not HasModelLoaded(veh) do
			Wait(4)
		end
	end
	local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))
	Networked = Networked == nil and true or Networked
	CreateThread(function()
		local vehicle = CreateVehicle(model, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), Networked, false)

		if Networked then
			local id = NetworkGetNetworkIdFromEntity(vehicle)
			SetNetworkIdCanMigrate(id, true)
			SetEntityAsMissionEntity(vehicle, true, false)
		end

        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
        SetVehicleExtraColours(vehicle, 0, 0)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        exports['LegacyFuel']:SetFuel(vehicle, 100.0)
        TriggerServerEvent('ZCore:ignoreLocks', GetVehicleNumberPlateText(vehicle))
	end)
end

-- Boss Functions

JOB.BossMenu = function()
    local elements = {
        { label = 'Administrar dinero', value = 'money' },
        { label = 'Despedir empleados', value = "despedir"}
    }

    if JOB.Variables.OwnJob.name == "ambulance" or JOB.Variables.OwnJob.name == "police" then
        table.insert(elements, { label = 'Administrar armario del jefe', value = 'bossstorage', job = JOB.Variables.OwnJob.name })
    end

    JOB.OpenMenu('Administrar tu Empresa', 'boss_menu', elements, function(data, name)
        W.DestroyMenu(name)
        Wait(200)

        if data.value == 'money' then
            JOB.BossMoneyMenu()
        elseif data.value == "despedir" then
            JOB.BossMoneyMenuDespeir()
        elseif data.value == 'bossstorage' then
            JOB.BossArmory(data.job)
        end
    end)
end

GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. (',')):reverse())..right
end
JOB.BossMoneyMenuDespeir = function()
    local elements = {}
    W.TriggerCallback('carloslr:getempleo', function(outfits)
        if outfits == false then
            table.insert(elements, {label = "No hay empleados.", value = 0, job = "sin job"})
        else
            for k , v in pairs(outfits) do
                local identity = json.decode(v.identity)
                table.insert(elements, {label = identity.name .. ' ' .. identity.lastname, value = v.token, job = v.job})
            end
        end
        JOB.OpenMenu('Despedir Empleados', 'money_boss_menu_oip', elements, function(data, name)
            W.DestroyMenu(name)
            Wait(200)
    
            local elemensts = {
                {label = 'Si', value = 'yes'},
                {label = 'No', value = 'no'}
            }
    
            JOB.OpenMenu('¿Estas seguro?', 'money_boss_menu_despedir', elemensts, function(data2, name2)
                W.DestroyMenu(name2)
                Wait(200)
                if data2.value == 'yes' then
                    if data.value ~= 0 then
                        W.TriggerCallback('carloslr:despedir', function(bool)
                            if bool then
                                W.Notify('Despedir', 'Has despedido a este empleado', 'success')
                            else
                                W.Notify('Despedir', 'No se ha podido despedir a este empleado', 'error')
                            end
                         end, data.value)
                    end
                else
                    W.Notify('Despedir', 'Has cancelado la despedida', 'error')
                end
            end)
        end)
    end, JOB.Variables.OwnJob.name)
end

JOB.BossMoneyMenu = function()
    JOB.OpenMenu('Administrar dinero', 'money_boss_menu', {
        { label = 'Balance: <span style="color:yellow;">$'..GroupDigits(GlobalState[JOB.Variables.OwnJob.name.."-guille"].money)..'</span>', value = 'balance'},
        { label = 'Depositar dinero', value = 'deposit_money' },
        { label = 'Retirar dinero', value = 'withdraw_money' },
    }, function(data, name)
        W.DestroyMenu(name)
        Wait(200)

        if data.value == 'deposit_money' then
            W.OpenDialog('Cantidad a depositar', 'quantity_deposit_boss_menu', function(quantity)
                W.CloseDialog()

                if tonumber(quantity) and tonumber(quantity) > 0 then
                    TriggerServerEvent('Ox-Jobcreator:deposit', quantity, JOB.Variables.OwnJob.name)
                else
                    W.Notify('ERROR', 'Introduce una cantidad válida', 'error')
                end
            end)
        elseif data.value == 'withdraw_money' then
            W.OpenDialog('Cantidad a retirar', 'quantity_deposit_boss_menu', function(quantity)
                W.CloseDialog()

                if tonumber(quantity) and tonumber(quantity) > 0 then
                    TriggerServerEvent('Ox-Jobcreator:withdraw', quantity, JOB.Variables.OwnJob.name)
                else
                    W.Notify('ERROR', 'Introduce una cantidad válida', 'error')
                end
            end)
        end
    end)
end

-- Wardrobe Functions

JOB.BossArmory = function(job)
    JOB.OpenMenu('Taquilla del Jefe', 'police_boss_armory', {
        { label = 'Depositar items', value = 'deposit_items' },
        { label = 'Retirar items', value = 'withdraw_items' }
    }, function(data, menu)
        W.DestroyMenu(menu)
        Wait(200)

        if data.value == 'deposit_items' then
            local items = {}
            local inventory = W.GetItemsForInventory()['data']

            for k, v in pairs(inventory) do
                if type(json.decode(v.metadata)) == 'table' then
                    local tables = {}

                    for info, value in pairs(json.decode(v.metadata)) do
                        table.insert(tables, {
                            label = W.Metadata[info],
                            value = value
                        })
                    end
                    table.insert(items, {label = '['..v.quantity..'] '..v.label, type = GlobalState.Items[v.name].type, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                else
                    table.insert(items, {label = '['..v.quantity..'] '..v.label, type = GlobalState.Items[v.name].type, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
                end
            end
            Wait(200)

            JOB.OpenMenu('Tu inventario', "inventory_menu", items, function (data2, name2)
                W.DestroyMenu(name2)
                local ped = PlayerPedId()

                if data2.quantity > 1 then
                    W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                        W.CloseDialog()
                        amount = tonumber(amount)
                        if amount and amount <= data2.quantity then
                            TriggerServerEvent('storage:store', { name = job.."-boss-storage", data = data2, amount = amount, defaultWeight = 1000, house = true })
                            SetCurrentPedWeapon(ped, -1569615261, true)
                            Wait(500)
                            JOB.BossArmory(job)
                        end
                    end)
                else
                    TriggerServerEvent('storage:store', { name = job.."-boss-storage", data = data2, amount = 1, defaultWeight = 1000, house = true })
                    SetCurrentPedWeapon(ped, -1569615261, true)
                    Wait(500)
                    JOB.BossArmory(job)
                end
            end)
        elseif data.value == 'withdraw_items' then
            W.TriggerCallback('storage:get', function(inventory)
                local items = {}
                for kk, item in pairs(inventory) do
                    if type(item.metadata) == 'string' then
                        item.metadata = json.decode(item.metadata)
                    end

                    if type(item.metadata) == 'table' then
                        local tables = {}
                        for k,v in pairs(item.metadata) do
                            table.insert(tables, {
                                label = W.Metadata[k],
                                value = v
                            })
                        end

                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                    else
                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                    end
                end
                Wait(200)
                JOB.OpenMenu('Armario', "storage_menu", items, function (data2, name2)
                    W.DestroyMenu(name2)
                    if data2.quantity > 1 then
                        W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                            W.CloseDialog()
                            amount = tonumber(amount)
                            if amount and amount <= data2.quantity then
                                TriggerServerEvent('storage:withdraw', { name = job.."-boss-storage", data = data2, amount = amount, defaultWeight = 1000, house = true })
                                Wait(500)
                                JOB.BossArmory(job)
                            end
                        end)
                    else
                        TriggerServerEvent('storage:withdraw', { name = job.."-boss-storage", data = data2, amount = 1, defaultWeight = 1000, house = true })
                        Wait(500)
                        JOB.BossArmory(job)
                    end
                end)
            end, job.."-boss-storage", 1000.0)
        end
    end)
end

JOB.PersonalArmory = function()
    local OwnData = W.GetPlayerData()

    JOB.OpenMenu('Taquilla Personal', 'police_personal_armory', {
        { label = 'Depositar items', value = 'deposit_items' },
        { label = 'Retirar items', value = 'withdraw_items' }
    }, function(data, menu)
        W.DestroyMenu(menu)
        Wait(200)

        if data.value == 'deposit_items' then
            local items = {}
            local inventory = W.GetItemsForInventory()['data']

            for k, v in pairs(inventory) do
                if type(json.decode(v.metadata)) == 'table' then
                    local tables = {}

                    for info, value in pairs(json.decode(v.metadata)) do
                        table.insert(tables, {
                            label = W.Metadata[info],
                            value = value
                        })
                    end
                    table.insert(items, {label = '['..v.quantity..'] '..v.label, type = GlobalState.Items[v.name].type, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                else
                    table.insert(items, {label = '['..v.quantity..'] '..v.label, type = GlobalState.Items[v.name].type, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
                end
            end
            Wait(200)

            JOB.OpenMenu('Tu inventario', "inventory_menu", items, function (data2, name2)
                W.DestroyMenu(name2)
                local ped = PlayerPedId()

                data2.quantity = tonumber(data2.quantity)
                if tonumber(data2.quantity) > 1 then
                    W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                        W.CloseDialog()
                        amount = tonumber(amount)
                        if amount and amount <= data2.quantity then
                            TriggerServerEvent('storage:store', { name = 'police-'..OwnData.identifier, data = data2, amount = amount, defaultWeight = 1000, house = true })
                            SetCurrentPedWeapon(ped, -1569615261, true)
                            Wait(500)
                            JOB.PersonalArmory()
                        end
                    end)
                else
                    TriggerServerEvent('storage:store', { name = 'police-'..OwnData.identifier, data = data2, amount = 1, defaultWeight = 1000, house = true })
                    SetCurrentPedWeapon(ped, -1569615261, true)
                    Wait(500)
                    JOB.PersonalArmory()
                end
            end)
        elseif data.value == 'withdraw_items' then
            W.TriggerCallback('storage:get', function(inventory)
                local items = {}
                for kk, item in pairs(inventory) do
                    if type(item.metadata) == 'string' then
                        item.metadata = json.decode(item.metadata)
                    end

                    if type(item.metadata) == 'table' then
                        local tables = {}
                        for k,v in pairs(item.metadata) do
                            table.insert(tables, {
                                label = W.Metadata[k],
                                value = v
                            })
                        end

                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                    else
                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                    end
                end
                Wait(200)
                JOB.OpenMenu('Armario', "storage_menu", items, function (data2, name2)
                    W.DestroyMenu(name2)
                    if data2.quantity > 1 then
                        W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                            W.CloseDialog()
                            amount = tonumber(amount)
                            if amount and amount <= data2.quantity then
                                TriggerServerEvent('storage:withdraw', { name = 'police-'..OwnData.identifier, data = data2, amount = amount, defaultWeight = 1000, house = true })
                                Wait(500)
                                JOB.PersonalArmory()
                            end
                        end)
                    else
                        TriggerServerEvent('storage:withdraw', { name = 'police-'..OwnData.identifier, data = data2, amount = 1, defaultWeight = 1000, house = true })
                        Wait(500)
                        JOB.PersonalArmory()
                    end
                end)
            end, 'police-'..OwnData.identifier, 1000.0)
        end
    end)
end

JOB.OpenWardrobe = function ()
    local OwnData = W.GetPlayerData()

    local elements = {}
    table.insert(elements, { label = "Mis conjuntos", value = "my" })
    table.insert(elements, { label = "Conjuntos ", value = "own" })

    if OwnData.job.name == 'police' or OwnData.job.name == 'ambulance' then
        --table.insert(elements, { label = "EUP", value = "eup" })
        table.insert(elements, { label = 'Taquilla Personal', value = 'personalarmory' })
    end

    if OwnData.job.name == 'police' then
        table.insert(elements, { label = "Chalecos", value = "vest" })
    end

    if isBoss then
        table.insert(elements, { label = "Asignar conjunto", value = "asign" })
        table.insert(elements, { label = "Eliminar conjunto", value = "delete" })
    end
    JOB.OpenMenu("Vestuario", "wardrobe_menu", elements, function (data, menu)
        local v = data.value
        W.DestroyMenu(menu)
        Wait(200)
        if v == 'my' then
            W.TriggerCallback('ZC-Character:getOutfits', function(outfits)
                if outfits and #outfits > 0 then
                    local el = {}
                    for k,v in pairs(outfits) do
                        table.insert(el, {
                            label = v.name,
                            name = v.name,
                            skin = v.skin
                        })
                    end

                    JOB.OpenMenu('Tu vestuario', "outf_menu", el, function (data, name)
                        W.DestroyMenu(name)
                        TriggerEvent("ZC-Character:loadSkin", data.skin, true)
                    end)
                else
                    W.Notify('ERROR', 'No tienes ningún conjunto guardado', 'error')
                end
            end)
        elseif v == 'personalarmory' then
            JOB.PersonalArmory()
        elseif v == 'vest' then
            SetPedArmour(PlayerPedId(), 200)
        elseif v == 'own' then
            W.TriggerCallback('jobcreatorv2:server:getOutfits', function(outfits)
                if outfits and #outfits > 0 then
                    local el = {}
                    for k,v in pairs(outfits) do
                        table.insert(el, {
                            label = v.name,
                            name = v.name,
                            skin = json.decode(v.skin)
                        })
                    end

                    JOB.OpenMenu('Vestuario', "outf2_menu", el, function (data, name)
                        W.DestroyMenu(name)
                        TriggerEvent("ZC-Character:loadSkin", data.skin, true)
                    end)
                else
                    W.Notify('ERROR', 'No hay ningún conjunto asignado', 'error')
                end
            end, JOB.Variables.OwnJob.name)
        elseif v == 'eup' then
            TriggerEvent('eup:open', GetEntityCoords(PlayerPedId()))
        elseif v == 'delete' then
            W.TriggerCallback('jobcreatorv2:server:getOutfits', function(outfits)
                if outfits and #outfits > 0 then
                    local el = {}
                    for k,v in pairs(outfits) do
                        table.insert(el, {
                            label = v.name,
                            name = v.name,
                            skin = v.skin
                        })
                    end

                    JOB.OpenMenu('Vestuario', "outfdel_menu", el, function (data, name)
                        W.DestroyMenu(name)
                        TriggerServerEvent("jobcreatorv2:server:deleteOutfit", data, OwnData.job.name)
                        W.Notify('VESTUARIO', 'Has eliminado el conjunto con el nombre de ~y~'..data.name, 'verify')
                    end)
                else
                    W.Notify('ERROR', 'No hay ningún conjunto asignado', 'error')
                end
            end, JOB.Variables.OwnJob.name)
        elseif v == 'asign' then
            W.OpenDialog("Nombre del conjunto", "dia_outf", function(name)
                W.CloseDialog()
                if name and name ~= '' then
                    TriggerEvent("ZC-Character:asignOutfit", OwnData.job.name, name)
                    W.Notify('VESTUARIO', 'Has asignado tu conjunto con el nombre de ~y~'..name, 'verify')
                else
                    W.Notify('ERROR', 'Introduce un nombre', 'error')
                end
            end)
        end
    end)
end

-- Duty functions

JOB.Duty = function()
    JOB.Variables.OwnJob.duty = not JOB.Variables.OwnJob.duty

    if JOB.Variables.OwnJob.duty then
        W.Notify('TRABAJO', 'Has ~g~entrado~w~ de servicio', 'info')
    else
        W.Notify('TRABAJO', 'Has ~r~salido~w~ de servicio', 'info')
    end

    TriggerServerEvent('Ox-Jobcreator:setDuty', JOB.Variables.OwnJob.duty)
end

---Stash functions

JOB.OpenArmory = function(isTrash)
    local initElements = {}

    table.insert(initElements, { label = 'Administrar dinero', value = 'admin_blackmoney' })
    table.insert(initElements, { label = 'Administrar items', value = 'admin_items' })
    table.insert(initElements, { label = 'Administrar armas', value = 'admin_weapons' })
    JOB.OpenMenu('Inventario', 'job_armory_jobcreator', initElements, function(data, menu)
        W.DestroyMenu(menu)
        Wait(200)

        if data.value == 'admin_items' then
            local elements = {}
            table.insert(elements, { label = 'Depositar items', value = 'deposit_items' })
            if(not isTrash)then
                table.insert(elements, { label = 'Retirar items', value = 'withdraw_items' })
            end
            JOB.OpenMenu('Administrar items', 'job_armory_admin_items', elements, function(data, menu)
                W.DestroyMenu(menu)
                Wait(200)

                if data.value == 'deposit_items' then
                    local items = {}
                    local inventory = W.GetItemsForInventory()['data']

                    for k, v in pairs(inventory) do
                        if GlobalState.Items[v.name].type ~= 'weapon' then
                            if type(v.metadata) == 'string' and type(json.decode(v.metadata)) == 'table' then
                                local tables = {}

                                for info, value in pairs(json.decode(v.metadata)) do
                                    if W.Metadata[info] then
                                        table.insert(tables, {
                                            label = W.Metadata[info],
                                            value = value
                                        })
                                    end
                                end
                                table.insert(items, {label = '['..v.quantity..'] '..v.label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                            else
                                if type(v.metadata) == 'table' then
                                    local tables = {}
                                    for k,v in pairs(v.metadata) do
                                        if W.Metadata[k] then
                                            table.insert(tables, {
                                                label = W.Metadata[k],
                                                value = v
                                            })
                                        end
                                    end
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                                else
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
                                end
                            end
                        end
                    end
                    Wait(200)

                    JOB.OpenMenu('Tu inventario', "inventory_menu", items, function (data, name)
                        W.DestroyMenu(name)

                        local ped = PlayerPedId()
                        if tonumber(data.quantity) > 1 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()
                                amount = tonumber(amount)
                                if amount and amount <= tonumber(data.quantity) then
                                    SetCurrentPedWeapon(ped, -1569615261, true)
                                    if(not isTrash)then
                                        TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true })
                                    else
                                        TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = tonumber(amount)})
                                    end
                                    Wait(500)
                                    JOB.OpenArmory(isTrash or false)
                                end
                            end)
                        else
                            SetCurrentPedWeapon(ped, -1569615261, true)
                            if(not isTrash)then
                                TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = 1, house = true })
                            else
                                TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = tonumber(1)})
                            end
                            Wait(500)
                            JOB.OpenArmory(isTrash or false)
                        end
                    end)
                elseif data.value == 'withdraw_items' then
                    W.TriggerCallback('storage:get', function(inventory)
                        if inventory then
                            local items = {}
                            for kk, item in pairs(inventory) do
                                if GlobalState.Items[item.item].type ~= 'weapon' then
                                    if type(item.metadata) == 'string' and type(json.decode(item.metadata)) == 'table' then
                                        local tables = {}
                                        for k,v in pairs(json.decode(item.metadata)) do
                                            if W.Metadata[k] then
                                                table.insert(tables, {
                                                    label = W.Metadata[k],
                                                    value = v
                                                })
                                            end
                                        end
                                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                    else
                                        if type(item.metadata) == 'table' then
                                            local tables = {}
                                            for k,v in pairs(item.metadata) do
                                                if W.Metadata[k] then
                                                    table.insert(tables, {
                                                        label = W.Metadata[k],
                                                        value = v
                                                    })
                                                end
                                            end
                                            table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                        else
                                            table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                                        end
                                    end
                                end
                            end
                            Wait(200)
                            JOB.OpenMenu('Armario', "storage_menu", items, function (data, name)
                                W.DestroyMenu(name)
                                if tonumber(data.quantity) > 1 then
                                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                        W.CloseDialog()

                                        amount = tonumber(amount)
                                        if amount and amount <= tonumber(data.quantity) then
                                            TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true})
                                            Wait(500)
                                            JOB.OpenArmory(isTrash or false)
                                        end
                                    end)
                                else
                                    TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = 1, house = true })
                                    Wait(500)
                                    JOB.OpenArmory(isTrash or false)
                                end
                            end)
                        end
                    end, JOB.Variables.OwnJob.name)
                end
            end)
        elseif data.value == 'admin_blackmoney' then
            JOB.OpenMenu('Administrar dinero', 'admin_blackmoney', {
                { label = 'Balance <span style="color: green">($'..GlobalState[JOB.Variables.OwnJob.name.."-guille"].blackmoney..')</span>', value = 'none' },
                { label = 'Depositar dinero', value = 'deposit_money' }
                --{ label = 'Retirar dinero', value = 'withdraw_money' }
            }, function(data, menu)
                W.DestroyMenu(menu)
                Wait(200)

                if data.value == 'deposit_money' then
                    W.TriggerCallback('jobcreator:getPlayerBlackmoney', function(blackMoney)
                        if blackMoney > 0 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()
                                amount = tonumber(amount)
                                if amount and amount <= blackMoney then
                                    TriggerServerEvent('jobcreator:blackmoneyAction', 'deposit', amount, JOB.Variables.OwnJob.name)
                                    Wait(500)
                                    JOB.OpenArmory(false)
                                else
                                    W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no tienes ~r~suficiente~w~.', 'error')
                                end
                            end)
                        else
                            W.Notify('Almacenamiento', 'No tienes ~r~dinero negro~w~ que depositar.', 'error')
                        end
                    end)
                elseif data.value == 'withdraw_money' then
                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                        W.CloseDialog()

                        amount = tonumber(amount)
                        if amount and amount <= GlobalState[JOB.Variables.OwnJob.name.."-guille"].blackmoney then
                            TriggerServerEvent('jobcreator:blackmoneyAction', 'withdraw', amount, JOB.Variables.OwnJob.name)
                            Wait(500)
                            JOB.OpenArmory(false)
                        else
                            W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no hay ~r~suficiente~w~ depositado.', 'error')
                        end
                    end)
                end
            end)
        elseif data.value == 'admin_weapons' then
            local elements = {}
            table.insert(elements, { label = 'Depositar armas', value = 'deposit_weapons' })
            if(not isTrash)then
                table.insert(elements, { label = 'Retirar armas', value = 'withdraw_weapons' })
            end
            JOB.OpenMenu('Administrar armas', 'job_armory_admin_weapons', elements, function(data, menu)
                W.DestroyMenu(menu)
                Wait(200)

                if data.value == 'deposit_weapons' then
                    local items = {}
                    local inventory = W.GetItemsForInventory()['data']

                    for k, v in pairs(inventory) do
                        if GlobalState.Items[v.name].type == 'weapon' then
                            if type(v.metadata) == 'string' and type(json.decode(v.metadata)) == 'table' then
                                local tables = {}

                                for info, value in pairs(json.decode(v.metadata)) do
                                    if W.Metadata[info] then
                                        table.insert(tables, {
                                            label = W.Metadata[info],
                                            value = value
                                        })
                                    end
                                end
                                table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                            else
                                if type(v.metadata) == 'table' then
                                    local tables = {}
                                    for k,v in pairs(v.metadata) do
                                        if W.Metadata[k] then
                                            table.insert(tables, {
                                                label = W.Metadata[k],
                                                value = v
                                            })
                                        end
                                    end
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
                                else
                                    table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
                                end
                            end
                        end
                    end
                    Wait(200)

                    JOB.OpenMenu('Tu inventario', "inventory_menu", items, function (data, name)
                        W.DestroyMenu(name)

                        local ped = PlayerPedId()

                        if tonumber(data.quantity) > 1 then
                            W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
                                W.CloseDialog()

                                amount = tonumber(amount)
                                if amount and amount <= tonumber(data.quantity) then
                                    SetCurrentPedWeapon(ped, -1569615261, true)
                                    if(not isTrash)then
                                        TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true})
                                    else
                                        TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = tonumber(amount)})
                                    end
                                    Wait(500)
                                    JOB.OpenArmory(isTrash or false)
                                end
                            end)
                        else
                            SetCurrentPedWeapon(ped, -1569615261, true)
                            if(not isTrash)then
                                TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = 1, house = true })
                            else
                                TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = 1})
                            end
                            Wait(500)
                            JOB.OpenArmory(isTrash or false)
                        end
                    end)
                elseif data.value == 'withdraw_weapons' then
                    W.TriggerCallback('storage:get', function(inventory)
                        if inventory then
                            local items = {}
                            for kk, item in pairs(inventory) do
                                if GlobalState.Items[item.item].type == 'weapon' then
                                    if type(item.metadata) == 'string' and type(json.decode(item.metadata)) == 'table' then
                                        local tables = {}
                                        for k,v in pairs(json.decode(item.metadata)) do
                                            if W.Metadata[k] then
                                                table.insert(tables, {
                                                    label = W.Metadata[k],
                                                    value = v
                                                })
                                            end
                                        end
                                        table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                    else
                                        if type(item.metadata) == 'table' then
                                            local tables = {}
                                            for k,v in pairs(item.metadata) do
                                                if W.Metadata[k] then
                                                    table.insert(tables, {
                                                        label = W.Metadata[k],
                                                        value = v
                                                    })
                                                end
                                            end
                                            table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                                        else
                                            table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                                        end
                                    end
                                end
                            end
                            Wait(200)
                            JOB.OpenMenu('Armario', "storage_menu", items, function (data, name)
                                W.DestroyMenu(name)
                                if tonumber(data.quantity) > 1 then
                                    W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                                        W.CloseDialog()
                                        amount = tonumber(amount)
                                        if amount and amount <= tonumber(data.quantity) then
                                            TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true})
                                            Wait(500)
                                            JOB.OpenArmory(isTrash or false)
                                        end
                                    end)
                                else
                                    TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = 1 , house = true})
                                    Wait(500)
                                    JOB.OpenArmory(isTrash or false)
                                end
                            end)
                        end
                    end, JOB.Variables.OwnJob.name)
                end
            end)
        end
    end)
end

---comment
---@param onlyOtherPlayers any
---@param returnKeyValue any
---@param returnPeds any
---@return table
JOB.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				table.insert(players, returnPeds and ped or player)
			end
		end
	end

	return players
end

---comment
---@param entities any
---@param isPlayerEntities any
---@param coords any
---@param modelFilter any
---@return integer
---@return integer
JOB.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

---comment
---@param coords any
---@return integer
JOB.GetClosestPlayer = function(coords)
	return JOB.GetClosestEntity(JOB.GetPlayers(true, true), true, coords, nil)
end

exports('closestPlayer', JOB.GetClosestPlayer)

---comment
---@param dictname any
JOB.Loadanimdict = function(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end