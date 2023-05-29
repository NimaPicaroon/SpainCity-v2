RegisterCommand("racing", function()
    openTablet()
end)

-- CLIENT export - This function is exported, so it can be opened from any other client-side script by using 'exports['rahe-racing']:openRacingTablet()'
function openRacingTablet()
    openTablet()
end

-- If you wish to open the tablet via. an event not the export.
RegisterNetEvent("rahe-racing:client:openTablet")
AddEventHandler("rahe-racing:client:openTablet", function()
    openTablet()
end)

function notifyPlayer(message)
    TriggerEvent('chatMessage', "SERVER", "normal", message)
end

-- You can do some logic when the tablet is closed. For example if you started an animation when opened, you can end the animation here.
RegisterNetEvent('rahe-racing:client:tabletClosed', function()

end)