local toggled = false

CreateThread(function()
    local max = GetPlayerUnderwaterTimeRemaining(PlayerId())
    while true do
        Wait(1000)
        local data = W.GetPlayerData()
        if data and data.status and data.status.hunger then
            local status = data.status
            local ped = PlayerPedId()
            local show = true

            if IsPauseMenuActive() or toggled then
                show = false
            end

            local diving = (GetPlayerUnderwaterTimeRemaining(PlayerId()) / max) * 100

            SendNUIMessage({
                show =  show,
                hunger = status.hunger,
                thirst = status.thirst,
                stress = status.stress,
                drunk = status.drunk,
                shield = GetPedArmour(ped),
                health = GetEntityHealth(ped)-100,
                stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
                inWater = IsPedSwimmingUnderWater(ped),
                water = diving
            })
        end
    end
end)

Toggle = function ()
    toggled = not toggled
end

RegisterCommand("togglehud", Toggle, false)