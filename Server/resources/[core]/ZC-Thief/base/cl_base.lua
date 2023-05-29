ThiefController = setmetatable({ }, ThiefController)
ThiefController._variables = {
    _entity = nil
}
Props = {}
RegisterNetEvent('Ox-Needs:loadProps', function (props)
    Props = props
end)

ThiefController.__index = ThiefController

ThiefController.start = function()
    local self = {}
    self.playerPed = PlayerPedId()
    self.playerPos = GetEntityCoords(self.playerPed)
    self.playerData = Core.GetPlayerData()
    self.closest, self.distance = exports['Ox-Jobcreator']:closestPlayer(self.playerPos)

    if self.closest ~= -1 and self.distance ~= -1 and self.distance <= 2.0 then
        self.closestId = GetPlayerServerId(self.closest)
        self.targetPed = GetPlayerPed(self.closest)
        self.deadPeople = exports['ZC-Ambulance']:GetDeadPeople()

        print(self.targetPed, DoesEntityExist(self.targetPed))
        if self.playerData.job and self.playerData.job.name ~= 'police' then
            if not self.deadPeople[self.closestId] then
                if not IsEntityPlayingAnim(self.targetPed, 'missminuteman_1ig_2', 'handsup_base', 3) then
                    return Core.Notify('Cacheo', 'El jugador no tiene las manos levantadas', 'error')
                end
            end
        end

        ExecuteCommand('me Le cachea')
        RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
        while not HasAnimDictLoaded('anim@gangops@facility@servers@bodysearch@') do 
            Wait(0)
        end

        TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 1.0, 3000, 49, 0, 0, 0, 0)
        TriggerServerEvent('thief:start', self.closestId)
    else
        Core.Notify('Notificación', '~r~No~w~ hay jugadores cerca.', 'error')
    end
end

exports('steal', ThiefController.start)

ThiefController.steal = function(name, target, targetPed, isAdminStealing)
    if type(name) ~= 'string' then
        return
    end

    if type(target) ~= 'number' then
        return
    end

    local self = {}
    self.name = name
    self.target = target
    self.targetPed = NetworkGetEntityFromNetworkId(targetPed)
    ThiefController._variables._entity = self.targetPed
    ThiefController._variables._isAdminStealing = isAdminStealing or false

    self._init = function(openAgain)
        local elements = {}
        if openAgain then
            TriggerServerEvent('thief:startAgain', self.target)
        end
        Core.TriggerCallback('thief:getItems', function(inventory, accounts)
            table.insert(elements, {label = 'Dinero en mano: '..accounts.money..'$', quantity = accounts.money, name = "money"})
            for index, item in pairs(inventory) do
                if type(item.metadata) == 'table' then
                    local tables = {}

                    for k,v in pairs(item.metadata) do
                        if Core.Metadata[k] then
                            table.insert(tables, {
                                label = Core.Metadata[k],
                                value = v
                            })
                        end
                    end

                    table.insert(elements, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata, metadataItem = tables})
                else
                    table.insert(elements, {label = '['..item.quantity..'] '..GlobalState.Items[item.item].label, quantity = item.quantity, name = item.item, itemName = item.item, slotId = item.slotId, metadata = item.metadata})
                end
            end

            Wait(200)
            Core.OpenMenu('Inventario ('..self.name..')', 'thief_inv_menu', elements, function(data, name)
                Core.DestroyMenu(name)
                if tonumber(data.quantity) > 1 then
                    Core.OpenDialog("Cantidad a retirar", "dialog_quaaa", function(amount)
                        Core.CloseDialog()
                        local amount = tonumber(amount)

                        if amount and amount <= tonumber(data.quantity) then
                            local playerPed = PlayerPedId()
                            local playerPos = GetEntityCoords(playerPed)

                            RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
                            while not HasAnimDictLoaded('anim@gangops@facility@servers@bodysearch@') do 
                                Wait(0)
                            end

                            TriggerServerEvent('thief:stealItem', data.name, amount, data.metadata, data.slotId, self.target, isAdminStealing)
                            Core.DestroyMenu('thief_inv_menu')
                            self._init(true)
                            ClearPedTasks(playerPed)
                            TaskPlayAnim(playerPed, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 1.0, 3000, 49, 0, 0, 0, 0)
                            if data.name == "money" then
                                ExecuteCommand('me se guarda los billetes')
                                Wait(1000)
                                local prop
                                if tonumber(amount) >= 1000 then
                                    prop = CreateObject(GetHashKey('h4_prop_h4_cash_bag_01a'), playerPos.x, playerPos.y, playerPos.z, true)
                                    FreezeEntityPosition(prop, true)
                                    SetEntityAsMissionEntity(prop)
                                    SetEntityCollision(prop, false, true)
                                    PlaceObjectOnGroundProperly(prop)
                                elseif tonumber(amount) >= 300 then
                                    prop = CreateObject(GetHashKey('bkr_prop_money_wrapped_01'), playerPos.x, playerPos.y, playerPos.z, true)
                                    FreezeEntityPosition(prop, true)
                                    SetEntityAsMissionEntity(prop)
                                    SetEntityCollision(prop, false, true)
                                    PlaceObjectOnGroundProperly(prop)
                                else
                                    prop = CreateObject(GetHashKey('p_banknote_onedollar_s'), playerPos.x, playerPos.y, playerPos.z, true)
                                    FreezeEntityPosition(prop, true)
                                    SetEntityAsMissionEntity(prop)
                                    SetEntityCollision(prop, false, true)
                                    PlaceObjectOnGroundProperly(prop)
                                end
                                AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                                Wait(200)
                                DeleteEntity(prop)
                                SetCurrentPedWeapon(playerPed, -1569615261, true)
                            else
                                ExecuteCommand('me se guarda un/a '..GlobalState.Items[data.name].label)
                                Wait(1000)
                                local prop = CreateObject(GetHashKey(Props[data.name]), playerPos.x, playerPos.y, playerPos.z, true)
                                FreezeEntityPosition(prop, true)
                                SetEntityAsMissionEntity(prop)
                                SetEntityCollision(prop, false, true)
                                AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                                Wait(200)
                                DeleteEntity(prop)
                                SetCurrentPedWeapon(playerPed, -1569615261, true)
                            end
                        end
                    end)
                else
                    local playerPed = PlayerPedId()
                    local playerPos = GetEntityCoords(playerPed)

                    RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
                    while not HasAnimDictLoaded('anim@gangops@facility@servers@bodysearch@') do 
                        Wait(0)
                    end

                    TaskPlayAnim(playerPed, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 1.0, 3000, 49, 0, 0, 0, 0)
                    if data.name == "money" then
                        ExecuteCommand('me se guarda los billetes')
                        Wait(1000)
                        local prop
                        if tonumber(amount) >= 1000 then
                            prop = CreateObject(GetHashKey('h4_prop_h4_cash_bag_01a'), playerPos.x, playerPos.y, playerPos.z, true)
                            FreezeEntityPosition(prop, true)
                            SetEntityAsMissionEntity(prop)
                            SetEntityCollision(prop, false, true)
                            PlaceObjectOnGroundProperly(prop)
                        elseif tonumber(amount) >= 300 then
                            prop = CreateObject(GetHashKey('bkr_prop_money_wrapped_01'), playerPos.x, playerPos.y, playerPos.z, true)
                            FreezeEntityPosition(prop, true)
                            SetEntityAsMissionEntity(prop)
                            SetEntityCollision(prop, false, true)
                            PlaceObjectOnGroundProperly(prop)
                        else
                            prop = CreateObject(GetHashKey('p_banknote_onedollar_s'), playerPos.x, playerPos.y, playerPos.z, true)
                            FreezeEntityPosition(prop, true)
                            SetEntityAsMissionEntity(prop)
                            SetEntityCollision(prop, false, true)
                            PlaceObjectOnGroundProperly(prop)
                        end
                        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                        Wait(200)
                        DeleteEntity(prop)
                        SetCurrentPedWeapon(playerPed, -1569615261, true)
                    else
                        ExecuteCommand('me se guarda un/a '..GlobalState.Items[data.name].label)
                        Wait(1000)
                        local prop = CreateObject(GetHashKey(Props[data.name]), playerPos.x, playerPos.y, playerPos.z, true)
                        FreezeEntityPosition(prop, true)
                        SetEntityAsMissionEntity(prop)
                        SetEntityCollision(prop, false, true)
                        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 58866), 0.08, -0.02, -0.02, 90.0, 90.0, 10.0, true, true, false, true, 1, true)
                        Wait(200)
                        DeleteEntity(prop)
                        SetCurrentPedWeapon(playerPed, -1569615261, true)
                    end
                    TriggerServerEvent('thief:stealItem', data.name, data.quantity, data.metadata, data.slotId, self.target, isAdminStealing)
                    Core.DestroyMenu('thief_inv_menu')
                    self._init(true)
                    ClearPedTasks(playerPed)
                end
            end, function()
                TriggerServerEvent('thief:stop', self.target)
            end)
        end, self.target)
    end

    self._init()
end

RegisterNetEvent('thief:steal', ThiefController.steal)

Citizen.CreateThread(function()
    while true do
        local msec = 1000

        if DoesEntityExist(ThiefController._variables._entity) and not ThiefController._variables._isAdminStealing then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local distance = #(GetEntityCoords(ThiefController._variables._entity) - coords)

            if distance > 3 then
                ThiefController._variables.entity = nil
                Core.CloseDialog()
                Core.DestroyMenu("thief_inv_menu")
            end
        end

        Citizen.Wait(msec)
    end
end)