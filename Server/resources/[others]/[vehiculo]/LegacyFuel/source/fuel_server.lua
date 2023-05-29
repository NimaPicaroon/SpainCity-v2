
RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price, addpetrol)
	local player = W.GetPlayer(source)
	local amount = price

	if price > 0 then
		player.removeMoney('money', amount)
	end
	if addpetrol then
		local metadata = W.DefaultMetadata["WEAPON_PETROLCAN"] or false
		player.addItemToInventory("WEAPON_PETROLCAN", 1, metadata)
	end
end)