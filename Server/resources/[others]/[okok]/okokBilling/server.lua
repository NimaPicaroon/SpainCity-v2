local W = exports.ZCore:get()

local Webhook = 'https://discordapp.com/api/webhooks/'
local limiteTimeHours = Config.LimitDateDays*24
local hoursToPay = limiteTimeHours
local whenToAddFees = {}

for i = 1, Config.LimitDateDays, 1 do
	hoursToPay = hoursToPay - 24
	table.insert(whenToAddFees, hoursToPay)
end

W.CreateCallback("okokBilling:GetInvoices", function(source, cb)
	local xPlayer = W.GetPlayer(source)

	MySQL.Async.fetchAll('SELECT * FROM okokBilling WHERE receiver_identifier = @identifier ORDER BY CASE WHEN status = "unpaid" THEN 1 WHEN status = "autopaid" THEN 2 WHEN status = "paid" THEN 3 WHEN status = "cancelled" THEN 4 END ASC, id DESC', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local invoices = {}

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
			end
		end

		cb(invoices)
	end)
end)

W.CreateCallback("okokBilling:PayInvoice", function(source, cb,invoice_id)
	local xPlayer = W.GetPlayer(source)

	MySQL.Async.fetchAll('SELECT * FROM okokBilling WHERE id = @id', {
		['@id'] = invoice_id
	}, function(result)
		local invoices = result[1]
		local playerMoney = xPlayer.getMoney('bank')

		invoices.invoice_value = math.ceil(invoices.invoice_value)

		if playerMoney == nil then
			playerMoney = 0
		end

		if playerMoney < invoices.invoice_value then
			xPlayer.Notify('Facturas', 'No tienes dinero suficiente para pagar esta factura', 'error')
			cb(false)
		else
			xPlayer.removeMoney('bank', invoices.invoice_value)
			-- TriggerEvent("esx_addonaccount:getSharedAccount", invoices.society, function(account)
			-- 	if account ~= nil then
			-- 		account.addMoney(invoices.invoice_value)
			-- 	end
			-- end)

			MySQL.Async.execute('UPDATE okokBilling SET status = @status, paid_date = CURRENT_TIMESTAMP WHERE id = @id', {
				['@status'] = 'paid',
				['@id'] = invoice_id
			})

			xPlayer.Notify('Facturas', 'Has pagado la factura', 'verify')
			cb(true)
		end
	end)
end)

RegisterNetEvent('okokBilling:GetInvoices', function(identifier, callback)
	MySQL.Async.fetchAll('SELECT * FROM okokBilling WHERE receiver_identifier = @identifier ORDER BY CASE WHEN status = "unpaid" THEN 1 WHEN status = "autopaid" THEN 2 WHEN status = "paid" THEN 3 WHEN status = "cancelled" THEN 4 END ASC, id DESC', {
		['@identifier'] = identifier
	}, function(result)
		local invoices = {}

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
			end
		end

		callback(invoices)
	end)
end)

RegisterServerEvent("okokBilling:PayInvoice")
AddEventHandler("okokBilling:PayInvoice", function(invoice_id)
	local xPlayer = W.GetPlayer(source)

	MySQL.Async.fetchAll('SELECT * FROM okokBilling WHERE id = @id', {
		['@id'] = invoice_id
	}, function(result)
		local invoices = result[1]
		local playerMoney = xPlayer.getMoney('bank')

		invoices.invoice_value = math.ceil(invoices.invoice_value)

		if playerMoney == nil then
			playerMoney = 0
		end

		if playerMoney < invoices.invoice_value then
			xPlayer.Notify('Facturas', 'No tienes dinero suficiente para pagar esta factura', 'error')
		else
			xPlayer.removeMoney('bank', invoices.invoice_value)
			-- TriggerEvent("esx_addonaccount:getSharedAccount", invoices.society, function(account)
			-- 	if account ~= nil then
			-- 		account.addMoney(invoices.invoice_value)
			-- 	end
			-- end)

			MySQL.Async.execute('UPDATE okokBilling SET status = @status, paid_date = CURRENT_TIMESTAMP WHERE id = @id', {
				['@status'] = 'paid',
				['@id'] = invoice_id
			})

			xPlayer.Notify('Facturas', 'Has pagado la factura', 'verify')
		end
	end)
end)





RegisterServerEvent("okokBilling:CancelInvoice")
AddEventHandler("okokBilling:CancelInvoice", function(invoice_id)
	local xPlayer = W.GetPlayer(source)

	MySQL.Async.fetchAll('SELECT * FROM okokBilling WHERE id = @id', {
		['@id'] = invoice_id
	}, function(result)
		local invoices = result[1]
		MySQL.Async.execute('UPDATE okokBilling SET status = "cancelled", paid_date = CURRENT_TIMESTAMP WHERE id = @id', {
			['@id'] = invoice_id
		})
		xPlayer.Notify('Facturas', 'Has cancelado la factura', 'warn')
	end)
end)

RegisterServerEvent("okokBilling:CreateInvoice")
AddEventHandler("okokBilling:CreateInvoice", function(data)
	local _source = W.GetPlayer(source)
	local target = W.GetPlayer(data.target)
	local webhookData = {}

	if not target then
		return
	end

	if Config.LimitDate then
		MySQL.Async.insert('INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES (@receiver_identifier, @receiver_name, @author_identifier, @author_name, @society, @society_name, @item, @invoice_value, @status, @notes, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL @limit_pay_date DAY))', {
			['@receiver_identifier'] = target.identifier,
			['@receiver_name'] = target.identity.name..' '..target.identity.lastname,
			['@author_identifier'] = _source.identifier,
			['@author_name'] = _source.identity.name..' '.._source.identity.lastname,
			['@society'] = data.society,
			['@society_name'] = data.society_name,
			['@item'] = data.invoice_item,
			['@invoice_value'] = data.invoice_value,
			['@status'] = "unpaid",
			['@notes'] = data.invoice_notes,
			['@limit_pay_date'] = Config.LimitDateDays
		}, function(result)
			target.Notify('Facturas', 'Has recibido una nueva factura', 'warn')
		end)
	else
		MySQL.Async.insert('INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES (@receiver_identifier, @receiver_name, @author_identifier, @author_name, @society, @society_name, @item, @invoice_value, @status, @notes, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL @limit_pay_date DAY))', {
			['@receiver_identifier'] = target.identifier,
			['@receiver_name'] = target.identity.name..' '..target.identity.lastname,
			['@author_identifier'] = _source.identifier,
			['@author_name'] = _source.identity.name..' '.._source.identity.lastname,
			['@society'] = data.society,
			['@society_name'] = data.society_name,
			['@item'] = data.invoice_item,
			['@invoice_value'] = data.invoice_value,
			['@status'] = "unpaid",
			['@notes'] = data.invoice_notes,
			['@limit_pay_date'] = 'N/A'
		}, function(result)
			target.Notify('Facturas', 'Has recibido una nueva factura', 'warn')
		end)
	end
end)

W.CreateCallback("okokBilling:GetSocietyInvoices", function(source, cb, society)
	local xPlayer = W.GetPlayer(source)

	MySQL.Async.fetchAll('SELECT * FROM okokBilling WHERE society_name = @society ORDER BY id DESC', {
		['@society'] = society
	}, function(result)
		local invoices = {}
		local totalInvoices = 0
		local totalIncome = 0
		local totalUnpaid = 0
		local awaitedIncome = 0

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
				totalInvoices = totalInvoices + 1

				if result[i].status == 'paid' then
					totalIncome = totalIncome + result[i].invoice_value
				elseif result[i].status == 'unpaid' then
					awaitedIncome = awaitedIncome + result[i].invoice_value
					totalUnpaid = totalUnpaid + 1
				end
			end
		end
		cb(invoices, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
	end)
end)

function checkTimeLeft()
	MySQL.Async.fetchAll('SELECT *, TIMESTAMPDIFF(HOUR, limit_pay_date, CURRENT_TIMESTAMP()) AS "timeLeft" FROM okokBilling WHERE status = @status', {
		['@status'] = 'unpaid'
	}, function(result)
		for k, v in ipairs(result) do
			local invoice_value = v.invoice_value * (Config.FeeAfterEachDayPercentage / 100 + 1)
			print(json.encode(v))
			if v.timeLeft < 0 and Config.FeeAfterEachDay then
				for k, vl in pairs(whenToAddFees) do
					if v.fees_amount == k - 1 then
						if v.timeLeft >= vl*(-1) then
							MySQL.Async.execute('UPDATE okokBilling SET fees_amount = @fees_amount, invoice_value = @invoice_value WHERE id = @id', {
								['@fees_amount'] = k,
								['@invoice_value'] = v.invoice_value * (Config.FeeAfterEachDayPercentage / 100 + 1),
								['@id'] = v.id
							})
						end
					end
				end
			elseif v.timeLeft >= 0 and Config.PayAutomaticallyAfterLimit then
				local xPlayer = W.GetPlayerByIdentifier(v.receiver_identifier)
				local webhookData = {
					id = v.id,
					player_name = v.receiver_name,
					value = v.invoice_value,
					item = v.item,
					society = v.society_name
				}

				if xPlayer == nil then
					MySQL.Async.fetchAll('SELECT money FROM players WHERE token = @id', {
						['@id'] = v.receiver_identifier
					}, function(account)
						local playerAccount = json.decode(account[1].money)
						playerAccount.bank = playerAccount.bank - invoice_value
						playerAccount = json.encode(playerAccount)

						MySQL.Async.execute('UPDATE players SET money = @playerAccount WHERE token = @target', {
							['@playerAccount'] = playerAccount,
							['@target'] = v.receiver_identifier
						}, function(changed)
							-- TriggerEvent("esx_addonaccount:getSharedAccount", v.society, function(account2)
							-- 	if account2 ~= nil then
							-- 		account2.addMoney(invoice_value)
							-- 		MySQL.Async.execute('UPDATE okokBilling SET status = @paid, paid_date = CURRENT_TIMESTAMP() WHERE id = @id', {
							-- 			['@paid'] = 'autopaid',
							-- 			['@id'] = v.id
							-- 		})
							-- 	end
							-- end)
						end)
					end)
				else
					xPlayer.removeMoney('bank', invoice_value)
					-- TriggerEvent('esx_addonaccount:getSharedAccount', v.society, function(account2)
					-- 	if account2 ~= nil then
					-- 		account2.addMoney(invoice_value)
					-- 	end
					-- end)

					MySQL.Async.execute('UPDATE okokBilling SET status = @paid, paid_date = CURRENT_TIMESTAMP() WHERE id = @id', {
						['@paid'] = 'autopaid',
						['@id'] = v.id
					})
				end
			end
		end
	end)
	SetTimeout(0.5 * 60000, checkTimeLeft)
end

if Config.PayAutomaticallyAfterLimit then
	checkTimeLeft()
end