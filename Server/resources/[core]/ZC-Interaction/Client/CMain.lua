exports("open", function (text, coords)
    CreateThread(function ()
        SendNUIMessage({
            open = true
        })  
        Timed = GetGameTimer() 
        local _, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
        Wait(0)
        SendNUIMessage({
            text = LuaToHtml(text),
            coords = {x = x * 100, y = y * 100},
        })  
        if IsControlJustPressed(1, 38) then
            SendNUIMessage({
                press = true
            })
        end
        if (GetGameTimer() - Timed) > 600 then
            SendNUIMessage({
                close = true
            })
        end
    end)
end)

---comment
---@param text any
---@return any
LuaToHtml = function(text)
    text = text:gsub("~r~", "<b style='color:#F40202'>") 
    text = text:gsub("~b~", "<b style='color:#00B2FF'>")
    text = text:gsub("~g~", "<b style='color:#1DDA10'>")
    text = text:gsub("~y~", "<b style='color:#FFFF00'>")
    text = text:gsub("~p~", "<b style='color:#9910DA'>")
    text = text:gsub("~c~", "<b style='color:#6C6C6C'>")
    text = text:gsub("~m~", "<b style='color:#393939'>")
    text = text:gsub("~u~", "<b style='color:#000000'>")
    text = text:gsub("~o~", "<b style='color:#efb810'>")
    text = text:gsub("~s~", "</b>")
    text = text:gsub("~w~", "</b>")
    return text
end