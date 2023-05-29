RegisterNetEvent("jobcreatorv2:server:requestarrest", function(targetid, playerheading, playerCoords,  playerlocation)
    local src <const> = source
    local targetid <const> = targetid
    TriggerClientEvent('jobcreatorv2:client:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('jobcreatorv2:client:doarrested', src)
end)

RegisterNetEvent('jobcreatorv2:server:requestunaarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    local src <const> = source
    local targetid <const> = targetid
    TriggerClientEvent('jobcreatorv2:client:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('jobcreatorv2:client:douncuffing', src)
end)

RegisterServerEvent('jobcreatorv2:server:escort', function(target)
    local src <const> = source
    local targetid <const> = target
    TriggerClientEvent('jobcreatorv2:client:drag', targetid, src)
end)

RegisterServerEvent('jobcreatorv2:server:putinvehicle', function(target)
    if target ~= 0 then
        TriggerClientEvent('jobcreatorv2:client:putInVehicle', target)
    end
end)

RegisterServerEvent('jobcreatorv2:server:outfromveh', function(target)
	if target ~= 0 then
        TriggerClientEvent('jobcreatorv2:client:OutVehicle', target)
    end
end)

RegisterServerEvent('Ox-Jobcreator:QRR', function(coords, playerData)
	local polices = exports['Ox-References']:getPolices()

	for key, value in next, polices do
		if value and value.source then
			TriggerClientEvent("ZC-Dispatch:sendAlertToClient", value.source, "police", "QRR | "..playerData.identity.name..' '..playerData.identity.lastname..' | '..playerData.job.ranklabel..'.', coords, source, "qrr")
		end
	end
end)