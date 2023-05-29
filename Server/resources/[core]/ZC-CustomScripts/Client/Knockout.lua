local knockedOut = false
local espera = math.random(10,20)
local count = 60


Citizen.CreateThread(function()
	while true do
		local msec = 500
		local myPed = PlayerPedId()
		if IsPedInMeleeCombat(myPed) then
			msec = 5
			if GetEntityHealth(myPed) < 135 then
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				W.Notify('KO', "¡Estás KO por "..espera.." segundos!", 'verify')
				espera = 15
				knockedOut = true
				SetEntityHealth(myPed, 136)
			end
		end
		if knockedOut == true then
			msec = 5
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			
			if espera >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					espera = espera - 1
				end
			else
			    W.Notify('KO', "¡Vuelves a estar consciente!", 'verify')
				knockedOut = false
			end
		end

		Wait(msec)
	end
end)

Citizen.CreateThread(function()
	local enabled = false

	while true do
		Wait(1000)
		if knockedOut == true and enabled == false then
			enabled = true
			SetTimecycleModifier('BarryFadeOut')
			SetTimecycleModifierStrength(math.min(0.1 / 10, 0.6))
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.6)
			
		elseif(knockedOut == false and enabled == true)then
			while enabled do
				Wait(0)
				-- if IsControlJustReleased(1, 21) then
				-- 	knockedOut = true
				-- 	enabled = false
				-- end
				Citizen.SetTimeout(7000, function()
					enabled = false
				end)
			end
			SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
			espera = math.random(10,30)		
		end
	end
end)