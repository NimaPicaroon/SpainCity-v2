webhookUrl = 'https://discord.com/api/webhooks/1099082830887264306/YP29KjzvRSu0L8LgRjBNpEQy5W7mrX8IaxFuOFKUSZdW1SZfFs-R6Fl8vfC6aKEvWASI'
logschr7 = function(message)
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 
    'POST', json.encode(
        {username = "X", 
        embeds = {
            {["color"] = 16711680, 
            ["author"] = {
            ["name"] = "Dirección Logs",
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"},
            ["description"] = "".. message .."",
            ["footer"] = {
            ["text"] = "SpainCityRP - "..os.date("%x %X %p"),
            ["icon_url"] = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png",},}
        }, avatar_url = "https://media.discordapp.net/attachments/831490177104478208/1097705964385357874/SpainCityLogo.png"}), {['Content-Type'] = 'application/json' })
end

--Discord.lua
RegisterServerEvent("Discord:GetInfinityPlayerList", function()
    local l = 0
    local players = GetPlayers()

    for i, player in pairs(players) do
        l = l + 1
    end

	TriggerClientEvent("Discord:GetInfinityPlayerList", source, l)
end)

-- KickResolucion.lua
RegisterServerEvent("ZC-CustomScripts:Kick", function()
	DropPlayer(source, 'Usar resolución 4:3')
end)

-- Carry.lua

RegisterServerEvent('CarryPeople:sync')
AddEventHandler('CarryPeople:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('CarryPeople:stop')
AddEventHandler('CarryPeople:stop', function(targetSrc)
	TriggerClientEvent('CarryPeople:cl_stop', targetSrc)
end)

-- Vip.lua
local vips = {}

W.CreateCallback("ZC-CustomScripts:getVIPStatus", function(source, cb)
    local src = source
	local player = W.GetPlayer(src)
	player.vip = tonumber(player.vip)

	return cb(player.vip)
end)

AddEventHandler('ZCore:playerLoaded', function(source, player)
	local src = source
	local player = W.GetPlayer(src)

	if not player then
		return
	end

	player.vip = tonumber(player.vip)
	if not player.vip or player.vip <= 0 then
		vips[source] = '<b style=color:red>No obtenido</b>'
	else
		vips[source] = os.date("<b style=color:green>Obtenido</b> - " .. "%x" .. '  ' .. "%X" , number)
	end
end)

W.CreateCallback("ZC-CustomScripts:getVIPMenu", function(source, cb)
    local src = source
	if vips[src] then
		cb(vips[src])
	else
		cb('<b style=color:red>ERROR</b>')
	end
end)

-- Placaje.lua
RegisterServerEvent('esx_kekke_tackle:tryTackle')
AddEventHandler('esx_kekke_tackle:tryTackle', function(target)
	local targetPlayer = W.GetPlayer(target)

	TriggerClientEvent('esx_kekke_tackle:getTackled', targetPlayer.src, source)
	TriggerClientEvent('esx_kekke_tackle:playTackle', source)
end)

local enth = false


RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	enth = true
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)


RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
	enth = false
end)


W.CreateCallback('th:enth',function(source,cb)
	local respuesta = false

	if enth then
		respuesta = true
		enth = false
	else
		respuesta = false
		enth = false
	end
  
	cb(respuesta)

end)

W.CreateCallback('customScripts:money', function(source, callback, price)
    local src = source
    local ply = W.GetPlayer(src)
    local money = ply.getMoney('money')

	if money >= price then
		ply.removeMoney('money', price)

		return callback(true)
	else
		return callback(false)
	end
end)

-- Mecanico.lua

RegisterServerEvent('pagarmecano:checkmoney', function ()
	local src = source
    local ply = W.GetPlayer(src)
    local userMoney = ply.getMoney('money')

	if userMoney >= 150 then
		ply.removeMoney('money', 150)
		TriggerClientEvent('pagarmecano:success', src, 150)
	else
		moneyleft = 150 - userMoney
		TriggerClientEvent('pagarmecano:notenoughmoney', src, moneyleft)
	end
end)

-- Spawners.lua

-- RegisterNetEvent("customscript:chr7loglinea", function(source, type)

-- 	print (source)
-- 		-- if type == "on" then
-- 		-- 	logschr7('\n **Comando:** IDADMIN activado \n**Administrador:** '..GetPlayerName(source)..' ')
-- 		-- elseif type == "off" then
-- 		-- 	logschr7('\n **Comando:** IDADMIN desactivado \n**Administrador:** '..GetPlayerName(source)..' ')
-- 		-- end
-- end)

logon = function()
 	logschr7('\n **Comando:** IDADMIN activado \n**Administrador:** '..GetPlayerName(source)..' ')
end
RegisterNetEvent("customscript:chr7logon", logon)

logoff = function()
	logschr7('\n **Comando:** IDADMIN desactivado \n**Administrador:** '..GetPlayerName(source)..' ')
end
RegisterNetEvent("customscript:chr7logoff", logoff)