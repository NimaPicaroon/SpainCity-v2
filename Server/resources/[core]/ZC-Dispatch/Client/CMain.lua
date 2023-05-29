alerts = {}
currentAlert = 0

function round(number)
    return math.floor(number * 10) / 10
end

RegisterCommand("entorno", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    
    -- if not text:len() >= 20 then
    --     W.Notify('Entorno', 'Debes detallar un poco más tu entorno', 'error')
        
    --     return
    -- end

    TriggerServerEvent("ZC-Dispatch:sendAlert", "police", text, coords, id)
    W.Notify('Entorno', 'Has enviado una llamada de entorno', 'verify')
    TriggerServerEvent('dispatch:entornoSended')
end, false)

RegisterCommand("tiros", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    
    TriggerServerEvent("ZC-Dispatch:sendAlert", "police", "Una persona ha disparado un arma de fuego en la zona!", coords, id)
    W.Notify('Entorno', 'Has enviado una llamada de entorno', 'verify')
    TriggerServerEvent('dispatch:entornoSended')
end, false)

RegisterCommand("auxilio", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent("ZC-Dispatch:sendAlert", "ambulance", text, coords, id)
    TriggerServerEvent('dispatch:entornoSended')
    W.Notify('Auxilio', 'Has enviado una llamada de auxilio', 'verify')
end, false)

RegisterCommand("pedirtaxi", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent("ZC-Dispatch:sendAlert", "taxi", text, coords, id)
    TriggerServerEvent('dispatch:entornoSended')
    W.Notify('LLAMADA', 'Has enviado una llamada a la centralita de ~y~Taxis', 'verify')
end, false)

RegisterNetEvent("ZC-Dispatch:sendAlertToClient")
AddEventHandler("ZC-Dispatch:sendAlertToClient", function(faction, text, coords, id, type, heist)
    local OwnData = W.GetPlayerData()
    if OwnData.job and Config.Jobs[OwnData.job.name] and OwnData.job.name == faction and OwnData.job.duty then
        local distanceToAlert = #(coords - GetEntityCoords(PlayerPedId()))
        local finalDistanceTo = round(round(distanceToAlert) * 0.001)
        table.insert(alerts, {text = text, coords = coords, id = currentAlert, type = type, heist = heist})
        
        if not responding then
            currentAlert = #alerts
            local playerId = GetPlayerServerId(PlayerId())
            local alert = {
                text = text,
                currentAlert = currentAlert,
                distance = finalDistanceTo,
                totalcalls = #alerts,
                type = type,
                newalert = true,
                heist = heist
            }

            SendNUIMessage(alert)
        else
            SendNUIMessage({
                updateAndResponding = true,
                totalcalls = #alerts,
            })
        end
    end
end)

RegisterNUICallback('deleteAlerts', function()
    alerts = {}
    currentAlert = 0
end)

RegisterCommand("forzar", function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local matr = GetVehicleNumberPlateText(vehicle)
        local vehDisplayName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local vehicleLabelText = GetLabelText(vehDisplayName)
        local model = vehicleLabelText == 'NULL' and vehDisplayName or vehicleLabelText
        local coords = GetEntityCoords(PlayerPedId())
        local id = GetPlayerServerId(PlayerId())
        local r, g, b = GetVehicleColor(vehicle)
        local finalColor = "<div style='width:20px;height:15px;display:inline-block;background-color:rgb(" .. r .. "," .. g .. "," .. b .. ")'></div>"
        local prob = math.random(1, 2)
        if prob == 1 then
            TriggerServerEvent("ZC-Dispatch:sendAlert", "police", "Un sujeto ha robado un " ..model.. " de color "..finalColor.."con patente ".. matr, coords, id, 'vehicle')
        else
            TriggerServerEvent("ZC-Dispatch:sendAlert", "police", "Un sujeto ha robado un " ..model.. " de color "..finalColor.."", coords, id, 'vehicle')
        end

        W.Notify('Forzar', 'Has enviado una llamada de forzar', 'verify')
        TriggerServerEvent('dispatch:entornoSended')
    end
end, false)

RegisterCommand("v", function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if (vehicle ~= nil and vehicle ~= 0) then
            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())
            local vehDisplayName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local vehicleLabelText = GetLabelText(vehDisplayName)
            local vehicleName = vehicleLabelText == 'NULL' and vehDisplayName or vehicleLabelText
            local r, g, b = GetVehicleColor(vehicle)
            local text = "Se veria a un/a " .. vehicleName .. " de color <div style='width:20px;height:15px;display:inline-block;background-color:rgb(" .. r .. "," .. g .. "," .. b .. ")'></div> a grandes velocidades"
            TriggerServerEvent("ZC-Dispatch:sendAlert", "police", text, coords, id, 'vehicle')
            TriggerServerEvent('dispatch:entornoSended')
        end
    end
end)