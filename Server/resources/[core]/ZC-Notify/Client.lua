---comment
---comment
---@param type any
---@param title any
---@param text any
Notify = function (type, title, text)
    SendNUIMessage({
        title = (title),
        content = (text),
        type = type
    })
end

RegisterNetEvent("core:client:notify", Notify)