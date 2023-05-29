local function Info()
    local PlayerPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(PlayerPed, false)
    local IsDriver = GetPedInVehicleSeat(plyVeh, -1) == PlayerPed
    local returnValue = plyVeh ~= 0 and plyVeh ~= nil and IsDriver
    return returnValue, plyVeh
end

local isEnabled = true

function toggleDoubleClutchBlock(toggle)
    isEnabled = toggle
end
exports('toggleDoubleClutchBlock', toggleDoubleClutchBlock)

Citizen.CreateThread(function()
    while true do
        local Driver, plyVeh = Info()
        if Driver and isEnabled then
            if GetVehicleCurrentGear(plyVeh) < 3 and GetVehicleCurrentRpm(plyVeh) == 1.0 and math.ceil(GetEntitySpeed(plyVeh) * 2.236936) > 50 then
              while GetVehicleCurrentRpm(plyVeh) > 0.6 do
                  SetVehicleCurrentRpm(plyVeh, 0.3)
                  Citizen.Wait(1)
              end
              Citizen.Wait(800)
            end
        end
        Citizen.Wait(500)
    end
end)

--- si la marcha actual es inferior a 3 y la velocidad es superior a 50, el embrague doble se interrumpirá levemente, como si fallara en la sincronización de un embrague doble anteriormente.