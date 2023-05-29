Skillbar = {}
Skillbar.data = {}
Skillbar.data.Taskbar = {}

RegisterNetEvent('ZC-Skillbar:startSkillbar') 
AddEventHandler('ZC-Skillbar:startSkillbar', function(cb, difficulty, size)
	Skillbar.data.Taskbar.success = nil
	SetNuiFocus(true)
	for i=1, difficulty or 1 do
		if Skillbar.data.Taskbar.success == nil or Skillbar.data.Taskbar.success then
			SendNUIMessage({
				type = 'open',
				time = 2400,
				size = size
			})
			Skillbar.data.TaskbarOpen = true
			while Skillbar.data.TaskbarOpen do
				Citizen.Wait(5)
			end
			if Skillbar.data.Taskbar.success and i ~= difficulty then
				Citizen.Wait(math.random(500, 1000))
			end
		end
	end
	SetNuiFocus(false)
	cb(Skillbar.data.Taskbar.success)
	if Skillbar.data.Taskbar.success == true then
		SendNUIMessage({type = 'sound'})
	end
end)

RegisterNUICallback('ZC-Skillbar:checkButton', function(data, cb)
	Skillbar.data.TaskbarOpen = false
	Skillbar.data.Taskbar.success = data.success
end)

RegisterNUICallback('ZC-Skillbar:checkFailed', function(data, cb)
	Skillbar.data.Taskbar.success = false
end)

RegisterNUICallback('ZC-Skillbar:closeSkillbar', function(data, cb)
	Skillbar.data.TaskbarOpen = false
end)

