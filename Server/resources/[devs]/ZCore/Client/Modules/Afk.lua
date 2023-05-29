local afkTimeout = 1800
local timer = 0

local currentPosition  = nil
local previousPosition = nil
local currentHeading   = nil
local previousHeading  = nil
local afkEnabled = false

CreateThread(function()
    if not afkEnabled then return end
	while true do
		Wait(1000)

        local playerPed = PlayerPedId()
        if playerPed then
            currentPosition = GetEntityCoords(playerPed, true)
            currentHeading  = GetEntityHeading(playerPed)

            if currentPosition == previousPosition and currentHeading == previousHeading then
                if timer > 0 then
                    if timer == math.ceil(afkTimeout / 4) then
                        TriggerEvent('chat:addMessage', { args = { ('^1 Servicio AntiAFK | ^0'), ('Vas a ser kickeado en '..timer..' segundos') } })
                    end

                    timer = timer - 1
                else
                    TriggerServerEvent('ZCore:afkKick')
                end
            else
                timer = afkTimeout
            end

            previousPosition = currentPosition
            previousHeading  = currentHeading
        end
	end
end)