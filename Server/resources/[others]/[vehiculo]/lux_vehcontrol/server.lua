--[[
---------------------------------------------------
LUXART VEHICLE CONTROL (FOR FIVEM)
---------------------------------------------------
Last revision: NOV 07 2016
Coded by Lt.Caine
---------------------------------------------------
NOTES
	
---------------------------------------------------
]]


RegisterServerEvent("lvc_TogDfltSrnMuted_s")
AddEventHandler("lvc_TogDfltSrnMuted_s", function(toggle)
	TriggerClientEvent("lvc_TogDfltSrnMuted_c", -1, source, toggle)
end)

RegisterServerEvent("lvc_SetLxSirenState_s")
AddEventHandler("lvc_SetLxSirenState_s", function(newstate)
	TriggerClientEvent("lvc_SetLxSirenState_c", -1, source, newstate)
end)

RegisterServerEvent("lvc_TogPwrcallState_s")
AddEventHandler("lvc_TogPwrcallState_s", function(toggle)
	TriggerClientEvent("lvc_TogPwrcallState_c", -1, source, toggle)
end)

RegisterServerEvent("lvc_SetAirManuState_s")
AddEventHandler("lvc_SetAirManuState_s", function(newstate)
	TriggerClientEvent("lvc_SetAirManuState_c", -1, source, newstate)
end)

RegisterServerEvent("lvc_TogIndicState_s")
AddEventHandler("lvc_TogIndicState_s", function(newstate)
	TriggerClientEvent("lvc_TogIndicState_c", -1, source, newstate)
end)

local playerIndicators = {source}

RegisterServerEvent('IndicatorL')
RegisterServerEvent('IndicatorR')

AddEventHandler('IndicatorL', function(IndicatorL)
	local netID = source
	TriggerClientEvent('updateIndicators', -1, netID, 'left', IndicatorL)
	--playerIndicators[netID][left] = IndicatorL
	print(netID .. "Indicator left")
end)

AddEventHandler('IndicatorR', function(IndicatorR)
	local netID = source
	TriggerClientEvent('updateIndicators', -1, netID, 'right', IndicatorR)
	--playerIndicators[netID][right] = IndicatorR
	print(netID .. "Indicator right")
end)