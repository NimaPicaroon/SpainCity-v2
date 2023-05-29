recolect = {}

W.CreateCallback('Ox-Drugs:getOrder', function(source, cb, type)
	local player = W.GetPlayer(source)

    MySQL.Async.fetchAll("SELECT * FROM drugs_orders WHERE gang = @gang AND type = @type",
	{
		['@gang'] = player.gang.name,
		['@type'] = type
	}, function(result)
        if result and result[1] then
			if result[1].time < tonumber(os.time()) then
				cb(true)
			else
				cb(result[1].time - tonumber(os.time()))
			end
		else
			cb(nil)
        end
    end)
end)

RegisterServerEvent('Ox-Drugs:buyItemHaha', function(item, count, money, black)
	local player = W.GetPlayer(source)

	if item == 'resina_adormidera' then
		if player.canHoldItem(item, count) then
			local metadata = W.DefaultMetadata[item] or false

			if player.addItemToInventory(item, count, metadata) then
				recolect[player.gang.name].count['opium'] = recolect[player.gang.name].count['opium'] + count
				updateShop(recolect[player.gang.name])
			end
		end
	elseif item == 'hoja_cocalero' then
		if player.canHoldItem(item, count) then
			local metadata = W.DefaultMetadata[item] or false

			if player.addItemToInventory(item, count, metadata) then
				recolect[player.gang.name].count['coke'] = recolect[player.gang.name].count['coke'] + count
				updateShop(recolect[player.gang.name])
			end
		end
	else
		if player.canHoldItem(item, count) then
			local metadata = W.DefaultMetadata[item] or false

			if player.addItemToInventory(item, count, metadata) then
				if money then
					W.SendToDiscord('gangs', "COMPRA DROGAS", 'x'..count..' '..GlobalState.Items[item].label..' por $'..money * count.." para la banda "..player.gang.label, source)
					player.removeMoney("money", money * count)
				end
			end
		end
	end
end)

RegisterServerEvent('Ox-Drugs:giveItem', function(item, count, money, black)
	local player = W.GetPlayer(source)

	if item == 'resina_adormidera' then
		if player.canHoldItem(item, count) then
			local metadata = W.DefaultMetadata[item] or false

			player.addItemToInventory(item, count, metadata)
			recolect[player.gang.name].count['opium'] = recolect[player.gang.name].count['opium'] + count
			updateShop(recolect[player.gang.name])
		end
	elseif item == 'hoja_cocalero' then
		if player.canHoldItem(item, count) then
			local metadata = W.DefaultMetadata[item] or false

			player.addItemToInventory(item, count, metadata)
			recolect[player.gang.name].count['coke'] = recolect[player.gang.name].count['coke'] + count
			updateShop(recolect[player.gang.name])
		end
	else
		if player.canHoldItem(item, count) then
			local metadata = W.DefaultMetadata[item] or false

			if metadata ~= false then
				player.addItemToInventory(item, count, metadata)
			else
				player.addItemToInventory(item, count, metadata)
			end
			if money then
				W.SendToDiscord('crafteos', "COMPRA", GetPlayerName(source)..' ha comprado x'..count..' '..GlobalState.Items[item].label..' por $'..money or 'Desconocido'..'.', source)
				W.Print(GetPlayerName(source)..' ha comprado x'..count..' '..item)
				player.removeMoney("money", money * count)
			end
		end
	end
end)

W.CreateCallback("Ox-Drugs:sellMyItems", function (src, cb)
	local player = W.GetPlayer(src)
	local a, rolex = player.getItem('rolex')
	local a, ring = player.getItem('ring')
	local a, necklace = player.getItem('necklace')
	local a, vanDiamond = player.getItem('vanDiamond')
	local a, paintingg = player.getItem('paintingg')
	local a, paintingf = player.getItem('paintingf')
	local a, paintingj = player.getItem('paintingj')
	local a, paintingh = player.getItem('paintingh')

	local houses, tv = player.getItem('tv')
	local houses, telescope = player.getItem('telescope')
	local houses, art = player.getItem('art')
	local houses, laptop = player.getItem('laptop')

	local selled = false
	local payed = 0

	if tv and tv.quantity > 0 then
		local pay = 450 * tv.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(tv.item, tv.quantity, tv.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA TV", "Vendió x" ..tv.quantity.. " televisores por $" ..payed  , source)

	elseif telescope and telescope.quantity > 0 then
		local pay = 400 * telescope.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(telescope.item, telescope.quantity, telescope.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA TELESCOPIO", "Vendió x" ..telescope.quantity.. " telescopios por $" ..payed  , source)

	elseif art and art.quantity > 0 then
		local pay = 650 * art.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(art.item, art.quantity, art.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA PINTURA", "Vendió x" ..art.quantity.. " pinturas por $" ..payed  , source)

	elseif laptop and laptop.quantity > 0 then
		local pay = 400 * laptop.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(laptop.item, laptop.quantity, laptop.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA PORTATIL", "Vendió x" ..laptop.quantity.. " portatiles por $" ..payed  , source)

	elseif rolex and rolex.quantity > 0 then
		local pay = Config.Prices["rolex"] * rolex.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(rolex.item, rolex.quantity, rolex.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA ROLEX", "Vendió x" ..rolex.quantity.. " rolex por $" ..payed  , source)

	elseif ring and ring.quantity > 0 then
		local pay = Config.Prices["ring"] * ring.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(ring.item, ring.quantity, ring.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA ANILLOS", "Vendió x" ..ring.quantity.. " anillos por $" ..payed  , source)

	elseif necklace and necklace.quantity > 0 then
		local pay = Config.Prices["necklace"] * necklace.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(necklace.item, necklace.quantity, necklace.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA COLLARES", "Vendió x" ..necklace.quantity.. " collares por $" ..payed  , source)

	elseif vanDiamond and vanDiamond.quantity > 0 then
		local pay = Config.Prices["vanDiamond"] * vanDiamond.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(vanDiamond.item, vanDiamond.quantity, vanDiamond.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA DIAMANTE", "Vendió x" ..vanDiamond.quantity.. " diamantes por $" ..payed  , source)

	elseif paintingg and paintingg.quantity > 0 then
		local pay = Config.Prices["paintingg"] * paintingg.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(paintingg.item, paintingg.quantity, paintingg.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA CUADRO 1", "Vendió x" ..paintingg.quantity.. " cuadros por $" ..payed  , source)

	elseif paintingf and paintingf.quantity > 0 then
		local pay = Config.Prices["paintingf"] * paintingf.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(paintingf.item, paintingf.quantity, paintingf.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA CUADRO 2", "Vendió x" ..paintingf.quantity.. " cuadros por $" ..payed  , source)

	elseif paintingj and paintingj.quantity > 0 then		
		local pay = Config.Prices["paintingj"] * paintingj.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(paintingj.item, paintingj.quantity, paintingj.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA CUADRO 4", "Vendió x" ..paintingj.quantity.. " cuadros por $" ..payed  , source)
	elseif paintingh and paintingh.quantity > 0 then
		local pay = Config.Prices["paintingh"] * paintingh.quantity
		player.addMoney("money", pay)
		player.removeItemFromInventory(paintingh.item, paintingh.quantity, paintingh.slotId)
		payed = payed + pay
		selled = true
		W.SendToDiscord("sell", "VENTA CUADRO 3", "Vendió x" ..paintingh.quantity.. " cuadros por $" ..payed  , source)
	end
	cb(selled, payed)
end)

W.CreateCallback("Ox-Drugs:sellMyDrugs", function (src, cb)
	local player = W.GetPlayer(src)
	local a, maria = player.getItem('bolsa_marihuana')
	local a, coca = player.getItem('chivato_coca')
	local a, hachis = player.getItem('bolsa_hachis')
	local a, opio = player.getItem('bolsa_opio')
	local a, lean = player.getItem('lean')
	local a, extasis = player.getItem('bote_extasis')
	local a, lsd = player.getItem('lsd')

	local selled = false
	local payed = 0

	if maria and maria.quantity > 0 then
		local pay = 80 
		player.addMoney("money", pay)
		player.removeItemFromInventory(maria.item, 1, maria.slotId)
		payed = payed + pay
		selled = true
		droga = "bolsa de marihuana"
		W.SendToDiscord("sell", "VENTA MARIA", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
	elseif coca and coca.quantity > 0 then
		local pay = 275 
		player.addMoney("money", pay)
		player.removeItemFromInventory(coca.item, 1, coca.slotId)
		payed = payed + pay
		selled = true
		droga = "chivato de coca"
		W.SendToDiscord("sell", "VENTA COCA", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
	elseif hachis and hachis.quantity > 0 then
		local pay = 110 
		player.addMoney("money", pay)
		player.removeItemFromInventory(hachis.item, 1, hachis.slotId)
		payed = payed + pay
		selled = true
		droga = "bolsa de hachis"
		W.SendToDiscord("sell", "VENTA HACHIS", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
	elseif opio and opio.quantity > 0 then
		local pay = 80 
		player.addMoney("money", pay)
		player.removeItemFromInventory(opio.item, 1, opio.slotId)
		payed = payed + pay
		selled = true
		droga = "bolsa de opio"
		W.SendToDiscord("sell", "VENTA OPIO", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
	elseif lean and lean.quantity > 0 then
		local pay = 185 
		player.addMoney("money", pay)
		player.removeItemFromInventory(lean.item, 1, lean.slotId)
		payed = payed + pay
		selled = true
		droga = "lean"
		W.SendToDiscord("sell", "VENTA LEAN", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
	elseif extasis and extasis.quantity > 0 then
		local pay = 200 
		player.addMoney("money", pay)
		player.removeItemFromInventory(extasis.item, 1, extasis.slotId)
		payed = payed + pay
		selled = true
		droga = "bote de extasis"
		W.SendToDiscord("sell", "VENTA EXTASIS", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
	elseif lsd and lsd.quantity > 0 then
		local pay = 300
		droga = "LSD"
		if lsd.quantity >=3 then
			local cantidad = math.random(1,3)
			player.addMoney("money", pay * cantidad)
			player.removeItemFromInventory(lsd.item, cantidad, lsd.slotId)
			payed = pay * cantidad
			selled = true
			player.Notify("Venta", "Vendiste x3 de LSD", "verify")
			W.SendToDiscord("sell", "VENTA LSD", "Vendió x"..cantidad.." "..droga.." por " ..payed.. "€"  , source)
		elseif lsd.quantity < 3 then
			player.addMoney("money", pay)
			player.removeItemFromInventory(lsd.item, 1, lsd.slotId)
			payed = payed + pay
			selled = true
			player.Notify("Venta", "Vendiste x1 de LSD", "verify")
			W.SendToDiscord("sell", "VENTA LSD", "Vendió x1 "..droga.." por " ..payed.. "€"  , source)
		end
	end
	cb(selled, payed, droga)
end)

W.CreateCallback("Ox-Drugs-buyHachis", function (src, cb, item, count, money, black)
	local player = W.GetPlayer(src)

	if player.canHoldItem(item, count) then
		local metadata = W.DefaultMetadata[item] or false

		player.addItemToInventory(item, count, metadata)
		recolect[player.gang.name].count['hachis'] = recolect[player.gang.name].count['hachis'] + count
		updateShop(recolect[player.gang.name])
		cb(true)
		if money then
			player.removeMoney("money", money * count)
		end
	else
		cb("No puedes llevar más")
	end
end)

RegisterServerEvent('Ox-Drugs:removeItem', function(item, count, slotId)
	local player = W.GetPlayer(source)
	player.removeItemFromInventory(item, count, slotId)
end)

RegisterServerEvent('Ox-Drugs:proccessResina')
AddEventHandler('Ox-Drugs:proccessResina', function(count, item)
	local player = W.GetPlayer(source)

	MySQL.Async.fetchAll("SELECT * FROM drugs_orders WHERE gang = @gang AND type = 'opium'",
	{
		['@gang'] = player.gang.name
	}, function(result)
        if result == nil or result[1] == nil then
			player.removeItemFromInventory('resina_adormidera', count, item.slotId)
			player.removeMoney("money", 200 * count)
			local timetogive = tonumber(os.time()) + 3600
			MySQL.Async.execute("INSERT INTO drugs_orders (type, gang, count, time) VALUES ('opium', @gang, @count, @time)",
			{
				['@gang'] = player.gang.name,
				['@time'] = timetogive,
				['@count'] = (count * 5)
			})
		else
			player.Notify('DESCONOCIDO', 'Ya tienes un pedido procesandose')
        end
    end)
end)

RegisterServerEvent('Ox-Drugs:giveProccessedResina')
AddEventHandler('Ox-Drugs:giveProccessedResina', function()
	local player = W.GetPlayer(source)

	MySQL.Async.fetchAll("SELECT * FROM drugs_orders WHERE gang = @gang AND type = 'opium'",
	{
		['@gang'] = player.gang.name
	}, function(result)
        if result and result[1] then
			if player.canHoldItem('cristal_opio', tonumber(result[1].count)) then
				local metadata = W.DefaultMetadata[item] or false
				player.addItemToInventory('cristal_opio', tonumber(result[1].count), metadata)
				MySQL.Async.execute("DELETE FROM drugs_orders WHERE gang = @job AND type = 'opium'",
				{
					['@job'] = player.gang.name
				})
				player.Notify('DESCONOCIDO','Toma tu pedido de ~y~'.. result[1].count .. '~w~ opio', 'verify')
			end
		else
			player.Notify('ERROR', 'Ha ocurrido un ~r~error', 'error')
        end
    end)
end)

RegisterServerEvent('Ox-Drugs:proccessHojas', function(count, item)
	local player = W.GetPlayer(source)

	MySQL.Async.fetchAll("SELECT * FROM drugs_orders WHERE gang = @gang AND type = 'hachis'",
	{
		['@gang'] = player.gang.name
	}, function(result)
        if result == nil or result[1] == nil then
			player.removeItemFromInventory('hoja_polvo', count, item.slotId)
			player.removeMoney("money", 16 * count)
			local timetogive = tonumber(os.time()) + 3600
			MySQL.Async.execute("INSERT INTO drugs_orders (type, gang, count, time) VALUES ('hachis', @gang, @count, @time)",
			{
				['@gang'] = player.gang.name,
				['@time'] = timetogive,
				['@count'] = (count * 2)
			})
		else
			player.Notify('DESCONOCIDO', 'Ya tienes un pedido procesandose')
        end
    end)
end)

RegisterServerEvent('Ox-Drugs:giveProccessedHojas', function()
	local player = W.GetPlayer(source)

	MySQL.Async.fetchAll("SELECT * FROM drugs_orders WHERE gang = @gang AND type = 'hachis'",
	{
		['@gang'] = player.gang.name
	}, function(result)
        if result and result[1] then
			if player.canHoldItem('resina_kief', tonumber(result[1].count)) then
				local metadata = W.DefaultMetadata[item] or false
				player.addItemToInventory('resina_kief', tonumber(result[1].count), metadata)
				MySQL.Async.execute("DELETE FROM drugs_orders WHERE gang = @job AND type = 'hachis'",
				{
					['@job'] = player.gang.name
				})
			end
		else
			player.Notify('ERROR', 'Ha ocurrido un ~r~error', 'error')
        end
    end)
end)

RegisterServerEvent('Ox-Drugs:proccessKief')
AddEventHandler('Ox-Drugs:proccessKief', function(count, item)
	local player = W.GetPlayer(source)

	if player.canHoldItem('bloque_hachis', tonumber(count/2)) then
		player.removeItemFromInventory('resina_kief', count, item.slotId)
		local metadata = W.DefaultMetadata[item] or false
		player.addItemToInventory('bloque_hachis', tonumber(count/2), metadata)
	end
end)

RegisterServerEvent('Ox-Drugs:drugAction', function(data, myData)
	local player = W.GetPlayer(source)
	if player.canHoldItem(data.reward, data.amount) then
		local metadata = W.DefaultMetadata[item] or false
		player.addItemToInventory(data.reward, data.amount, metadata)
		player.removeItemFromInventory(data.item, data.itemCount, myData.item.slotId)
		if data.removeNeeded and myData.itemNeeded then
			player.removeItemFromInventory(data.itemNeeded, data.removeNeeded, myData.itemNeeded.slotId)
		end
		if data.removeNeeded2 and myData.itemNeeded2 then
			player.removeItemFromInventory(data.itemNeeded2, data.removeNeeded2, myData.itemNeeded2.slotId)
		end
	end
	W.SendToDiscord('procesados', "Procesado droga", GetPlayerName(source)..' ha procesado droga y ha obtenido x'..data.amount.. ' '..data.reward, source)
end)