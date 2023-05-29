local sessions = {}

RegisterServerEvent('Ox-Crafting:craftStartItem')
AddEventHandler('Ox-Crafting:craftStartItem',function()
	sessions[source] = {
		stoppedCraft = false,
		isCrafting = true,
		last = GetGameTimer(),
	}
end)

RegisterServerEvent('Ox-Crafting:craftStopItem')
AddEventHandler('Ox-Crafting:craftStopItem',function()
	sessions[source] = {
		stoppedCraft = true,
		isCrafting = false,
	}
end)

RegisterServerEvent('Ox-Crafting:craftItemDeath')
AddEventHandler('Ox-Crafting:craftItemDeath',function(queueClient)
	local xPlayer = W.GetPlayer(source)
	local queue = queueClient

	if sessions[source] then
		if sessions[source].stoppedCraft then
			for k,v in ipairs(queue) do
				for k2,v2 in ipairs(v.recipe) do
					local metadata = W.DefaultMetadata[v2[1]] or false
					xPlayer.addItemToInventory(v2[1], tonumber(v2[2]), metadata)
				end
			end
			sessions[xPlayer.src] = nil
		end
	end
end)

RegisterServerEvent('Ox-Crafting:craftItemFinished')
AddEventHandler('Ox-Crafting:craftItemFinished', function(item, crafts)
	local xPlayer = W.GetPlayer(source)
	local timeToCraft = 600000
	local amount = 0
	if sessions[source] then
		for k,v in ipairs(crafts) do
			if v.item == item then
				amount = v.amount
				timeToCraft = v.time * 1000
			end
		end
		sessions[source].last = GetGameTimer() - sessions[source].last
		if sessions[source].last+500 >= timeToCraft then
			name = item
			if string.find(string.upper(name), 'WEAPON_') then
				name = 'weapon'
			end
			local metadata = W.DefaultMetadata[name] or false
			xPlayer.addItemToInventory(item, tonumber(amount), metadata)
			W.SendToDiscord('crafteos', "Bandas", GetPlayerName(source)..' ha fabricado '..amount..' '..item.." para la banda "..xPlayer.gang.label, source)
			sessions[xPlayer.src] = nil
		end
	end
end)

W.CreateCallback("Ox-Crafting:CanCraftItem", function(source, cb, itemID, recipe, itemName, amount)
	local xPlayer = W.GetPlayer(source)
	local canCraft = true
	local items = {}

	for k,v in pairs(recipe) do
		local have, item = xPlayer.getItem(v[1])
		if item then
			if tonumber(item.quantity) < tonumber(v[2]) then
				canCraft = false
			end
			items[v[1]] = item
		else
			canCraft = false
		end
	end

	if canCraft then
		if xPlayer.canHoldItem(itemID, tonumber(amount)) then
			for k,v in pairs(recipe) do
				if v[3] == "true" then
					xPlayer.removeItemFromInventory(v[1], v[2], items[v[1]].slotId)
				end
			end
			cb(true)
			xPlayer.Notify("CRAFTEO", itemName[itemID].label..' añadido a la cola de crafteo', 'verify')
		end
	else
		cb(false)
		xPlayer.Notify("CRAFTEO", 'No puedes craftear esto', 'error')
	end
end)