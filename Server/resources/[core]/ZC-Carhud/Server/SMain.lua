RegisterServerEvent('ZC-Carhud:removeMoney')
AddEventHandler('ZC-Carhud:removeMoney', function(price)
	local player = W.GetPlayer(source)
	local amount = price
	if price > 0 then
		player.removeMoney('money', amount)
	end
end)