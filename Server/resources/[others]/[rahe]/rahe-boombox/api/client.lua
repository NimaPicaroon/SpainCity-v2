RegisterNetEvent('rahe-boombox:client:notify')
AddEventHandler('rahe-boombox:client:notify', function(message, type)
    notifyPlayer(message, type or G_NOTIFICATION_TYPE_SUCCESS)
end)

function notifyPlayer(message, type)
    lib.notify({
        title = message,
        type = type
    })
end