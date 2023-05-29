local isCraftOpen = false
local timeCraft, itemRecipe, craftss, success, isItem
local queue = {}
local maxCraftRadius = 1.5

Table = function ()
	if not isCraftOpen then
		local gang = exports['Ox-Gangs']:MyGangData()
		if gang then
			TriggerScreenblurFadeIn(5000)
			isCraftOpen = true
			Citizen.Wait(100)
			SetNuiFocus(true, true)

			SendNUIMessage({
				action = "openCraft",
				name = gang.name,
				craft = Config.Crafts[gang.level],
				itemNames = GlobalState.Items
			})
		end
	end
end

RegisterNetEvent('Ox-Crafting:craftTable', Table)

RegisterNUICallback('action', function(data, cb)
	if data.action == 'close' then
		TriggerScreenblurFadeOut(5000)
		SetNuiFocus(false, false)
		isCraftOpen = false
	elseif data.action == 'craft' then
		local invItems = {}
		local loop = 0
		local added = 0
		for k,v in pairs(data.crafts) do
			if data.item == v.item then
				for k2,v2 in pairs(v.recipe) do
					local have, item = W.HaveItem(v2[1])
					loop = loop + 1
					local value = {key = have}
					table.insert(invItems, value)
					added = added + 1
				end
				while added ~= loop do
					Citizen.Wait(100)
				end
				timeCraft, itemRecipe, craftss = v.time, v.recipe, data.crafts
				SendNUIMessage({
					action = "openSideCraft",
					itemNameID = data.item,
					itemName = data.itemName[data.item].label,
					itemNames = data.itemName,
					itemAmount = v.amount,
					time = v.time,
					recipe = v.recipe,
					inventory = invItems,
					crafts = data.crafts,
				})
				break
			end
		end
	elseif data.action == 'craft-button' then
		local recipeTable = Split(data.recipe, ",")
		local invItems = {}
		local loop = 0
		local added = 0
		local item = {
			item = data.itemID,
			amount = data.amount,
			success = success,
			isItem = isItem,
			time = timeCraft,
			recipe = itemRecipe,
			crafts = craftss,
			coords = GetEntityCoords(PlayerPedId()),
			maxCraftRadius = maxCraftRadius
		}
		table.insert(queue, item)
		W.TriggerCallback("Ox-Crafting:CanCraftItem", function(canCraft)
			if canCraft then
				for k2,v2 in pairs(recipeTable) do
					local have, item = W.HaveItem(v2[1])
					loop = loop + 1
					local value = {key = have}
					table.insert(invItems, value)
					added = added + 1
				end
				while added ~= loop do
					Citizen.Wait(100)
				end
				SendNUIMessage({
					action = "openSideCraft",
					itemNameID = data.itemID,
					itemName = GlobalState.Items[data.itemID].label,
					itemNames = GlobalState.Items,
					itemAmount = data.amount,
					time = timeCraft,
					recipe = itemRecipe,
					inventory = invItems,
					crafts = craftss,
				})
				if queue[1] == item then
					local crafting = false
					while queue[1] ~= nil do
						Citizen.Wait(100)
						if not crafting then
							crafting = true
							TriggerServerEvent('Ox-Crafting:craftStartItem')
							local invItems = {}
							local loop = 0
							local added = 0

							for k2,v2 in pairs(recipeTable) do
								local have, item = W.HaveItem(v2[1])
								loop = loop + 1
								local value = {key = have}
								table.insert(invItems, value)
								added = added + 1
							end
							while added ~= loop do
								Citizen.Wait(50)
							end

							local timePassed = 0
							while timePassed < queue[1].time do
								local playerCoords = GetEntityCoords(PlayerPedId())
								local distance = #(queue[1].coords - playerCoords)
								SendNUIMessage({
									action = "ShowCraftCount",
									time = queue[1].time - timePassed,
									name = GlobalState.Items[queue[1].item].label,
								})
								if distance <= queue[1].maxCraftRadius then
									timePassed = timePassed + 1
								end
								Citizen.Wait(1000)

								if IsEntityDead(PlayerPedId()) then
									TriggerServerEvent('Ox-Crafting:craftStopItem')
									break
								end
							end
							if IsEntityDead(PlayerPedId()) then
								SendNUIMessage({
									action = "HideCraftCount",
								})
								TriggerServerEvent('Ox-Crafting:craftItemDeath', queue)
								for k,v in pairs(queue) do
									queue[k] = nil
								end
								break
							end

							TriggerServerEvent('Ox-Crafting:craftItemFinished', queue[1].item, queue[1].crafts)
							SendNUIMessage({
								action = "CompleteCraftCount",
								name = GlobalState.Items[queue[1].item].label,
							})

							Citizen.Wait(2000)
							SendNUIMessage({
								action = "HideCraftCount",
							})
							table.remove(queue, 1)
							crafting = false
						end
						while crafting do
							Citizen.Wait(500)
						end
					end
				end
			end
		end, data.itemID, recipeTable, GlobalState.Items, data.amount)
	end
end)

function Split(s, delimiter)
	local index = 0
	local result = {}
	local line = {}

	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		if tonumber(match) ~= nil then
			match = tonumber(match)
		end
		if index == 0 or index % 3 ~= 0 then
			table.insert(line, match)
		else
			table.insert(result, line)
			line = {}
			table.insert(line, match)
		end
		index = index + 1
	end
	table.insert(result, line)
	return result
end