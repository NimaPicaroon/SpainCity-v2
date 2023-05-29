W.YourData = {}
W.Items = {}

RegisterNetEvent('ZCore:updateData', function(data, items)
    W.YourData = data

    local slots = {}
    if items then
        W.Items = items
    end
    for k,v in pairs(data.inventory.slots) do
        if v.slot then
            slots[v.slot] = data.inventory.slots[k]
        end
    end

    W.Inventory.Items = {data = {}, totalWeight = data.inventory.totalWeight, slots = slots, money = data.money.money, black_money = data.money.blackmoney, coins = data.money.coins}

    if data.inventory.items then
        for k,v in pairs(data.inventory.items) do
            if v.slotId and items[v.item] then
                table.insert(W.Inventory.Items.data, {slotId = v.slotId, id = k, quantity = v.quantity, type = items[v.item].type, name = v.item, metadata = json.encode(v.metadata), label = items[v.item].label, weight = items[v.item].weight})
            end
        end
    end
end)

Citizen.CreateThread(function()
	local previousCoords = vector3(0, 0, 0)

    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    RoundNumber = function(value, numDecimalPlaces)
        if numDecimalPlaces then
            local power = 10^numDecimalPlaces
            return math.floor((value * power) + 0.5) / (power)
        else
            return math.floor(value + 0.5)
        end
    end
    

	while true do
		Citizen.Wait(5000)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local distance = #(playerCoords - previousCoords)

		if distance > 10 and not exports['Ox-Housing']:inProperty() then
			previousCoords = playerCoords
			local playerHeading = RoundNumber(GetEntityHeading(playerPed), 1)
			local formattedCoords = {x = RoundNumber(playerCoords.x, 1), y = RoundNumber(playerCoords.y, 1), z = RoundNumber(playerCoords.z, 1), heading = playerHeading}
			TriggerServerEvent('core:updateCoords', formattedCoords)
		end
	end
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while not W.GetPlayerData().status do
        Wait(500)
    end

    while true do
        local playerPed = PlayerPedId()
        local playerHealth = GetEntityHealth(playerPed)
        local playerStatus = W.GetPlayerData().status

        if playerStatus.hunger <= 0 then
            playerStatus.hunger = 0
        else
            playerStatus.hunger = playerStatus.hunger - 1.5
        end

        if playerStatus.thirst <= 0 then
            playerStatus.thirst = 0
        else
            playerStatus.thirst = playerStatus.thirst - 1.5
        end

        if playerStatus.stress and playerStatus.stress >= 100 then
            playerStatus.stress = 100
        else
            if playerStatus.stress and playerStatus.stress > 60 then
                playerStatus.stress = playerStatus.stress + 0.75
            else
                playerStatus.stress = playerStatus.stress + 0.75
            end
        end

        TriggerServerEvent('core:updateStatus', playerStatus)

        Citizen.Wait(5 * 60 * 1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local msec = 500
        local Ped = PlayerPedId()
        local Health = GetEntityHealth(Ped)
        local Player = W.GetPlayerData()

        if Player.status then
            if IsPedShooting(Ped) then
                msec = 0
                Player.status.stress = Player.status.stress + 0.15
            end
            if Player.status.hunger <= 0 or Player.status.thirst <= 0 then
                SetEntityHealth(Ped, Health - 1)
            end
        end

        Citizen.Wait(msec)
    end
end)