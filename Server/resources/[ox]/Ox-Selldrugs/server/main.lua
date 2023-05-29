RegisterNetEvent('Ox-Selling:sellDrug', function(data)
	local player = W.GetPlayer(source)
	local fuckingType = data.name
	local have, item = player.getItem(fuckingType)
	local Prices = {
		['bolsa_opio'] = math.random(125, 175),
		['bolsa_marihuana'] = math.random(125, 175),
		['chivato_coca'] = math.random(325, 375),
		['bolsa_meta'] = math.random(325, 375),
		['bolsa_hachis'] = math.random(145, 190),
		['bote_extasis'] = math.random(245, 255),
		['lean'] = math.random(220, 230)
	}
	local priceTotal = Prices[fuckingType]

	if tonumber(item.quantity) > 1 then
		local random = math.random(1, tonumber(item.quantity))
		if fuckingType == "chivato_coca" then
			if tonumber(item.quantity) > 3 then
				random = math.random(1, 2)
			end
		else
			if tonumber(item.quantity) >= 3 then
				random = math.random(1, 3)
			end
		end

		player.removeItemFromInventory(fuckingType, random, item.slotId)
		player.addMoney('money', priceTotal * random)
		player.Notify("VENTA", "Has vendido ~y~x"..random.."~w~ "..GlobalState.Items[fuckingType].label.." por ~r~"..(priceTotal*random).."€", 'verify')
		W.SendToDiscord('sell', "VENTA DROGAS", 'x'..random..' '..GlobalState.Items[fuckingType].label..' por '..(priceTotal * random).."€", source)
	else
		player.removeItemFromInventory(fuckingType, 1, item.slotId)
		player.addMoney('money', Prices[fuckingType])
		player.Notify("VENTA", "Has vendido ~y~x1~w~ "..GlobalState.Items[fuckingType].label.." por ~r~"..priceTotal.."€", 'verify')
		W.SendToDiscord('sell', "VENTA DROGAS", 'x1'..GlobalState.Items[fuckingType].label..' por '..Prices[fuckingType].."€", source)
	end
end)

RegisterNetEvent('Ox-Selling:callPolice', function(coords)
	local polices = exports['Ox-References']:getPolices()

	for key, value in next, polices do
		if value and value.source then
			TriggerClientEvent("ZC-Dispatch:sendAlertToClient", value.source, "police", "¡Una persona me acaba de intentar vender droga, venid! (" ..source..")", coords, source, "drugs")
		end
	end
end)
