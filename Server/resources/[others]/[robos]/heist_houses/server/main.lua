local webhook = 'https://discordapp.com/api/webhooks/' -- Your Discord webhook for logs.

-- This is the door location, you can add as many as you want. The server will pick one randomly on every script start
local doorLocation = {
	{2728.46, 4142.1, 44.29},
}

--[[
	↓↓↓ DON'T CHANGE ANYTHING FROM HERE ↓↓↓
]]--

local x,y,z
local cooldown = 0
local esperar, puerta, iniciado = false, false, false
local wait = 10000
local num = 0 
local cooldownTimer = {}
local props = {
	['prop_micro_01'] = {item = 'microwave'},
	['prop_coffee_mac_02'] = {item = 'coffeemaker'},
}

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then		 
		local ubicacion = math.random(1, #doorLocation)		
		local coord = doorLocation[ubicacion]
		num = math.random(111,999)
		x, y, z = coord[1], coord[2], coord[3]
		--print('^2[AV House Robbery]:^7 '..x..' '..y..' '..z)
		iniciado = true
	end
end)

Citizen.CreateThread(function()
	while not iniciado do
		Citizen.Wait(10)
	end

	W = exports.ZCore:get()

	W.CreateCallback('heist_houses:entrada', function(source, cb)		
		cb(x,y,z,num)
	end)		

	W.CreateCallback('heist_houses:lockpick', function(source, callback)
		local src = source
		local ply = W.GetPlayer(src)
		local hasItem, item = ply.getItem(Config.LockpickName)

		if hasItem and (item and tonumber(item.quantity) >= 1) then
			table.insert(cooldownTimer, {identifier = ply.identifier, time = Config.CdTime})

			ply.removeItemFromInventory(Config.LockpickName, 1, item.slotId)
			W.SendToDiscord("robbery", "CASAS", 'Ha comenzad el robo a una casa', src)
			return callback(true)
		end

		return callback(false)
	end)

	W.CreateCallback('heist_houses:trabajos', function(source, callback)
		local src = source
		local ply = W.GetPlayer(src)

		if not CheckCooldownTimer(ply.identifier) then
			return callback(true)
		end

		return callback(false)
	end)
end)

RegisterServerEvent('heist_houses:item')
AddEventHandler('heist_houses:item', function(tipo,m)
	if m ~= num then 
		local usuario = GetPlayerName(source)
		local content = {
			{
				["color"] = '5015295',
				["title"] = "**Lua Injector**",
				["description"] = "**".. usuario .."** got caugh cheating :)",
				["footer"] = {
					["text"] = "AV House Robbery",
				},
			}
		}
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = usuario, embeds = content}), { ['Content-Type'] = 'application/json' })
		DropPlayer(source,'[Anticheat] Exploit trigger detected')
		return 
	end	

	local src = source
	local ply = W.GetPlayer(src)

	if tipo == 'random' then
		local random = math.random(20, 50)

		ply.addMoney('money', random)
		ply.Notify('Robo', Config.Lang['money_found']..random, 'info')
	elseif tipo == 'cajafuerte' then
		local random = math.random(20, 50)

		ply.addMoney('money', random)
		ply.Notify('Robo', Config.Lang['money_found']..random, 'info')
	elseif tipo == 'tv' then
		ply.addItemToInventory('tv',1)
	elseif tipo == 'telescopio' then
		ply.addItemToInventory('telescope',1)
	elseif tipo == 'arte' then
		ply.addItemToInventory('art',1)
	elseif tipo == 'laptop' then
		ply.addItemToInventory('laptop',1)
	else
		local item = props[tipo].item
		ply.addItemToInventory(item,1)
	end
end)

RegisterServerEvent('heist_houses:policeCall')
AddEventHandler('heist_houses:policeCall', function(c)
	TriggerClientEvent('heist_houses:policiablip',-1,c)
end)

Citizen.CreateThread(function()
	while true do
		for k,v in pairs(cooldownTimer) do
			if v.time <= 0 then
				ResetCooldownTimer(v.identifier)
			else
				v.time = v.time - 1
			end
		end
		Citizen.Wait(30 * 60 * 1000)
	end
end)

function ResetCooldownTimer(source)
    for k,v in pairs(cooldownTimer) do
        if v.identifier == source then
            table.remove(cooldownTimer,k)
        end
    end
end

function CheckCooldownTimer(source)
    for k,v in pairs(cooldownTimer) do
        if v.identifier == source then
            return true
        end
    end
    return false
end