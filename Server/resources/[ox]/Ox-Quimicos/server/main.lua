
W = exports.ZCore:get()

RegisterServerEvent('Ox-Quimicos:pickChemicals')
AddEventHandler('Ox-Quimicos:pickChemicals', function(quimicos, amount)
	local xPlayer = W.GetPlayer(source)

	if xPlayer then
		xPlayer.addItemToInventory(quimicos, amount)
		W.SendToDiscord("farmeo", "RECOLECTA QUIMICOS", "Ha recolectado x"..amount.. " de " .. quimicos, source )
	end
end)

RegisterServerEvent('Ox-Quimicos:processLSA')
AddEventHandler('Ox-Quimicos:processLSA', function()
	local player = W.GetPlayer(source)
	local have, chemicals = player.getItem('chemicals')

	if have then
		player.removeItemFromInventory('chemicals', 1, chemicals.slotId)
		player.addItemToInventory("lsa", 1)
		player.Notify("LSA", 'Has procesado ~b~x1~s~ ~y~Químico~s~', "verify")
		W.SendToDiscord("farmeo", "PROCESADO A LSA", "Ha recolectado x1 de LSA", source )
	end

end)

RegisterServerEvent('Ox-Quimicos:processLSD')
AddEventHandler('Ox-Quimicos:processLSD', function()
	local player = W.GetPlayer(source)
	local have, lsa = player.getItem('lsa')

	if have then
		player.removeItemFromInventory('lsa', 1, lsa.slotId)
		player.addItemToInventory("lsd", 1)
		player.Notify("LSD", 'Has procesado ~b~x1~s~ ~y~LSA~s~', "verify")
		W.SendToDiscord("farmeo", "PROCESADO A LSD", "Ha recolectado x1 de LSD", source )
	end
end)