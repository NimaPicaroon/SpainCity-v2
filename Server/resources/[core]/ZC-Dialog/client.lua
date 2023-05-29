Main = { }
Main.__opened = false
Main.__callback = nil
Main.Name = nil
-- @main
RegisterNetEvent('core:client:showDialog', function(title, name)
    if not IsPauseMenuActive() and not Main.__opened then
        Main.Name = name
        Main.__callback = callback
        Main.__opened = true

        SendNUIMessage({
            open = true,
            title = title
        })
        Main.StartDialogLoop()
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent('wdialog:client:closeMenu', function()
    SendNUIMessage({
        close = true,
    })
    SetNuiFocus(false, false)
    Main.__opened = false
end)

-- @nui callbacks
RegisterNUICallback("post", function(cb, post)
    TriggerEvent("core:sendDialogData", Main.Name, cb.text)
    Main.Name = nil
end)

RegisterNUICallback("close", function(cb, post)
    SetNuiFocus(false, false)
    Main.__opened = false
end)

Main.StartDialogLoop = function()
    Citizen.CreateThread(function()
        while(Main.__opened == true)do
            Citizen.Wait(1000)
            SetNuiFocus(true, true)
        end
        SetNuiFocus(false, false)
    end)
end