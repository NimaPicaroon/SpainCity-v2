local toAdd, secs = 20, 0
RegisterNetEvent('ZCore:playerLoaded', function()
    local player = W.GetPlayerData()

    local stamina = tonumber(player.stats.stamina)
    local strength = tonumber(player.stats.strength)
    local diving = tonumber(player.stats.diving)

    Setstat("STAMINA", stamina)
    StatSetInt('MP0_LUNG_CAPACITY', diving * 1.5, true)
    StatSetInt(GetHashKey("MP0_STRENGTH"), strength, true)

    if diving > 30 then
        toAdd = 25
    end
    if diving > 45 then
        toAdd = 35
    end
    if diving > 60 then
        toAdd = 50
    end
    if diving > 80 then
        toAdd = 60
    end
end)

function Setstat(name,val)
	Citizen.CreateThread(function()
	    StatSetInt(GetHashKey('MP0_'..name), val)
		StatSetInt(GetHashKey('MP1_'..name), val)
		StatSetInt(GetHashKey('MP2_'..name), val)
		StatSetInt(GetHashKey('MP3_'..name), val)
		StatSetInt(GetHashKey('MP4_'..name), val)
		StatSetInt(GetHashKey('MP5_'..name), val)
		StatSetInt(GetHashKey('MP6_'..name), val)
	end)
end

Citizen.CreateThread(function()
	while true do
        local msec = 2000
		local ped = PlayerPedId()
		if IsPedSwimmingUnderWater(ped) and not isDead then
            msec = 1000
			secs = secs + 1
			if(secs > toAdd)then
				secs = 0
				TriggerServerEvent('ZC-Gym:addSkill', 'diving', 1)
                W.Notify('HABILIDADES', 'Has subido ~g~x1~w~ puntos de ~y~buceo', 'verify')
			end
		end

		Citizen.Wait(msec)
	end
end)

RegisterCommand('stats', function ()
    --if exports['Ox-Phone']:IsPhoneOpened() then return end
    if exports['Ox-Jobcreator']:IsHandcuffed() then return end
    if exports['ZC-Ambulance']:IsDead() then return end
    local data = W.GetPlayerData()

    local stats = {
        stamina = data.stats.stamina,
        strength = data.stats.strength,
        diving = data.stats.diving,
        stress = data.stats.stress
    }

    SendNUIMessage({ open = stats })
    SetNuiFocus(true)
    SetNuiFocusKeepInput(true)
end)

RegisterNUICallback("close", function(cb, post)
    SetNuiFocus(false)
    SetNuiFocusKeepInput(false)
    post("ok")
end)

RegisterKeyMapping('stats', 'Menu para abrir las stats', 'keyboard', 'PAGEDOWN')