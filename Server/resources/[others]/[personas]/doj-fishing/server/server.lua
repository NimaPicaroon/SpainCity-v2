local W = exports.ZCore:get()

exports.ZCore:RegisterItem("anchor", function(source, item)
	TriggerClientEvent('fishing:client:anchor', source)
end)

exports.ZCore:RegisterItem("fishingrod", function(source, item)
 	TriggerClientEvent('fishing:fishstart', source)
end)

RegisterNetEvent('fishing:server:removeFishingBait', function()
	local src = source
    local Player = W.GetPlayer(source)
	local haveItem, dataItem = Player.getItem('fishbait')
	
	if haveItem then
		Player.removeItemFromInventory('fishbait', 1, dataItem.slotId)
	end
end)

RegisterNetEvent("fishing:server:returnDeposit", function()
	local src = source
    local pData = W.GetPlayer(src)
	local price = math.floor(Config.BoatPrice/2)
	pData.addMoney('bank', price)
	pData.Notify('Pesca',  "El barco ha sido devuelto por $"..price, 'verify')
end) 

RegisterNetEvent('fishing:server:catch', function(luck) 
    local src = source
    local Player = W.GetPlayer(src)
	if luck == nil then
       luck = math.random(1, 300)
	end
    local itemFound = true
    local itemCount = 1

    if itemFound then
        for i = 1, itemCount, 1 do			
			if  luck >= 270 and luck <= 300 then
				TriggerClientEvent('fishing:client:spawnFish', src, 1)
				Player.addItemToInventory('killerwhale', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~orca', 'verify')
				Player.Notify('Pesca', 'Estas son especies en peligro de extinción y es ilegal poseerlas.', 'warn')
			elseif luck >= 240 and luck <= 270 then
				TriggerClientEvent('fishing:client:spawnFish', src, 2)
				Player.addItemToInventory('dolphin', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~delfín', 'verify')
				Player.Notify('Pesca', 'Estas son especies en peligro de extinción y es ilegal poseerlas.', 'warn')
			elseif luck >= 220 and luck <= 240 then
				TriggerClientEvent('fishing:client:spawnFish', src, 3)
				Player.addItemToInventory('sharkhammer', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~tiburón martillo', 'verify')
				Player.Notify('Pesca', 'Estas son especies en peligro de extinción y es ilegal poseerlas.', 'warn')
			elseif luck >= 200 and luck <= 220 then
				TriggerClientEvent('fishing:client:spawnFish', src, 4)
				Player.addItemToInventory('sharktiger', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~tiburón tigre', 'verify')
				Player.Notify('Pesca', 'Estas son especies en peligro de extinción y es ilegal poseerlas.', 'warn')
			elseif luck >=175  and luck <= 200 then
				TriggerClientEvent('fishing:client:spawnFish', src, 5)
				Player.addItemToInventory('stingray', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~manta raya', 'verify')
			elseif luck >= 150 and luck <= 175 then
				TriggerClientEvent('fishing:client:spawnFish', src, 6)
				Player.addItemToInventory('flounder', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~lenguado', 'verify')
			elseif luck >= 125 and luck <= 150 then
				Player.addItemToInventory('fishingboot', 1)
				Player.Notify('Pesca', 'Has atrapado una ~g~bota', 'verify')
			elseif luck >= 75 and luck <= 125 then
				TriggerClientEvent('fishing:client:spawnFish', src, 6)
				Player.addItemToInventory('bass', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~lubina', 'verify')
			elseif luck >= 50 and luck <= 75 then
				TriggerClientEvent('fishing:client:spawnFish', src, 6)
				Player.addItemToInventory('codfish', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~bacalao', 'verify')
			elseif luck >= 25 and luck <= 50 then
				Player.addItemToInventory('fishingtin', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~lata', 'verify')
			elseif luck >= 0 and luck <= 25 then
				TriggerClientEvent('fishing:client:spawnFish', src, 6)
				Player.addItemToInventory('mackerel', 1)

				Player.Notify('Pesca', 'Has atrapado una ~g~caballa', 'verify')
			end
		
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent('fishing:server:SellillegalFish', function(args)
	local src = source
    local Player = W.GetPlayer(src)
	local args = tonumber(args)
	if args == 1 then 
		local have, dolphin = Player.getItem("dolphin")
		if have then
			local payment = Config.dolphinPrice
			Player.removeItemFromInventory("dolphin", 1, dolphin.slotId)
			Player.addMoney('bank', payment , "dolphin-sell")
			Player.Notify('Pesca', "Delfín vendido por $"..payment, "success")
			TriggerClientEvent("doj:client:SellillegalFish", source)
		else
			Player.Notify('Pesca', "No tienes ningún delfín para vender", 'error')
		end
	elseif args == 2 then 
		local have, sharktiger = Player.getItem("sharktiger")
		if have then
			local payment = Config.sharktigerPrice
			Player.removeItemFromInventory("sharktiger", 1, sharktiger.slotId)
			Player.addMoney('bank', payment , "sharktiger-sell")
			Player.Notify('Pesca', "Tiburón tigre Vendido por $"..payment, "success")
			TriggerClientEvent("doj:client:SellillegalFish", source)
		else
			Player.Notify('Pesca', "No tienes ningún tiburón tigre para vender", 'error')
		end
	elseif args == 3 then 
		local have, sharkhammer = Player.getItem("sharkhammer")
		if have then
			local payment = Config.sharkhammerPrice
			Player.removeItemFromInventory("sharkhammer", 1, sharkhammer.slotId)
			Player.addMoney('bank', payment , "sharkhammer-sell")
			Player.Notify('Pesca', "Tiburón martillo vendido por $"..payment, "success")
			TriggerClientEvent("doj:client:SellillegalFish", source)
		else
			Player.Notify('Pesca', "No tienes ningún tiburón martillo para vender", 'error')
		end
	else
		local have, killerwhale = Player.getItem("killerwhale")
		if have then
			local payment = Config.killerwhalePrice
			Player.removeItemFromInventory("killerwhale", 1, killerwhale.slotId)
			Player.addMoney('bank', payment , "killerwhale-sell")
			Player.Notify('Pesca', "Orca vendida por $"..payment, "success")
			TriggerClientEvent("doj:client:SellillegalFish", source)
		else
			Player.Notify('Pesca', "No tienes ninguna orca para vender", "error")
		end
	end
end)

RegisterNetEvent('fishing:server:SellLegalFish', function(args) 
	local src = source
    local Player = W.GetPlayer(src)
	local args = tonumber(args)
	if args == 1 then 
		local have, mackerel = Player.getItem("mackerel")
		if have then
			local payment = Config.mackerelPrice
			Player.removeItemFromInventory("mackerel", 1, mackerel.slotId)
			Player.addMoney('bank', payment , "mackerel-sell")
			Player.Notify('Pesca', "Vediste una caballa por $"..payment, "success")
			TriggerClientEvent("doj:client:SellLegalFish", source)
		else
		    Player.Notify('Pesca', "No tienes caballas para vender", "error")
		end
	elseif args == 2 then
		local have, codfish = Player.getItem("codfish")
		if have then
			local payment = Config.codfishPrice
			Player.removeItemFromInventory("codfish", 1, codfish.slotId)
			Player.addMoney('bank', payment , "codfish-sell")
			Player.Notify('Pesca', "Vediste un bacalao por $"..payment, "success")
			TriggerClientEvent("doj:client:SellLegalFish", source)
		else
		    Player.Notify('Pesca', "No tienes un bacalao para vender", "error")
		end
	elseif args == 3 then
		local have, bass = Player.getItem("bass")
		if have then
			local payment = Config.bassPrice
			Player.removeItemFromInventory("bass", 1, bass.slotId)
			Player.addMoney('bank', payment , "bass-sell")
			Player.Notify('Pesca', "Vendiste una lubina por $"..payment, "success")
			TriggerClientEvent("doj:client:SellLegalFish", source)
		else
			Player.Notify('Pesca', "No tienes ninguna lubina para vender", "error")
		end
	elseif args == 4 then
		local have, flounder = Player.getItem("flounder")
		if have then
			local payment = Config.flounderPrice
			Player.removeItemFromInventory("flounder", 1, flounder.slotId)
			Player.addMoney('bank', payment , "flounder-sell")
			Player.Notify('Pesca', "Vendiste un lenguado por $"..payment, "success")
			TriggerClientEvent("doj:client:SellLegalFish", source)
		else
		    Player.Notify('Pesca', "No tienes ningun lenguado para vender", "error")
		end
	else
		local have, stingray = Player.getItem("stingray")
		if have then
			local payment = Config.stingrayPrice
			Player.removeItemFromInventory("stingray", 1, stingray.slotId)
			Player.addMoney('bank', payment , "stingray-sell")
			Player.Notify('Pesca', "Vendiste una mantarraya por $"..payment, "success")
			TriggerClientEvent("doj:client:SellLegalFish", source)
		else
		    Player.Notify('Pesca', "No tienes ninguna mantarraya para vender", "error")
		end
	end
end)

RegisterNetEvent('fishing:server:BuyFishingGear', function(args)
	local src = source
    local Player = W.GetPlayer(src)
	local args = tonumber(args)
	local bankBalance = Player.getMoney('bank')

	if args == 1 then 
		if bankBalance >= Config.fishingBaitPrice then
			Player.removeMoney('bank', Config.fishingBaitPrice, "fishbait")
			Player.addItemToInventory('fishbait', 1)
			TriggerClientEvent("doj:client:buyFishingGear", source)
		else
			Player.Notify('Pesca', "No tienes suficiente dinero..", "error")
		end
	elseif args == 2 then 
		if bankBalance >= Config.fishingRodPrice then
			Player.removeMoney('bank', Config.fishingRodPrice, "fishingrod")
			Player.addItemToInventory('fishingrod', 1)
			TriggerClientEvent("doj:client:buyFishingGear", source)
		else
			Player.Notify('Pesca', "No tienes suficiente dinero..", "error")
		end
	elseif args == 3 then 
		if bankBalance >= Config.BoatAnchorPrice then
			Player.removeMoney('bank', Config.BoatAnchorPrice, "anchor")
			Player.addItemToInventory('anchor', 1)
			TriggerClientEvent("doj:client:buyFishingGear", source)
		else
			Player.Notify('Pesca', "No tienes suficiente dinero..", "error")
		end
	end
end)

W.CreateCallback('fishing:server:checkMoney', function(source, cb)
    local src = source
    local pData = W.GetPlayer(src)
    local bankBalance = pData.getMoney('bank')
	local price = Config.BoatPrice

    if bankBalance >= price then
        pData.removeMoney('bank', Config.BoatPrice)
		pData.Notify('Pesca', "El barco ha sido alquilado por $"..price, 'verify')
        cb(true)
    else
		pData.Notify('Pesca', 'No tienes dinero suficiente', 'error')
        cb(false)
    end
end)
