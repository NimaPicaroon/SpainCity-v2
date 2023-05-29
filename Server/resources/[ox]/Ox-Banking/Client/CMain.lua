local openATM = false
Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while not W.GetPlayerData().job do
        Wait(500)
    end
    TriggerServerEvent("Ox-Banking:loadPersonalAccount")
end)

OpenAtm = function()
    openATM = true
    local data = W.GetPlayerData()
    local accounts = GlobalState.Accounts
    if accounts[data.identifier] then
        local have = false
        local inventory = W.GetItemsForInventory()

        for k,v in pairs(inventory['data']) do
            if v.name == 'creditcard' then
                if json.decode(v.metadata).number == accounts[data.identifier].credit then
                    have = true
                end
            end
        end
        if have then
            exports['ZC-HelpNotify']:close('interact_atm')
            playAnim('anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 2500)
            Wait(2000)
            local account = {pin = accounts[data.identifier].pin, owner = data.identifier, credit = accounts[data.identifier].credit, accounts = data.money}
            SendNUIMessage({ open = account })
            SetNuiFocus(true, true)
        else
            openATM = false
            W.Notify('BANCO', 'Debes tener tu ~y~tarjeta de crédito', 'error')
        end
    else
        openATM = false
        W.Notify('BANCO', 'Debes crearte una ~y~cuenta', 'error')
    end
end

RegisterNUICallback("close", function(cb, post)
    openATM = false
    SetNuiFocus(false, false)
    post("ok")
end)

RegisterNUICallback("notify", function(data, post)
    W.Notify('BANCO', data.msg, 'error')
    if data.close then
        SetNuiFocus(false, false)
    end
    post("ok")
end)

RegisterNUICallback('deposit', function(data, cb)
    local money = tonumber(data.value)
    TriggerServerEvent('Ox-Banking:deposit', money)
end)

RegisterNUICallback('withdraw', function(data, cb)
    local money = tonumber(data.value)
    TriggerServerEvent('Ox-Banking:withdraw', money)
end)

RegisterNUICallback('changePin', function(data, cb)
    local pin = tonumber(data.value)
    TriggerServerEvent('Ox-Banking:changePin', pin)
end)

RegisterNUICallback('createPin', function(data, cb)
    local pin = tonumber(data.value)

    TriggerServerEvent('Ox-Banking:createPin', pin)
end)

RegisterNUICallback('newCredit', function(data, cb)
    TriggerServerEvent('Ox-Banking:newCredit')
end)

RegisterNUICallback('transfer', function(data, cb)
    local iban = data.iban
    local money = tonumber(data.value)

    TriggerServerEvent('Ox-Banking:transfer', iban, money)
end)

RegisterNUICallback("transferPhone", function (data)
    local iban = data.iban
    local money = tonumber(data.value)
    local player = W.GetPlayerData()

    if money <= player.money.bank then
        TriggerServerEvent('Ox-Banking:transfer', iban, money)
    else
        W.Notify('BANCO', 'No tienes tanto dinero en tu ~y~cuenta', 'error')
    end
end)

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end


function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

InAtm = function ()
    local hit, ocoords, entity = RayCastGamePlayCamera(1000.0)
    local coords = GetEntityCoords(PlayerPedId())

    if hit and GetEntityType(entity) ~= 0 and IsEntityAnObject(entity) and entity ~= 0 then
        for k,v in pairs(Config.Props) do
            if v == GetEntityModel(entity) or entity == 5808387 then
                local objCoords = GetEntityCoords(entity)
                if #(objCoords - coords) <= 1.85 then
                    return objCoords
                end
            end
        end
    end

    return nil
end

CreateThread(function()
    local add = false
    while true do
        local msec = 500

        if not openATM then
            local objCoords = InAtm()
            local playercoor  = GetEntityCoords(PlayerPedId())
            local dist = #(playercoor - vector3(146.02, -1035.15, 29.34))
            if dist < 1.5 then
                msec = 0
                W.ShowText(vector3(146.02, -1035.15, 29.34) + vector3(0,0,0.5), '~y~Cajero\n~w~Interacciona con tu cuenta', 0.5, 8)
                if IsControlJustPressed(0, 38) then
                    OpenAtm()
                end
            end
            if objCoords then
                msec = 0

                W.ShowText(objCoords + vector3(0,0,1.5), '~y~Cajero\n~w~Interacciona con tu cuenta', 0.5, 8)
                if not add then
                    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interaccionar', 'interact_atm')
                    add = true
                end

                if IsControlJustPressed(0, 38) then
                    OpenAtm()
                end
            else
                if add then
                    add = false
                    exports['ZC-HelpNotify']:close('interact_atm')
                end
            end
        end

        Wait(msec)
    end
end)

CreateThread(function()
    for k,v in pairs(Config.Banks)do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 108)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.7)
        SetBlipColour (blip, 11)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Flecca')
        EndTextCommandSetBlipName(blip)
    end

    local currentatmblip = 0

    while true do
        local coords = GetEntityCoords(PlayerPedId())
        local closest = 1000
        local closestCoords

        for k,v in pairs(Config.Atms) do
            local dstcheck = #(vector3(v.x, v.y, v.z) - vector3(coords.x, coords.y, coords.z))

            if dstcheck < closest then
                closest = dstcheck
                closestCoords = vector3(v.x, v.y, v.z)
            end
        end

        if DoesBlipExist(currentatmblip) then
            RemoveBlip(currentatmblip)
            currentatmblip = 0
        end

        if closestCoords then
            currentatmblip = CreateBlip(closestCoords)
        end

        Wait(2500)
    end
end)

function CreateBlip(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite (blip, 277)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7)
    SetBlipColour (blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('ATM')
    EndTextCommandSetBlipName(blip)

    return blip
end

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 4, 1, false, true, false)
	RemoveAnimDict(animDict)
end

RegisterNetEvent('Ox-Banking:buyWithCreditCard', function(resource, typeShop)
    local have = false
    local inventory = W.GetItemsForInventory()
    local data = W.GetPlayerData()

    for k,v in pairs(inventory['data']) do
        if v.name == 'creditcard' then
            if json.decode(v.metadata).number == GlobalState.Accounts[data.identifier].credit then
                have = true
            end
        end
    end

    if have and GlobalState.Accounts[data.identifier] then
        local account = {pin = GlobalState.Accounts[data.identifier].pin, owner = data.identifier}
        SendNUIMessage({ openShop = account, resource = resource, shoptype = typeShop or nil })
        SetNuiFocus(true, true)
    else
        W.Notify('BANCO', 'Debes tener tu ~y~tarjeta de crédito', 'error')
        TriggerEvent('Ox-Banking:transactionFailed', typeShop and typeShop or nil)
    end
end)

RegisterNetEvent("Ox-Banking:loadAccounts", function(accounts)

end)