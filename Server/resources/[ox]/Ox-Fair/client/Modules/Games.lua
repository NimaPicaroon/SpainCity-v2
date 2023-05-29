local playing = false
local vaq_machine = {
    ingame = false,
    players = {}
}

local loadedBlips = false
function refreshBlips()
	if(loadedBlips == false)then
		loadedBlips = true
        local blip = AddBlipForCoord(vector3(-1684.76, -1119.56, 12.21))

        SetBlipSprite(blip, 266)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Feria")
        EndTextCommandSetBlipName(blip)
	end
end

refreshBlips()

RegisterNetEvent("Ox-Fair:updateStatusMachine")
AddEventHandler("Ox-Fair:updateStatusMachine", function(newStatus)
    vaq_machine = newStatus
end)

RegisterNetEvent('Ox-Fair:sendProximityMessage')
AddEventHandler('Ox-Fair:sendProximityMessage', function(playerId, tittle, msg, type)
    local target = GetPlayerFromServerId(playerId)
    if target == nil or target == -1 then
      return
    end

    local playerped = PlayerPedId()
    local playerped2 = GetPlayerPed(target)

    local sourceCoords, targetCoords = GetEntityCoords(playerped), GetEntityCoords(playerped2)
    local distance = #(sourceCoords - targetCoords)

    if target ~= nil and target == PlayerId() or distance < 4 or (NetworkIsInSpectatorMode() and distance < 25.99) then
        if type == 'amor' then
            TriggerEvent('chat:addMessage', {
                template = '<div style="color: red">{0}:<span style="color: white; margin-left:5px">'..msg..'</span></div>',
                args = { tittle, msg}
            })
        else
            TriggerEvent('chat:addMessage', {
                template = '<div style="color: purple">{0}:<span style="color: white; margin-left:5px">'..msg..'</span></div>',
                args = { tittle, msg}
            })
        end
    end
end)

local Zones = {
    {coords = vector3(-1675.04, -1116.24, 12.21), zone = 'amor'},
    {coords = vector3(-1691.68, -1116.4, 12.21), zone = 'futuro'},
    {coords = vector3(-1689.76, -1113.96, 12.21), zone = 'vaqueros'}
}

Citizen.CreateThread(function()
    local show = false
    local currentZone
    while true do
        local wait = 500

        for k,v in pairs(Zones) do
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords)
            if distance < 1.5 and playing == false then
                currentZone = v.zone
                if v.zone ~= 'vaqueros' then
                    wait = 0
                    if not show then
                        show = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para jugar', 'interact_fair')
                    end
                    if IsControlPressed(0, 38) then
                        ProccesArcade(v)
                        exports['ZC-HelpNotify']:close('interact_fair')
                    end
                else
                    if vaq_machine.ingame ~= true then
                        wait = 0
                        if not show then
                            show = true
                            exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para jugar', 'interact_fair')
                        end
                        if IsControlPressed(0, 38) then
                            ProccesArcade(v)
                            exports['ZC-HelpNotify']:close('interact_fair')
                        end
                    end
                end
            else
                if currentZone == v.zone then
                    currentZone = nil
                end
            end
        end

        if show and not currentZone then
            show = false
            exports['ZC-HelpNotify']:close('interact_fair')
        end
        Citizen.Wait(wait)
    end
end)

function ProccesArcade(game)
    playing = true
    local ped = PlayerPedId()
    if game.zone == 'amor' then
        SetEntityHeading(ped, 42.0)
        ReqAnimDict("mini@sprunk")
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
        Citizen.Wait(1000)
		TaskPlayAnim(ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
        Citizen.Wait(1000)
        ClearPedTasksImmediately(ped)
        local person1 = select('Persona 1')
        local person2 = select('Persona 2')
        if person1 ~= '' and person2 ~= '' then
            TriggerServerEvent('Ox-Fair:loadAmor', person1, person2)
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'feria_amor', 1.0)
            Citizen.Wait(6200)
            playing = false
        end
    elseif game.zone == 'futuro' then
        SetEntityHeading(ped, 56.0)
        ReqAnimDict("mini@sprunk")
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
        Citizen.Wait(1000)
		TaskPlayAnim(ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
        Citizen.Wait(1000)
        ClearPedTasksImmediately(ped)
        local question = select('Pregunta')
        if question ~= '' then
            TriggerServerEvent('Ox-Fair:loadFuture', question)
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'feria_amor', 1.0)
            Citizen.Wait(6200)
            playing = false
        end
    elseif game.zone == 'vaqueros' then
        if #vaq_machine.players == 0 then
            table.insert(vaq_machine.players, {source = GetPlayerServerId(PlayerId()), ped = PlayerPedId(), num = '1'})
            SetEntityCoords(PlayerPedId(), vector3(-1690.16, -1114.24, 12.21))
            SetEntityHeading(ped, 47.0)
            FreezeEntityPosition(PlayerPedId(), true)
            TriggerServerEvent('Ox-Fair:updateStatusMachine', vaq_machine)
            Playing()
        elseif #vaq_machine.players == 1 then
            table.insert(vaq_machine.players, {source = GetPlayerServerId(PlayerId()), ped = PlayerPedId(), num = '2'})
            SetEntityCoords(PlayerPedId(), vector3(-1689.36, -1113.44, 12.21))
            SetEntityHeading(ped, 47.0)
            FreezeEntityPosition(PlayerPedId(), true)
            vaq_machine.ingame = true
            TriggerServerEvent('Ox-Fair:updateStatusMachine', vaq_machine)
            Playing()
        else
            W.Notify('FERIA','La máquina está llena', 'error')
        end
    end
end
local tonext = false

function Playing()
    while true do
        local wait = 500
        if vaq_machine.ingame then
            NextFuction()
            break
        else
            W.ShowText(vector3(-1689.76, -1113.96, 14.31), '~y~Feria\n~w~Esperando al 2º jugador, pulsa ~g~X~w~ para cancelar', 0.5, 8)
            if IsControlJustReleased(0, 73) then
                vaq_machine = {
                    ingame = false,
                    players = {}
                }
                TriggerServerEvent('Ox-Fair:updateStatusMachine', vaq_machine)
                FreezeEntityPosition(PlayerPedId(), false)
                playing = false
                break
            end
            wait = 5
        end
        Citizen.Wait(wait)
    end
end

function NextFuction()
    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.Wait(700)
    Citizen.Wait(800)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'feria_vaqueros', 0.7)
    Citizen.Wait(3000)
    ExecuteCommand('e stickup')
    TriggerServerEvent('Ox-Fair:playingMachine')
    local p = promise.new()
    while true do
        local wait = 500
        if tonext == true then
            p:resolve()
            break
        end
        Citizen.Wait(wait)
    end

    Citizen.Await(p)
    tonext = false
    playing = false
    vaq_machine = {
        ingame = false,
        players = {}
    }
    TriggerServerEvent('Ox-Fair:updateStatusMachine', vaq_machine)
    Citizen.Wait(2000)
    ClearPedTasksImmediately(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterNetEvent("Ox-Fair:updateScore")
AddEventHandler("Ox-Fair:updateScore", function(player)
    tonext = true
    W.Notify('FERIA', 'Ha ganado el jugador '.. player, 'verify')
end)

RegisterNetEvent("Ox-Fair:putButtom")
AddEventHandler("Ox-Fair:putButtom", function(key)
    W.Notify('FERIA', 'Pulsa '..key)
end)

RegisterNetEvent("Ox-Fair:updateKeyStatus", function(player, key)
    while true do
        if IsControlJustReleased(0, key.key) then
            TriggerServerEvent('Ox-Fair:pressIn', player)
            break
        end
        Citizen.Wait(0)
    end
end)

function select(title)
    local choosed
    W.OpenDialog(title, 'ssss_sa', function(co)
        W.CloseDialog()
        choosed = co
    end, function()
        playing = false
        choosed = ''
    end)

    while choosed == nil do Citizen.Wait(200) end

    return choosed
end

function ReqAnimDict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end
end