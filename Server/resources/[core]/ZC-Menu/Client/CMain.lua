OpenedMenu = { }
local IsMenuOpened = false

W = exports.ZCore:get()

exports('isOpened', function()
    return IsMenuOpened
end)

RegisterCommand('fixmenu', function()
    IsMenuOpened = false

    TriggerEvent("wdialog:client:closeMenu")
    exports['ZC-Inventory']:closeInv()
    for k,v in pairs(OpenedMenu) do
        TriggerEvent("core:destroyMenu", v.name)
    end

    OpenedMenu = { }
    SendNUIMessage({ key = "remove" })
end)

RegisterNetEvent("core:openMenu", function(title, name, data)
    if IsMenuOpened then
        return W.Notify('Menú', 'Ya tienes un menú abierto, no puedes abrir otro', 'error')
    end

    CreateThread(function ()
        if not IsMenuOpened then
            IsMenuOpened = true
            OpenedMenu[name] = { resource = "no", data = data, name = name }
            SendNUIMessage({ title = title, openmenu = true, resource = "no", name = name, array = data })
            Wait(200)

            while true do
                if not IsMenuOpened then break end
                Wait(0)
                if IsControlPressed(0, 18) then
                    SendNUIMessage({ key = "enter" })
                    Wait(150)
                end

                if IsControlPressed(0, 177) then
                    SendNUIMessage({ key = "remove" })
                    TriggerEvent("core:destroyMenu", name)
                    break
                end

                if IsControlPressed(0, 27) then
                    Wait(100)
                    SendNUIMessage({ key = "ArrowUp" })
                end

                if IsControlPressed(0, 173) then
                    Wait(100)
                    SendNUIMessage({ key = "ArrowDown" })
                end
            end
        end
    end)
end)

RegisterNetEvent("core:closeMenu", function(option)
    SendNUIMessage({ key = "remove", option = option})
    IsMenuOpened = false
    OpenedMenu = { }
end)

RegisterNUICallback("ItemSelected", function (data, cb)
    TriggerEvent("core:sendData", data.item, data.name)
    return cb("")
end)