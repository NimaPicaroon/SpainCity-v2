creatednpcs = {}
plants = {}
plantsCoke = {}
visited = {}
OwnData = {}

RegisterNetEvent('ZCore:setJob', function(job, lastJob)
	OwnData.job = job

    if lastJob.name == "police" and OwnData.job and (OwnData.job.duty and OwnData.job.name ~= "police") then
		for k,v in pairs(creatednpcs) do
			DeleteEntity(v)
			creatednpcs[k] = nil
		end

		for k,v in pairs(plants) do
			DeleteEntity(v)
			table.remove(plants, k)
		end

		for k,v in pairs(plantsCoke) do
			DeleteEntity(v)
			table.remove(plantsCoke, k)
		end
    end
end)

RegisterNetEvent('ZCore:setGang', function(job, lastJob)
	OwnData.gang = job

    if not job.name then
		for k,v in pairs(creatednpcs) do
			DeleteEntity(v)
			creatednpcs[k] = nil
		end

		for k,v in pairs(plants) do
			DeleteEntity(v)
			table.remove(plants, k)
		end

		for k,v in pairs(plantsCoke) do
			DeleteEntity(v)
			table.remove(plantsCoke, k)
		end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
	  	for k,v in pairs(creatednpcs) do
			DeleteEntity(v)
			creatednpcs[k] = nil
		end

		for k,v in pairs(plants) do
			DeleteEntity(v)
			table.remove(plants, k)
		end

		for k,v in pairs(plantsCoke) do
			DeleteEntity(v)
			table.remove(plantsCoke, k)
		end
	end
end)

RegisterNetEvent('Ox-Drugs:sellItems', function()
	W.TriggerCallback('Wave:GetPlayersJob', function(players)
		if players and #players >= 3 then
			W.TriggerCallback("Ox-Drugs:sellMyItems", function (selled, payed)
				if selled then
					W.Notify('Harrison', 'Has recibido ~r~$'..payed..'~w~ por tus objetos')
				else
					W.Notify('Harrison', '~r~No~w~ tienes nada que me interese')
				end
			end)
		else
			W.Notify('Venta Droga', 'No hay policías suficientes de servicio para vender.', 'error')
		end
	end, 'police', true)
end)

RegisterNetEvent('Ox-Drugs:sellDrugs', function()
	W.TriggerCallback('Wave:GetPlayersJob', function(players)
		if players and #players >= 3 then
			W.TriggerCallback("Ox-Drugs:sellMyDrugs", function (selled, payed, droga)
				if selled then
					W.Notify('Gisela', 'Has recibido ~r~'..payed..'€~w~ por tu '..droga)
				else
					W.Notify('Gisela', '~r~No~w~ tienes nada que me interese')
				end
			end)
		else
			W.Notify('Venta Droga', 'No hay policías suficientes de servicio para vender.', 'error')
		end
	end, 'police', true)
end)

RegisterNetEvent('Ox-Drugs:buyItems', function(type)
	W.OpenMenu("Tienda", "shop_menu", Config.Items[type], function (data, name)
		W.DestroyMenu(name)

		W.OpenDialog("Cantidad", "dialog_qua", function(amount)
			W.CloseDialog()
			amount = tonumber(amount)
			local money = W.GetPlayerData().money.money
			if data.blackmoney then
				money = W.GetPlayerData().money.money
			end
			if money >= (amount  * data.price) then
				TriggerServerEvent('Ox-Drugs:buyItemHaha', data.name, amount, data.price, data.blackmoney)
			else
				W.Notify('TIENDA', '~r~No~w~ tienes suficiente dinero', 'error')
			end
		end)
	end)
end)

local inAction = false

Table = function (object)
	if inAction then return end
	local elements = {
		{label = "<span style='color: green;'>Marihuana</span>", drug = "weed"},
		{label = "<span style='color: yellow;'>Hachís</span>", drug = "hachis"},
		{label = "<span style='color: grey;'>Opio</span>", drug = "opium"},
		{label = "<span style='color: pink;'>Lean</span>", drug = "lean"},
		{label = "<span style='color: purple;'>Éxtasis</span>", drug = "extasis"},
		{label = "Cocaína", drug = "coke"},
	}
	W.OpenMenu("Drogas", "drugs_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.drug then
			Wait(200)
			Procces(data.drug)
		end
	end)
end

Procces = function (type)
	if type == 'weed' then
		elements = {
			{label = "Cortar rama de maría", item = "ramas_marihuana", itemCount = 1, weaponNeeded = "WEAPON_KNIFE", reward = "cogollos_marihuana", amount = math.random(12,16), drug = "weed"},
			{label = "Embolsar maría", item = "cogollos_marihuana", itemCount = 3, itemNeeded = "bolsa_hermetica", removeNeeded = 1, itemNeeded2 = "balanza", removeNeeded2 = 0, reward = "bolsa_marihuana", amount = 1, drug = "weed"},
		}
	elseif type == "opium" then
		elements = {
			{label = "Machacar cristales de opio", item = "cristal_opio", itemCount = 1, itemNeeded = "mortero", removeNeeded = 0, reward = "opio_triturado", amount = math.random(10,14), drug = "opium"},
			{label = "Embolsar opio", item = "opio_triturado", itemCount = 3, itemNeeded = "bolsa_hermetica", removeNeeded = 1, itemNeeded2 = "balanza", removeNeeded2 = 0, reward = "bolsa_opio", amount = 1, drug = "opium"},
		}
	elseif type == "hachis" then
		elements = {
			{label = "Trozear hoja de hachís con el tamiz", item = "hoja_hachis", itemCount = 1, itemNeeded = "tamiz", removeNeeded = 0, reward = "hoja_polvo", amount = 5, drug = "hachis"},
			{label = "Cortar bloque de hachís", item = "bloque_hachis", itemCount = 1, weaponNeeded = "WEAPON_KNIFE", reward = "hachis", amount = math.random(10,14), drug = "hachis"},
			{label = "Embolsar hachís", item = "hachis", itemCount = 3, itemNeeded = "bolsa_hermetica", removeNeeded = 1, itemNeeded2 = "balanza", removeNeeded2 = 0, reward = "bolsa_hachis", amount = 1, drug = "hachis"},
		}
	elseif type == "lean" then
		elements = {
			{label = "Crear lean", item = "sprunk", itemCount = 1, itemNeeded = "codeina", removeNeeded = 1, reward = "lean", amount = 5, drug = "lean"},
		}
	elseif type == "extasis" then
		elements = {
			{label = "Crear bote de éxtasis", item = "extasis", itemCount = 1, itemNeeded = "bote_vacio", removeNeeded = 1, reward = "bote_extasis", amount = 3, drug = "extasis"},
		}
	else
		elements = {
			{label = "Picar hojas de cocalero", item = "hoja_cocalero", itemCount = 1, itemNeeded = "mortero", removeNeeded = 0, reward = "cocalero_troceado", amount = math.random(10,15), drug = "coke"},
			{label = "Embolsar coca", item = "clorhidrato_coca", itemCount = 3, itemNeeded = "bolsa_hermetica", removeNeeded = 1, itemNeeded2 = "cocalero_troceado", removeNeeded2 = 3, reward = "chivato_coca", amount = 1, drug = "coke"},
		}
	end
	W.OpenMenu("Elige que quieres hacer", "drugs2_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.item then
			local myData = {
				itemNeeded = {},
				itemNeeded2 = {},
				item = {}
			}
			if data.itemNeeded then
				local have, itemNeeded = W.HaveItem(data.itemNeeded)
				myData.itemNeeded = itemNeeded
				if have < data.removeNeeded then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end
			end
			if data.itemNeeded2 then
				local have, itemNeeded2 = W.HaveItem(data.itemNeeded2)
				myData.itemNeeded2 = itemNeeded2
				if have < data.removeNeeded2 then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end
			end
			if data.item then
				local have, item = W.HaveItem(data.item)
				myData.item = item
				if have < data.itemCount then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return end
			end
			if data.weaponNeeded then
				if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey(data.weaponNeeded) then W.Notify('DROGAS', '~r~No~w~ tienes lo necesario para hacerlo', 'error') return  end
			end
			inAction = true
			W.Progressbar("drugs", 'Realizando acción...', 3000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = true,
                disableCombat = true,
            }, {
				animDict = 'mini@repair',
				anim = 'fixing_a_ped'
			}, {}, {}, function() -- Done
				W.TriggerCallback('thief:isBeenSteal', function(result)
					if not result then
						ClearPedTasks(PlayerPedId())
						TriggerServerEvent('Ox-Drugs:drugAction', data, myData)
						inAction = false
						Wait(200)
						Procces(type)
					else
						ClearPedTasks(PlayerPedId())
						W.Notify("ERROR", 'Te estan cacheando', 'error')
					end
				end, GetPlayerServerId(PlayerId()))
            end, function()
                W.Notify('DROGAS', 'Has cancelado la acción', 'error')
                inAction = false
				ClearPedTasks(PlayerPedId())
            end)
		end
	end)
end

RegisterNetEvent('Ox-Drugs:drugTable', Table)

RegisterNetEvent('Ox-Drugs:goSite', function(type)
	W.Notify('DROGATA', Config.Texts[type])
	if type == 'hachis' and not visited[type] then
		Hachis()
	end
	visited[type] = true
end)