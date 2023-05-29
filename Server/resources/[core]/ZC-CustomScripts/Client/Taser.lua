local isTaz = false

CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if IsPedBeingStunned(ped) then
			SetPedToRagdoll(ped, 7000, 7000, 0, 0, 0, 0)
			SetPedMinGroundTimeForStungun(ped, 7000)
		end

		if IsPedBeingStunned(ped) and not isTaz then
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
		elseif not IsPedBeingStunned(ped) and isTaz then
			isTaz = false
			Wait(5000)
			SetTimecycleModifier("hud_def_desat_Trevor")
			Wait(10000)
  		    SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end

		Wait(1000)
	end
end)