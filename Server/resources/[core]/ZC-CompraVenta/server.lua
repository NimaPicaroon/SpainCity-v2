RegisterServerEvent('okokContract:changeVehicleOwner', function(data)
	_source = data.sourceIDSeller
	target = data.targetIDSeller
	plate = data.plateNumberSeller
	model = data.modelSeller
	source_name = data.sourceNameSeller
	target_name = data.targetNameSeller
	vehicle_price = tonumber(data.vehicle_price)
	local xPlayer = W.GetPlayer(_source)
	local tPlayer = W.GetPlayer(target)
	local seller = false
	local buyer = false

	if tPlayer.job.name == 'sandycar' then
		buyer = true
	end

	if xPlayer.job.name == 'sandycar' then
		seller = true
	end

	local TData = tPlayer.identifier
	local xData = xPlayer.identifier
	local societyAccount = {money = tPlayer.getMoney('bank')}

	if buyer then
		TData = 'society_sandycar'
		societyAccount = exports["Ox-Jobcreator"]:getJobData("sandycar")
	end

	if seller then
		xData = 'society_sandycar'
		larrysacc = exports["Ox-Jobcreator"]:getJobData("sandycar")
	end

	plate = plate:gsub("%s+", "")
	local vehicle = exports['ZC-Garages']:getVehicle(tostring(plate:gsub("%s+", "")))

	if not vehicle then
		return
	end

	if seller and buyer then
		xPlayer.Notify("INTERCAMBIO","No se pueden cambiar coches entre miembros del Sandy CARS de servicio", 'error')
		tPlayer.Notify("INTERCAMBIO","No se pueden cambiar coches entre miembros del Sandy CARS de servicio", 'error')
	else
		if tostring(vehicle.owner) == tostring(xData) then
			if societyAccount.money >= vehicle_price then
				vehicle:Owner().set(tostring(TData))
				vehicle:Garage().set('Deposito')
				local vehiclesData = exports['ZC-Garages']:getVehicles()

				if buyer then
					societyAccount.removeMoney(vehicle_price)
					xPlayer.addMoney('bank', vehicle_price)
					xPlayer.Notify("INTERCAMBIO","Has vendido correctamente el <b>"..model.."</b> con matrícula <b>"..plate.."</b>", 'verify')
					tPlayer.Notify("INTERCAMBIO","Has comprado correctamente el <b>"..model.."</b> con matrícula <b>"..plate.."</b>", 'verify')
					tPlayer.addItemToInventory('carkey', 1, { model = model:lower(), plate = plate })
				elseif seller then
					larrysacc.addMoney(vehicle_price)
					tPlayer.removeMoney('bank', vehicle_price)
					xPlayer.Notify("INTERCAMBIO","Has vendido correctamente el <b>"..model.."</b> con matrícula <b>"..plate.."</b>", 'verify')
					tPlayer.Notify("INTERCAMBIO","Has comprado correctamente el <b>"..model.."</b> con matrícula <b>"..plate.."</b>", 'verify')
					tPlayer.addItemToInventory('carkey', 1, { model = model:lower(), plate = plate })
				end

				TriggerClientEvent('garages:sync', tPlayer.src, vehiclesData)
				TriggerClientEvent('garages:sync', xPlayer.src, vehiclesData)
			else
				xPlayer.Notify("INTERCAMBIO",target_name.." no tiene suficiente dinero", 'error')
				tPlayer.Notify("INTERCAMBIO","No tienes suficiente dinero para comprar el vehículo", 'error')
			end
		else
			xPlayer.Notify("INTERCAMBIO", "El vehículo con matrícula <b>"..plate.."</b> no es tuyo", 'error')
			tPlayer.Notify("INTERCAMBIO", source_name.." te ha intentado vender un vehículo que no es suyo", 'error')
		end
	end
end)

W.CreateCallback('okokContract:GetTargetName', function(source, cb, targetid)
	local target = W.GetPlayer(targetid)
	local targetname = GetCharacterName(target)

	if target.job.name == 'sandycar' then
		targetname = targetname.. " - Sandy Car"
	end

	cb(targetname)
end)

RegisterServerEvent('okokContract:SendVehicleInfo')
AddEventHandler('okokContract:SendVehicleInfo', function(description, price)
	local _source = source
	local xPlayer = W.GetPlayer(_source)
	local name = GetCharacterName(xPlayer)

	if xPlayer.job.name == 'sandycar' then
		name = name.. " - Sandy Car"
	end

	TriggerClientEvent('okokContract:GetVehicleInfo', _source, name, os.date('%d-%m-%Y'), description, price, _source)
end)

function GetCharacterName(xPlayer)
	return ('%s %s'):format(xPlayer.identity.name, xPlayer.identity.lastname)
end

RegisterServerEvent('okokContract:SendContractToBuyer', function(data)
	TriggerClientEvent("okokContract:OpenContractOnBuyer", data.targetID, data)
	TriggerClientEvent('okokContract:startContractAnimation', data.targetID)
end)

RegisterServerEvent('larrys:openContract', function(source)
	TriggerClientEvent('okokContract:OpenContractInfo', source)
	TriggerClientEvent('okokContract:startContractAnimation', source)
end)

-- RESTOCK

local NumberCharset = {}
local Charset = {}
Utils = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function Utils.GeneratePlate()
	local generatedPlate
	math.randomseed(GetGameTimer())
	generatedPlate = string.upper(GetRandomLetter(3) .. GetRandomNumber(3))
	return generatedPlate
end

RegisterCommand("restock", function(src, args)
	local player = W.GetPlayer(src)
	if player.job and player.job.name == "sandycar" and player.job.duty then
		local model = args[1]
		if model then
			local data = exports["ZC-VehicleShop"]:getPrice(model)
			if data then
				local societyAccount = exports["Ox-Jobcreator"]:getJobData("sandycar")
				if societyAccount.money >= data.price then
					societyAccount.removeMoney(data.price)
					local id = exports['ZC-Garages']:newUUID()
					local plate = Utils.GeneratePlate()
					local car = {
						id = id,
						owner = 'society_sandycar',
						name = nil,
						model = model,
						vehicleshop = tostring(data.vehicleshop),
						plate = plate,
						stored = 1,
						vehicle = {},
						garage = "Garaje sandycar CARS"
					}
					exports.oxmysql:execute('INSERT INTO `owned_vehicles` (`id`, `owner`, `name`, `model`, `vehicleshop`, `plate`, `stored`, `vehicle`, `garage`) VALUES (?, ?, ?, ?,?, ?, ?, ?, ?)', {
						tostring(car.id),
						tostring(car.owner),
						car.name,
						tostring(car.model),
						tostring(car.vehicleshop),
						tostring(car.plate),
						tonumber(car.stored),
						json.encode(car.vehicle),
						tostring(car.garage)
					})
					local vehicle = exports['ZC-Garages']:createVehicle(car)
					local vehiclesData = exports['ZC-Garages']:getVehicles()
					TriggerClientEvent('garages:sync', player.src, vehiclesData)
					player.Notify("RESTOCK", "Vehículo añadido al ~y~garaje", "verify")
				else
					player.Notify("RESTOCK", "La ~y~sociedad~w~ no tiene tanto dinero", "error")
				end
			else
				player.Notify("RESTOCK", "Modelo no válido", "error")
			end
		else
			player.Notify("RESTOCK", "Introduce un ~y~modelo~w~ de vehículo", "error")
		end
	else
		player.Notify("RESTOCK", "No puedes usar esto", "error")
	end
end)

RegisterCommand("refreshstock", function(src, args)
	local player = W.GetPlayer(src)
	local vehiclesData = exports['ZC-Garages']:getVehicles()
	TriggerClientEvent('garages:sync', player.src, vehiclesData)
end)
-- local VehiclesColiseo = {
-- 	[1] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD001',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[2] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD002',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[3] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD003',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[4] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD004',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[5] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD005',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[6] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD006',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[7] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD007',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[8] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD008',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[9] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD009',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[10] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD010',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[11] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'faggio',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD011',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[12] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'faggio',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD012',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[13] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'faggio',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD013',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[14] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'pcj',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD014',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[15] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'blista',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD015',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[16] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'blista',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD016',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[17] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD017',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[18] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD018',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[19] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD019',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[20] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD020',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[21] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD021',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[22] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD022',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[23] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD023',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[24] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD024',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[25] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD025',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[26] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'asbo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD026',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[27] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'asbo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD027',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[28] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD028',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[29] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD029',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[30] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD030',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[31] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD031',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- }

-- VehiclesColiseo = {
-- 	[1] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'BMX001',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[2] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'BMX002',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[3] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'BMX003',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[4] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'BMX004',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[5] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'BMX005',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[6] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'bimx',
-- 		vehicleshop = 'CITY',
-- 		plate = 'BMX006',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[7] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD500',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[8] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD501',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[9] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD502',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[10] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD503',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[11] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD504',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[12] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'primo',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD505',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},

-- 	[13] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD506',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[14] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD506',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[15] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'premier',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD507',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},

-- 	[16] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'dilettante',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD508',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[17] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'dilettante',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD509',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[18] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'dilettante',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD5010',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[19] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'asea',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD5011',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[20] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'asea',
-- 		vehicleshop = 'CITY',
-- 		plate = 'MAD5012',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},

-- 	[21] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP001',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[22] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP002',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[23] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP003',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[24] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP004',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[25] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP005',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[26] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP006',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- 	[27] = {
-- 		id = exports['ZC-Garages']:newUUID(),
-- 		owner = 'society_madrazo',
-- 		name = nil,
-- 		model = 'emperor',
-- 		vehicleshop = 'CITY',
-- 		plate = 'EMP007',
-- 		stored = 1,
-- 		vehicle = {},
-- 		garage = "Garaje MADRAZO'S CARS"
-- 	},
-- }

-- Citizen.CreateThread(function()
-- 	Wait(2000)

-- 	for i = 1, #VehiclesColiseo do
-- 		exports.oxmysql:execute('INSERT INTO `owned_vehicles` (`id`, `owner`, `name`, `model`, `vehicleshop`, `plate`, `stored`, `vehicle`, `garage`) VALUES (?, ?, ?, ?,?, ?, ?, ?, ?)', {
-- 			tostring(VehiclesColiseo[i].id),
-- 			tostring(VehiclesColiseo[i].owner),
-- 			VehiclesColiseo[i].name,
-- 			tostring(VehiclesColiseo[i].model),
-- 			tostring(VehiclesColiseo[i].vehicleshop),
-- 			tostring(VehiclesColiseo[i].plate),
-- 			tonumber(VehiclesColiseo[i].stored),
-- 			json.encode(VehiclesColiseo[i].vehicle),
-- 			tostring(VehiclesColiseo[i].garage)
-- 		})
-- 	end
-- end)