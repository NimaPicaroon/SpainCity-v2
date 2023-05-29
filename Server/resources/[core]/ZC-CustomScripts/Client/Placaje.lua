local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PoliceJob 				= 'police'
local OwnData = {}
local isTackling				= false
local isGettingTackled			= false
local tackleLib					= 'missmic2ig_11'
local tackleAnim 				= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim			= 'mic_2_ig_11_intro_p_one'
local lastTackleTime			= 0
local isRagdoll					= false
local isPolice = false

RegisterNetEvent('ZCore:playerLoaded', function()
    local player = W.GetPlayerData()
    OwnData = player

    if OwnData.job and (OwnData.job.duty and OwnData.job.name == PoliceJob) then
        isPolice = true
    else
        isPolice = false
    end
end)

RegisterNetEvent('ZCore:setJob')
AddEventHandler('ZCore:setJob', function(job)
	OwnData.job = job

    if OwnData.job and (OwnData.job.duty and OwnData.job.name == PoliceJob) then
        isPolice = true
    else
        isPolice = false
    end
end)

RegisterNetEvent('esx_kekke_tackle:getTackled')
AddEventHandler('esx_kekke_tackle:getTackled', function(target)
	isGettingTackled = true

	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Wait(10)
	end

	AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Wait(3000)
	DetachEntity(PlayerPedId(), true, false)

    CreateThread(function()
        local time = 0
        while true do
            time = time + 1
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)

            if time >=  350 then
                isGettingTackled = false
                break
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent('esx_kekke_tackle:playTackle')
AddEventHandler('esx_kekke_tackle:playTackle', function()
	local playerPed = PlayerPedId()

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Wait(3000)

	isTackling = false
end)

-- Main thread

RegisterKeyMapping('tackle', 'Placaje policial', 'keyboard', 'LSHIFT')
local pressed = false

RegisterCommand("tackle", function ()
    if isPolice then
        while true do
            Wait(0)
            if not isPolice then break end
            if IsControlPressed(1, Keys['LEFTSHIFT']) then
                if not pressed then
                    pressed = true
                end

                if IsControlPressed(1, Keys['Y']) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 then
                    Wait(10)
                    local closestPlayer, distance = W.GetClosestPlayer()

                    if distance ~= -1 and distance <= 3.0 and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
                        isTackling = true
                        lastTackleTime = GetGameTimer()

                        TriggerServerEvent('esx_kekke_tackle:tryTackle', GetPlayerServerId(closestPlayer))
                        break
                    end
                end
            else
                if pressed then
                    pressed = false
                    break
                end
            end
        end
    end
end)