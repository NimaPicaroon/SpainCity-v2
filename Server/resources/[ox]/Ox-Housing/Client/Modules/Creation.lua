local shell, price, points, gang, gangName = nil, nil, {}, nil, ''
local typePoints = {
    'garaje',
    'entrada'
}

RegisterNetEvent("Ox-Housing:client:startHouseCreation")
AddEventHandler("Ox-Housing:client:startHouseCreation", function()
    createHouse()
end)

function createHouse()
    local elements = {}
    if shell == nil then
        table.insert(elements, {label = "Shell", value = "shell"})
    else
        table.insert(elements, {label = "Shell: <span style='color:yellow; font-weight:bold;'>"..shell.."</span>" , value = "shell"})
    end

    if price == nil then
        table.insert(elements, {label = "Precio", value = "price"})
    else
        table.insert(elements, {label = "Precio: <span style='color:yellow; font-weight:bold;'>"..price.."</span>" , value = "price"})
    end

    table.insert(elements, {label = "Puntos", value = "points"})

    if gang == nil then
        table.insert(elements, {label = "Banda", value = "gang"})
    else
        table.insert(elements, {label = "Banda: <span style='color:yellow; font-weight:bold;'>"..gang.."</span>" , value = "gang"})
        if gangName == '' then
            table.insert(elements, {label = "Nombre de la banda", value = "gangName"})
        else
            table.insert(elements, {label = "Nombre de la banda: <span style='color:yellow; font-weight:bold;'>"..gangName.."</span>" , value = "gangName"})
        end
    end

    if #points ~= 0 and price ~= nil and shell ~= nil then
        table.insert(elements, {label = "Confirmar creación", value = "confirm"})
    end
    Wait(200)
    W.OpenMenu('Crear casa', "housingcreation_menu", elements, function (data, name)
        W.DestroyMenu(name)
        local v = data.value

        if v == "shell" then
            local elements2 = {}
            for k, v in pairs(Housing['points']) do
                table.insert(elements2, {label = v.name and v.name or v.shell, value = v.shell, separator=v.type and true or false})
            end
            Wait(200)
            W.OpenMenu('Shells', "inventory_menu", elements2, function (data, name)
                W.DestroyMenu(name)
                if not data.separator then
                    if data.value then
                        shell = data.value
                        createHouse()
                    end
                end
            end)
        elseif v == "gang" then
            local elements2 = {
                {label = 'Si', value ='yes'},
                {label = 'No', value = 'no'}
            }
            Wait(200)
            W.OpenMenu('Banda', "d_menu", elements2, function (data, name)
                W.DestroyMenu(name)
                if data.value == 'yes' then
                    gang = data.value
                    createHouse()
                elseif data.value == 'no' then
                    gang = nil
                    createHouse()
                end
            end)
        elseif v == "gangName" then
            W.OpenDialog("Nombre", "dialog_quaaa", function(amount)
                W.CloseDialog()
                local name = amount
                if name then
                    gangName = name
                    createHouse()
                end
            end)
        elseif v == "price" then
            W.OpenDialog("Precio", "dialog_quaaa", function(amount)
                W.CloseDialog()
                amount = tonumber(amount)
                if amount then
                    price = amount
                    createHouse()
                end
            end)
        elseif v == "points" then
            addPoints()
        elseif v == "confirm" then
            TriggerServerEvent("Ox-Housing:server:sendHouse", shell, price, points, gangName)
            shell = nil
            price = nil
            gang = nil
            gangName = ''
            points = {}
        end
    end)
end

function addPoints()
    local veh = nil
    local vehicleCreated = false
    points = {}
    exports['ZC-HelpNotify']:open('Creación de puntos | Usa <strong>E</strong> para añadir un punto | Usa <strong>BORRA</strong> para acabar', 'points')
    Citizen.CreateThread(function()
        local start = 1
        local heading = 0.00
        local changed = true
        while true do
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            DrawMarker(1, coords, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 233, 0, 255, 0, 0, 0, 0, 0, 0, 0)
            Citizen.Wait(0)

            if typePoints[start] == "garaje" and not vehicleCreated then
                local hash = GetHashKey("zentorno")
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(1)
                end
                veh = CreateVehicle(hash, coords, 100.00, false, false)
                SetVehicleCustomPrimaryColour(veh, tonumber(red), tonumber(green), tonumber(blue))
                SetEntityCollision(veh, false, false)
                SetEntityAlpha(veh, 180, 0)
                vehicleCreated = true
            end

            if typePoints[start] ~= "garaje" then
                vehicleCreated = false
                DeleteVehicle(veh)
                if changed then
                    exports['ZC-HelpNotify']:close('points2')
                    changed = false
                    exports['ZC-HelpNotify']:open(typePoints[start]..' | Usa <strong>flechita arriba y flechita abajo</strong> para cambiar de punto', 'points2')
                end
            else
                if changed then
                    exports['ZC-HelpNotify']:close('points2')
                    changed = false
                    exports['ZC-HelpNotify']:open(typePoints[start]..' | Usa <strong>flechita arriba y flechita abajo</strong> para cambiar de punto | Mantén los <strong>CLICKS</strong> para cambiar el heading', 'points2')
                end
            end

            if IsControlPressed(0, 25) then
                heading = heading + 0.75
            end
            if IsControlPressed(0, 348) then
                heading = heading - 0.75
            end
            SetEntityHeading(veh, heading)
            SetEntityCoords(veh, coords)
            if IsControlJustPressed(1, 175) then
                changed = true
                if start == #typePoints then
                    start = 1
                else
                    start = start + 1
                end
            end

            if IsControlJustPressed(1, 174) then
                changed = true
                if start == 1 then
                    start = #typePoints
                else
                    start = start - 1
                end
            end

            if IsControlJustPressed(1, 38) then
                table.insert(points, {coords = coords, type = typePoints[start], heading = heading})
                if typePoints[start] == "entrada" then
                    table.remove(typePoints, start)
                    table.insert(typePoints, 'puerta')
                    start = 1
                end
                W.Notify('CASAS', 'Punto añadido')
            end

            if IsControlJustPressed(0, 194) then
                exports['ZC-HelpNotify']:close('points')
                exports['ZC-HelpNotify']:close('points2')
                DeleteVehicle(veh)
                createHouse()
                typePoints = {
                    'garaje',
                    'entrada'
                }
                break
            end
        end
    end)
end

function RayCastGamePlayCamera(distance)
    -- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end


function RotationToDirection(rotation)
    -- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end