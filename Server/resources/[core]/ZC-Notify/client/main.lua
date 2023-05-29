local function ConvertColor(text)
    text = text:gsub("~r~", "<span style='ccolor:#F40202'>") 
    text = text:gsub("~b~", "<span style='color:#00B2FF'>")
    text = text:gsub("~g~", "<span style='color:#1DDA10'>")
    text = text:gsub("~y~", "<span style='color:#FFFF00'>")
    text = text:gsub("~p~", "<span style='color:#9910DA'>")
    text = text:gsub("~c~", "<span style='color:#6C6C6C'>")
    text = text:gsub("~m~", "<span style='color:#393939'>")
    text = text:gsub("~u~", "<span style='color:#000000'>")
    text = text:gsub("~o~", "<span style='color:#efb810'>")
    text = text:gsub("~s~", "</span>")
    text = text:gsub("~w~", "</span>")
    text = text:gsub("~b~", "<b>")
    text = text:gsub("~n~", "<br>")
    text = "<span>" ..text.. "</span>"
    return text
end

---@param type string
---@param title string
---@param text string
---@param duration number
function Notify(type, title, message, duration)
    SendNUIMessage({
        action = 'notification',
        type = type,
        message = ConvertColor(message),
        duration = duration or 5000
    })
end

CreateThread(function()
    while true do
        SendNUIMessage({
            action = 'checkRadar',
            map = IsRadarEnabled()
        })

        Wait(1000)
    end
end)

exports('SendNotification', Notify)
RegisterNetEvent("core:client:notify", Notify)