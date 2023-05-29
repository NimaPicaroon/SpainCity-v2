RegisterCommand(Config['createcommand'], function(source, args)
    local data = W.GetPlayerData()
    if data.group == 'admin' then
        --if exports['Ox-Phone']:IsPhoneOpened() then return end
        if exports['Ox-Jobcreator']:IsHandcuffed() then return end
        if exports['ZC-Ambulance']:IsDead() then return end
        if exports['ZC-Menu']:isOpened() then return end

        createAnnounce()
    else
        W.Notify('ANUNCIO', 'No puedes hacer esto', 'error')
    end
end, false)

local job = nil
local foto = nil
local fotoBack
local color = nil
local name = nil
local colorbar = nil

function createAnnounce()
    local elements = {}

    if job == nil then
        table.insert(elements, {label = "Job:", value = "job"})
    else
        table.insert(elements, {label = "Job: " ..job, value = "job"})
    end

    if foto == nil then
        table.insert(elements, {label = "Logo:", value = "pic"})
    else
        table.insert(elements, {label = "Logo: " ..foto, value = "pic"})
    end

    if fotoBack == nil then
        table.insert(elements, {label = "Logo fondo:", value = "pic2"})
    else
        table.insert(elements, {label = "Logo fondo: " ..foto, value = "pic2"})
    end

    if color == nil then
        table.insert(elements, {label = "Color fondo (rgb example: 1, 2, 3):", value = "color"})
    else
        table.insert(elements, {label = "Color fondo: " ..color, value = "color"})
    end

    if name == nil then
        table.insert(elements, {label = "Nombre", value = "name"})
    else
        table.insert(elements, {label = "Nombre: " ..name, value = "name"})
    end

    if colorbar == nil then
        table.insert(elements, {label = "Bar color (rgb example: 1, 2, 3):", value = "colorbar"})
    else
        table.insert(elements, {label = "Bar color: " ..colorbar, value = "colorbar"}) 
    end

    if titlecolor == nil then
        table.insert(elements, {label = "Color texto (rgb example: 1, 2, 3): ", value = "titlecolor"})
    else
        table.insert(elements, {label = "Color texto: " ..titlecolor, value = "titlecolor"})
    end

    if job ~= nil and foto ~= nil and color ~= nil and name ~= nil and colorbar ~= nil and titlecolor ~= nil then
        SendNUIMessage({
            democolor = color;
            demopic = foto;
            democolorbar = colorbar;
            demotitlecolor = titlecolor;
            demoname = name;
        })
        table.insert(elements, {label = "Create", value = "create"})
    end

    W.OpenMenu("Creación de anuncios", "menu_ads", elements, function (data, nameA)
        W.DestroyMenu(nameA)
        local v = data.value

        if v == "job" then
            W.OpenDialog('Nombre del job', 'new_jobn', function(jobName)
                W.CloseDialog()
                if jobName and jobName ~= '' then
                    job = jobName
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Trabajo ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "pic" then
            W.OpenDialog('Imagen', 'img_sa', function(img)
                W.CloseDialog()
                if img and img ~= '' then
                    foto = img
                    SendNUIMessage({
                        demopic = foto;
                    })
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Imagen ~r~inválida~w~', 'error')
                end
            end)
        elseif v == "pic2" then
            W.OpenDialog('Imagen fondo (poca opacidad)', 'img_sa', function(img)
                W.CloseDialog()
                if img and img ~= '' then
                    fotoBack = img
                    SendNUIMessage({
                        demopic = fotoBack;
                    })
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Imagen ~r~inválida~w~', 'error')
                end
            end)
        elseif v == "color" then
            W.OpenDialog('Color fondo', 'ssss_sa', function(co)
                W.CloseDialog()
                if co and co ~= '' then
                    color = co
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Color ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "titlecolor" then
            W.OpenDialog('Color título', 'sss_sa', function(co)
                W.CloseDialog()
                if co and co ~= '' then
                    titlecolor = co
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Color ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "colorbar" then
            W.OpenDialog('Color barra', 'sa', function(co)
                W.CloseDialog()
                if co and co ~= '' then
                    colorbar = co
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Color ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "name" then
            W.OpenDialog('Nombre', 'sa', function(co)
                W.CloseDialog()
                if co and co ~= '' then
                    name = co
                    createAnnounce()
                else
                    W.Notify('ANUNCIO', 'Nombre ~r~inválido~w~', 'error')
                end
            end)
        elseif v == "create" then
            TriggerServerEvent("guille_anu:server:create", job, foto, fotoBack, color, name, colorbar, titlecolor)
            SendNUIMessage({
                restartdemo = true;
            })
        end
    end, function()
        SendNUIMessage({
            restartdemo = true;
        })
    end)
end

RegisterCommand(Config['adcommand'], function(source, args)
    local content = table.concat(args, ' ')
    W.TriggerCallback('guille_anu:getAnounce', function(result)
        if result ~= nil then
            TriggerServerEvent("guille_anu:server:sendAnu", result.pic, result.picBack, result.color, result.name, content, result.colorbar, result.titlecolor)
        end
    end)
end, false)

RegisterNetEvent("guille_an:server:syncAnounce")
AddEventHandler("guille_an:server:syncAnounce", function(pic, picBack, color, name, content, colorbar, titlecolor)
    SendNUIMessage({
        pic = pic;
        picBack = picBack;
        color = color;
        name = name;
        content = content;
        colorbar = colorbar;
        titlecolor = titlecolor;
    })
end)
