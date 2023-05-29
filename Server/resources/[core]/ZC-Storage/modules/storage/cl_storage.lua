StorageModule = setmetatable({ }, StorageModule)
StorageModule.__index = StorageModule

function StorageModule:Main(name, label, options) -- options = { items, weapons, blackMoney, admin, onlyDeposit}
    if(not GlobalState[name])then
        return Wave.Notify("Storage", "Ocurrió un error contacta con un desarrollador. (storage_not_found) (" .. name .. ")", "error")
    end
    local self = { elements = {} }
    if(options.blackMoney or options.admin)then
        table.insert(self.elements, {label = 'Administrar <span style="color:red;">dinero (negro)</span>', value = 'admin_blackmoney'})
    end
    if(options.items or options.admin)then
        table.insert(self.elements, {label = "Administrar Objetos", value = "admin_objects"})
    end
    if(options.weapons or options.admin)then
        table.insert(self.elements, {label = "Administrar Armas", value = "admin_weapons"})
    end
    W.OpenMenu('Almacén - ' .. label, "main_storage_menu_" .. name, self.elements, function (data, name)
        W.DestroyMenu(name)
        Citizen.Wait(200)
        if(data.value == "admin_objects")then
            StorageModule:AdminObjects(name, label, options)
        end
    end)
end

function StorageModule:AdminObjects(name, label, options)
    local self = {elements = {}}

    if(not self.data)then
        return Wave.Notify("Storage", "Ocurrió un error contacta con un desarrollador. (storage_not_found) (" .. name .. ")", "error")
    end
    table.insert(self.elements, { label = 'Depositar Objetos', value = 'deposit_objects' })
    if(not options.onlyDeposit)then
        table.insert(self.elements, { label = 'Retirar Objetos', value = 'withdraw_objects' })
    end
    W.OpenMenu('Almacén - ' .. label, "admin_objects_storage_menu_" .. name, self.elements, function (data, name)
        W.DestroyMenu(name)
        Citizen.Wait(200)
        if(data.value == "withdraw_objects")then
            
        end
    end)
end

-- RegisterCommand("storagetest", function(source, args)
--     print("llegamos")
--     StorageModule:Main("house882", "Casa #882", {items = true, weapons = true, blackMoney = true, admin = false})
-- end)

-- JOB.OpenArmory = function(isTrash)
--     local initElements = {}
--     if(not isTrash)then
--         table.insert(initElements, {label = 'Administrar <span style="color:red;">dinero (negro)</span>', value = 'admin_blackmoney'})
--     end
--     table.insert(initElements, { label = 'Administrar items', value = 'admin_items' })
--     table.insert(initElements, { label = 'Administrar armas', value = 'admin_weapons' })
--     JOB.OpenMenu('Inventario', 'job_armory_jobcreator', initElements, function(data, menu)
--         W.DestroyMenu(menu)
--         Wait(200)

--         if data.value == 'admin_items' then
--             local elements = {}
--             table.insert(elements, { label = 'Depositar items', value = 'deposit_items' })
--             if(not isTrash)then
--                 table.insert(elements, { label = 'Retirar items', value = 'withdraw_items' })
--             end
--             JOB.OpenMenu('Administrar items', 'job_armory_admin_items', elements, function(data, menu)
--                 W.DestroyMenu(menu)
--                 Wait(200)

--                 if data.value == 'deposit_items' then
--                     local items = {}
--                     local inventory = W.GetItemsForInventory()['data']

--                     for k, v in pairs(inventory) do
--                         if GlobalState.Items[v.name].type ~= 'weapon' then
--                             if type(v.metadata) == 'string' and type(json.decode(v.metadata)) == 'table' then
--                                 local tables = {}

--                                 for info, value in pairs(json.decode(v.metadata)) do
--                                     table.insert(tables, {
--                                         label = W.Metadata[info],
--                                         value = value
--                                     })
--                                 end
--                                 table.insert(items, {label = '['..v.quantity..'] '..v.label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
--                             else
--                                 if type(v.metadata) == 'table' then
--                                     local tables = {}
--                                     for k,v in pairs(v.metadata) do
--                                         table.insert(tables, {
--                                             label = W.Metadata[k],
--                                             value = v
--                                         })
--                                     end
--                                     table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
--                                 else
--                                     table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
--                                 end
--                             end
--                         end
--                     end
--                     Wait(200)

--                     JOB.OpenMenu('Tu inventario', "inventory_menu", items, function (data, name)
--                         W.DestroyMenu(name)

--                         local ped = PlayerPedId()
--                         if tonumber(data.quantity) > 1 then
--                             W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
--                                 W.CloseDialog()
--                                 amount = tonumber(amount)
--                                 if amount and amount <= tonumber(data.quantity) then
--                                     SetCurrentPedWeapon(ped, -1569615261, true)
--                                     if(not isTrash)then
--                                         TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true })
--                                     else
--                                         TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = tonumber(amount)})
--                                     end
--                                     Wait(500)
--                                     JOB.OpenArmory(isTrash or false)
--                                 end
--                             end)
--                         else
--                             SetCurrentPedWeapon(ped, -1569615261, true)
--                             if(not isTrash)then
--                                 TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = 1, house = true })
--                             else
--                                 TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = tonumber(1)})
--                             end
--                             Wait(500)
--                             JOB.OpenArmory(isTrash or false)
--                         end
--                     end)
--                 elseif data.value == 'withdraw_items' then
--                     W.TriggerCallback('storage:get', function(inventory)
--                         if inventory then
--                             local items = {}
--                             for kk, item in pairs(inventory) do
--                                 if GlobalState.Items[item.item].type ~= 'weapon' then
--                                     if type(item.metadata) == 'string' and type(json.decode(item.metadata)) == 'table' then
--                                         local tables = {}
--                                         for k,v in pairs(json.decode(item.metadata)) do
--                                             table.insert(tables, {
--                                                 label = W.Metadata[k],
--                                                 value = v
--                                             })
--                                         end
--                                         table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
--                                     else
--                                         if type(item.metadata) == 'table' then
--                                             local tables = {}
--                                             for k,v in pairs(item.metadata) do
--                                                 table.insert(tables, {
--                                                     label = W.Metadata[k],
--                                                     value = v
--                                                 })
--                                             end
--                                             table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
--                                         else
--                                             table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
--                                         end
--                                     end
--                                 end
--                             end
--                             Wait(200)
--                             JOB.OpenMenu('Armario', "storage_menu", items, function (data, name)
--                                 W.DestroyMenu(name)
--                                 if tonumber(data.quantity) > 1 then
--                                     W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
--                                         W.CloseDialog()

--                                         amount = tonumber(amount)
--                                         if amount and amount <= tonumber(data.quantity) then
--                                             TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true})
--                                             Wait(500)
--                                             JOB.OpenArmory(isTrash or false)
--                                         end
--                                     end)
--                                 else
--                                     TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = 1, house = true })
--                                     Wait(500)
--                                     JOB.OpenArmory(isTrash or false)
--                                 end
--                             end)
--                         end
--                     end, JOB.Variables.OwnJob.name)
--                 end
--             end)
--         elseif data.value == 'admin_blackmoney' then
--             JOB.OpenMenu('Administrar dinero negro', 'admin_blackmoney', {
--                 { label = 'Balance <span style="color: red">($'..GlobalState[JOB.Variables.OwnJob.name.."-guille"].blackmoney..')</span>', value = 'none' },
--                 { label = 'Depositar dinero', value = 'deposit_money' },
--                 { label = 'Retirar dinero', value = 'withdraw_money' }
--             }, function(data, menu)
--                 W.DestroyMenu(menu)
--                 Wait(200)

--                 if data.value == 'deposit_money' then
--                     W.TriggerCallback('jobcreator:getPlayerBlackmoney', function(blackMoney)
--                         if blackMoney > 0 then
--                             W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
--                                 W.CloseDialog()
--                                 amount = tonumber(amount)
--                                 if amount and amount <= blackMoney then
--                                     TriggerServerEvent('jobcreator:blackmoneyAction', 'deposit', amount, JOB.Variables.OwnJob.name)
--                                     Wait(500)
--                                     JOB.OpenArmory(false)
--                                 else
--                                     W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no tienes ~r~suficiente~w~.', 'error')
--                                 end
--                             end)
--                         else
--                             W.Notify('Almacenamiento', 'No tienes ~r~dinero negro~w~ que depositar.', 'error')
--                         end
--                     end)
--                 elseif data.value == 'withdraw_money' then
--                     Wait(200)
--                     W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
--                         W.CloseDialog()

--                         amount = tonumber(amount)
--                         if amount and amount <= GlobalState[JOB.Variables.OwnJob.name.."-guille"].blackmoney then
--                             TriggerServerEvent('jobcreator:blackmoneyAction', 'withdraw', amount, JOB.Variables.OwnJob.name)
--                             Wait(500)
--                             JOB.OpenArmory(false)
--                         else
--                             W.Notify('Almacenamiento', 'Cantidad ~r~inválida o no hay ~r~suficiente~w~ depositado.', 'error')
--                         end
--                     end)
--                 end
--             end)
--         elseif data.value == 'admin_weapons' then
--             local elements = {}
--             table.insert(elements, { label = 'Depositar armas', value = 'deposit_weapons' })
--             if(not isTrash)then
--                 table.insert(elements, { label = 'Retirar armas', value = 'withdraw_weapons' })
--             end
--             JOB.OpenMenu('Administrar armas', 'job_armory_admin_weapons', elements, function(data, menu)
--                 W.DestroyMenu(menu)
--                 Wait(200)

--                 if data.value == 'deposit_weapons' then
--                     local items = {}
--                     local inventory = W.GetItemsForInventory()['data']

--                     for k, v in pairs(inventory) do
--                         if GlobalState.Items[v.name].type == 'weapon' then
--                             if type(v.metadata) == 'string' and type(json.decode(v.metadata)) == 'table' then
--                                 local tables = {}

--                                 for info, value in pairs(json.decode(v.metadata)) do
--                                     table.insert(tables, {
--                                         label = W.Metadata[info],
--                                         value = value
--                                     })
--                                 end
--                                 table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
--                             else
--                                 if type(v.metadata) == 'table' then
--                                     local tables = {}
--                                     for k,v in pairs(v.metadata) do
--                                         table.insert(tables, {
--                                             label = W.Metadata[k],
--                                             value = v
--                                         })
--                                     end
--                                     table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata, metadataItem = tables})
--                                 else
--                                     table.insert(items, {label = '['..v.quantity..'] '..GlobalState.Items[v.name].label, quantity = v.quantity, name = v.name, itemName = v.name, slotId = v.slotId, metadata = v.metadata})
--                                 end
--                             end
--                         end
--                     end
--                     Wait(200)

--                     JOB.OpenMenu('Tu inventario', "inventory_menu", items, function (data, name)
--                         W.DestroyMenu(name)

--                         local ped = PlayerPedId()

--                         if tonumber(data.quantity) > 1 then
--                             W.OpenDialog("Cantidad a depositar", "dialog_quaaa", function(amount)
--                                 W.CloseDialog()

--                                 amount = tonumber(amount)
--                                 if amount and amount <= tonumber(data.quantity) then
--                                     SetCurrentPedWeapon(ped, -1569615261, true)
--                                     if(not isTrash)then
--                                         TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true})
--                                     else
--                                         TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = tonumber(amount)})
--                                     end
--                                     Wait(500)
--                                     JOB.OpenArmory(isTrash or false)
--                                 end
--                             end)
--                         else
--                             SetCurrentPedWeapon(ped, -1569615261, true)
--                             if(not isTrash)then
--                                 TriggerServerEvent('storage:store', { name = JOB.Variables.OwnJob.name, data = data, amount = 1, house = true })
--                             else
--                                 TriggerServerEvent("Ox-Jobcreator:removeTrashItem", {item = data, amount = 1})
--                             end
--                             Wait(500)
--                             JOB.OpenArmory(isTrash or false)
--                         end
--                     end)
--                 elseif data.value == 'withdraw_weapons' then
--                     W.TriggerCallback('storage:get', function(inventory)
--                         if inventory then
--                             local items = {}
--                             for kk, item in pairs(inventory) do
--                                 if GlobalState.Items[item.item].type == 'weapon' then
--                                     if type(item.metadata) == 'string' and type(json.decode(item.metadata)) == 'table' then
--                                         local tables = {}
--                                         for k,v in pairs(json.decode(item.metadata)) do
--                                             table.insert(tables, {
--                                                 label = W.Metadata[k],
--                                                 value = v
--                                             })
--                                         end
--                                         table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
--                                     else
--                                         if type(item.metadata) == 'table' then
--                                             local tables = {}
--                                             for k,v in pairs(item.metadata) do
--                                                 table.insert(tables, {
--                                                     label = W.Metadata[k],
--                                                     value = v
--                                                 })
--                                             end
--                                             table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
--                                         else
--                                             table.insert(items, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
--                                         end
--                                     end
--                                 end
--                             end
--                             Wait(200)
--                             JOB.OpenMenu('Armario', "storage_menu", items, function (data, name)
--                                 W.DestroyMenu(name)
--                                 if tonumber(data.quantity) > 1 then
--                                     W.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
--                                         W.CloseDialog()
--                                         amount = tonumber(amount)
--                                         if amount and amount <= data.quantity then
--                                             TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = amount, house = true})
--                                             Wait(500)
--                                             JOB.OpenArmory(isTrash or false)
--                                         end
--                                     end)
--                                 else
--                                     TriggerServerEvent('storage:withdraw', { name = JOB.Variables.OwnJob.name, data = data, amount = 1 , house = true})
--                                     Wait(500)
--                                     JOB.OpenArmory(isTrash or false)
--                                 end
--                             end)
--                         end
--                     end, JOB.Variables.OwnJob.name)
--                 end
--             end)
--         end
--     end)
-- end