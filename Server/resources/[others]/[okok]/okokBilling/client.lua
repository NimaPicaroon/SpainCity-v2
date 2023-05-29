local W = exports.ZCore:get()

function MyInvoices()
	W.TriggerCallback("okokBilling:GetInvoices", function(invoices)
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'myinvoices',
			invoices = invoices,
			VAT = Config.VATPercentage
		})			
	end)
end

function SocietyInvoices(society)
	W.TriggerCallback("okokBilling:GetSocietyInvoices", function(cb, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
		if json.encode(cb) ~= '[]' then
			SetNuiFocus(true, true)
			SendNUIMessage({
				action = 'societyinvoices',
				invoices = cb,
				totalInvoices = totalInvoices,
				totalIncome = totalIncome,
				totalUnpaid = totalUnpaid,
				awaitedIncome = awaitedIncome,
				VAT = Config.VATPercentage
			})		
		else
			exports['okokNotify']:Alert("BILLING", "Your society doesn't have invoices.", 10000, 'info')
			SetNuiFocus(false, false)
		end
	end, society)
end

function CreateInvoice(society)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'createinvoice',
		society = society
	})
end

RegisterCommand(Config.InvoicesCommand, function()
	local playerData = W.GetPlayerData()
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == playerData.job.name then
			jobName = v
			isAllowed = true
		end
	end
	if isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
	-- if Config.OnlyBossCanAccessSocietyInvoices and playerData.job.grade_name == "boss" and isAllowed then
	-- 	SetNuiFocus(true, true)
	-- 	SendNUIMessage({
	-- 		action = 'mainmenu',
	-- 		society = true,
	-- 		create = true
	-- 	})
	-- elseif Config.OnlyBossCanAccessSocietyInvoices and playerData.job.grade_name ~= "boss" and isAllowed then
	-- 	SetNuiFocus(true, true)
	-- 	SendNUIMessage({
	-- 		action = 'mainmenu',
	-- 		society = false,
	-- 		create = true
	-- 	})
	-- elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
	-- 	SetNuiFocus(true, true)
	-- 	SendNUIMessage({
	-- 		action = 'mainmenu',
	-- 		society = true,
	-- 		create = true
	-- 	})
	-- elseif not isAllowed then
	-- 	SetNuiFocus(true, true)
	-- 	SendNUIMessage({
	-- 		action = 'mainmenu',
	-- 		society = false,
	-- 		create = false
	-- 	})
	-- end
end, false)

RegisterNUICallback("action", function(data, cb)
	local PlayerData = W.GetPlayerData()

	if data.action == "close" then
		SetNuiFocus(false, false)
	elseif data.action == "payInvoice" then
		TriggerServerEvent("okokBilling:PayInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "cancelInvoice" then
		TriggerServerEvent("okokBilling:CancelInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "createInvoice" then
		local closestPlayer, playerDistance = W.GetClosestPlayer()
		target = GetPlayerServerId(closestPlayer)
		data.target = target
		data.society = PlayerData.job.name
		data.society_name = PlayerData.job.label

		if closestPlayer == -1 or playerDistance > 3.0 then
			W.Notify('Facturas', 'No hay nadie cerca tuya', 'error')
		else
			TriggerServerEvent("okokBilling:CreateInvoice", data)
			W.Notify('Facturas', 'Has enviado la factura a tu jugador más cercano', 'warn')
		end
		
		SetNuiFocus(false, false)
	elseif data.action == "missingInfo" then
		W.Notify('Facturas', 'Rellena todos los campos antes de enviar otra factura', 'error')
	elseif data.action == "negativeAmount" then
		W.Notify('Facturas', 'La cantidad rellenada es negativa, debe ser mayor de 0.', 'error')
	elseif data.action == "mainMenuOpenMyInvoices" then
		MyInvoices()
	elseif data.action == "mainMenuOpenSocietyInvoices" then
		-- for k, v in pairs(Config.AllowedSocieties) do
		-- 	if v == PlayerData.job.name then
		-- 		if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name == "boss" then
		-- 			SocietyInvoices(PlayerData.job.label)
		-- 		elseif not Config.OnlyBossCanAccessSocietyInvoices then
		-- 			SocietyInvoices(PlayerData.job.label)
		-- 		elseif Config.OnlyBossCanAccessSocietyInvoices then
		-- 			exports['okokNotify']:Alert("BILLING", "Only the boss can access the society invoices.", 10000, 'error')
		-- 		end
		-- 	end
		-- end
	elseif data.action == "mainMenuOpenCreateInvoice" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				CreateInvoice(PlayerData.job.label)
			end
		end
	end
end)