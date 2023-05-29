----- CREAR SITIO TIROS ----


local bola2_x = -3.0
local bola2_y = -3.0
local basket_x = -6.0
local basket_y = -6.0

local playingball1 = false
local playingball2 = false
local playingbasket1 = false

local estanteria_prop = nil
local mapacargado = false


local pared1_basket_prop = nil

--]]
function loadmap()
    if not mapacargado then
        CreateThread(function()
            local techo = 'prop_gazebo_03'
            local estanteria = 'prop_shelves_02'
            local mesainicial = 'v_ilev_liconftable_sml'
            local pared = 'prop_fnclink_03c'
            local banderas = 'prop_irish_sign_01'
            local silla = 'prop_bar_stool_01'
            local taza = 'prop_tennis_ball'

            RequestModel(techo)
            RequestModel(estanteria)
            RequestModel(mesainicial)
            RequestModel(banderas)
            RequestModel(pared)
            RequestModel(silla)
            Wait(100)

            local silla_prop = CreateObject(silla, vector3(-1713.1, -1118.6, 12.1), false)
            FreezeEntityPosition(silla_prop, true)

            local banderas_prop = CreateObject(banderas, vector3(-1710.25, -1117.80, 14.7), false)
            FreezeEntityPosition(banderas_prop, true)
            SetEntityRotation(banderas_prop, 0.0, 0.0, 45.0, 0, true)
            
            local banderas2_prop = CreateObject(banderas, vector3(-1711.39, -1118.94, 14.7), false)
            FreezeEntityPosition(banderas2_prop, true)
            SetEntityRotation(banderas2_prop, 0.0, 0.0, 45.0, 0, true)

            local techo_prop = CreateObject(techo, vector3(-1709.5, -1119.9, 12.15 + 0.5), false)
            FreezeEntityPosition(techo_prop, true)
            SetEntityRotation(techo_prop, 0.0, 0.0, -45.0, 0, true)

            local techo_prop_interior = CreateObject(techo, vector3(-1709.5, -1119.9, 12.15 + 1.5), false)
            FreezeEntityPosition(techo_prop_interior, true)
            SetEntityRotation(techo_prop_interior, 180.0, 0.0, -45.0, 0, true)

            local techo_prop2 = CreateObject(techo, vector3(-1712.3, -1117.1, 12.15 + 0.5), false)
            FreezeEntityPosition(techo_prop2, true)
            SetEntityRotation(techo_prop2, 0.0, 0.0, -45.0, 0, true)

            local techo_prop_interior2 = CreateObject(techo, vector3(-1712.3, -1117.1, 12.15 + 1.5), false)
            FreezeEntityPosition(techo_prop_interior2, true)
            SetEntityRotation(techo_prop_interior2, 180.0, 0.0, -45.0, 0, true)



            estanteria_prop = CreateObject(estanteria, vector3(-1708.47, -1120.84, 11.95), false)
            FreezeEntityPosition(estanteria_prop, true)
            SetEntityRotation(estanteria_prop, 0.0, 0.0, 45.0, 0, true)

            local estanteria_prop2 = CreateObject(estanteria, vector3(-1709.0, -1120.33, 11.45), false)
            FreezeEntityPosition(estanteria_prop2, true)
            SetEntityRotation(estanteria_prop2, 0.0, 0.0, 45.0, 0, true)

            local pared1_prop = CreateObject(pared, vector3(-1715.04, -1117.07, 11.80), false)
            FreezeEntityPosition(pared1_prop, true)
            SetEntityRotation(pared1_prop, 0.0, 0.0, -45.0, 0, true)

            local pared2_prop = CreateObject(pared, vector3(-1711.02, -1121.09, 11.80), false)
            FreezeEntityPosition(pared2_prop, true)
            SetEntityRotation(pared2_prop, 0.0, 0.0, -45.0, 0, true)

            local pared3_prop = CreateObject(pared, vector3(-1712.28, -1114.43, 11.80), false)
            FreezeEntityPosition(pared3_prop, true)
            SetEntityRotation(pared3_prop, 0.0, 0.0, -45.0, 0, true)

            local pared4_prop = CreateObject(pared, vector3(-1708.30, -1118.40, 11.80), false)
            FreezeEntityPosition(pared4_prop, true)
            SetEntityRotation(pared4_prop, 0.0, 0.0, -45.0, 0, true)

            local mesainicial_prop = CreateObject(mesainicial, vector3(-1712.80, -1115.53, 12.15), false)
            FreezeEntityPosition(mesainicial_prop, true)
            SetEntityRotation(mesainicial_prop, 0.0, 0.0, -45.0, 0, true)

            mesainicial2_prop = CreateObject(mesainicial, vector3(-1713.90, -1116.61, 12.15), false)
            FreezeEntityPosition(mesainicial2_prop, true)
            SetEntityRotation(mesainicial2_prop, 0.0, 0.0, -45.0, 0, true)

            ------------------------------------------------------------------

            local silla_prop = CreateObject(silla, vector3(-1713.1 + bola2_x, -1118.6 + bola2_y, 12.1), false)
            FreezeEntityPosition(silla_prop, true)

            local banderas_prop = CreateObject(banderas, vector3(-1710.25 + bola2_x, -1117.80 + bola2_y, 14.7), false)
            FreezeEntityPosition(banderas_prop, true)
            SetEntityRotation(banderas_prop, 0.0, 0.0, 45.0, 0, true)
            
            local banderas2_prop = CreateObject(banderas, vector3(-1711.39 + bola2_x, -1118.94 + bola2_y, 14.7), false)
            FreezeEntityPosition(banderas2_prop, true)
            SetEntityRotation(banderas2_prop, 0.0, 0.0, 45.0, 0, true)

            local techo_prop = CreateObject(techo, vector3(-1709.5 + bola2_x, -1119.9 + bola2_y, 12.15 + 0.5), false)
            FreezeEntityPosition(techo_prop, true)
            SetEntityRotation(techo_prop, 0.0, 0.0, -45.0, 0, true)

            local techo_prop_interior = CreateObject(techo, vector3(-1709.5 + bola2_x, -1119.9 + bola2_y, 12.15 + 1.5), false)
            FreezeEntityPosition(techo_prop_interior, true)
            SetEntityRotation(techo_prop_interior, 180.0, 0.0, -45.0, 0, false)

            local techo_prop2 = CreateObject(techo, vector3(-1712.3 + bola2_x, -1117.1 + bola2_y, 12.15 + 0.5), false)
            FreezeEntityPosition(techo_prop2, true)
            SetEntityRotation(techo_prop2, 0.0, 0.0, -45.0, 0, true)

            local techo_prop_interior2 = CreateObject(techo, vector3(-1712.3 + bola2_x, -1117.1 + bola2_y, 12.15 + 1.5), false)
            FreezeEntityPosition(techo_prop_interior2, true)
            SetEntityRotation(techo_prop_interior2, 180.0, 0.0, -45.0, 0, false)



            estanteria_prop = CreateObject(estanteria, vector3(-1708.47 + bola2_x, -1120.84 + bola2_y, 11.95), false)
            FreezeEntityPosition(estanteria_prop, true)
            SetEntityRotation(estanteria_prop, 0.0, 0.0, 45.0, 0, true)

            local estanteria_prop2 = CreateObject(estanteria, vector3(-1709.0 + bola2_x, -1120.33 + bola2_y, 11.45), false)
            FreezeEntityPosition(estanteria_prop2, true)
            SetEntityRotation(estanteria_prop2, 0.0, 0.0, 45.0, 0, true)

            local pared1_prop = CreateObject(pared, vector3(-1715.04 + bola2_x, -1117.07 + bola2_y, 11.80), false)
            FreezeEntityPosition(pared1_prop, true)
            SetEntityRotation(pared1_prop, 0.0, 0.0, -45.0, 0, true)

            local pared2_prop = CreateObject(pared, vector3(-1711.02 + bola2_x, -1121.09 + bola2_y, 11.80), false)
            FreezeEntityPosition(pared2_prop, true)
            SetEntityRotation(pared2_prop, 0.0, 0.0, -45.0, 0, true)

            local pared3_prop = CreateObject(pared, vector3(-1712.28 + bola2_x, -1114.43 + bola2_y, 11.80), false)
            FreezeEntityPosition(pared3_prop, true)
            SetEntityRotation(pared3_prop, 0.0, 0.0, -45.0, 0, true)

            local pared4_prop = CreateObject(pared, vector3(-1708.30 + bola2_x, -1118.40 + bola2_y, 11.80), false)
            FreezeEntityPosition(pared4_prop, true)
            SetEntityRotation(pared4_prop, 0.0, 0.0, -45.0, 0, true)

            local mesainicial_prop = CreateObject(mesainicial, vector3(-1712.80 + bola2_x, -1115.53 + bola2_y, 12.15), false)
            FreezeEntityPosition(mesainicial_prop, true)
            SetEntityRotation(mesainicial_prop, 0.0, 0.0, -45.0, 0, true)

            local mesainicial2_prop = CreateObject(mesainicial, vector3(-1713.90 + bola2_x, -1116.61 + bola2_y, 12.15), false)
            FreezeEntityPosition(mesainicial2_prop, true)
            SetEntityRotation(mesainicial2_prop, 0.0, 0.0, -45.0, 0, true)

            -- Basket --

            local net = CreateObject("prop_basketball_net", vector3(-1714.6, -1125.9, 12.15), false)
            FreezeEntityPosition(net, true)
            SetEntityRotation(net, 0.0, 0.0, -135.0, 0, true)

            local mesainicial_basket_prop = CreateObject(mesainicial, vector3(-1712.80 + basket_x, -1115.53 + basket_y, 12.15), false)
            FreezeEntityPosition(mesainicial_basket_prop, true)
            SetEntityRotation(mesainicial_basket_prop, 0.0, 0.0, -45.0, 0, true)

            --local mesainicial2_bakset_prop = CreateObject(mesainicial, vector3(-1713.90 + basket_x, -1116.61 + basket_y, 12.15), true)
            --FreezeEntityPosition(mesainicial2_bakset_prop, true)
            --SetEntityRotation(mesainicial2_bakset_prop, 0.0, 0.0, -45.0, 0, true)

            pared1_basket_prop = CreateObject(pared, vector3(-1714.46, -1124.37, 11.80), false)
            FreezeEntityPosition(pared1_basket_prop, true)
            SetEntityRotation(pared1_basket_prop, 0.0, 0.0, -45.0, 0, true)

            pared2_basket_prop = CreateObject(pared, vector3(-1714.41, -1124.42, 11.80), false)
            FreezeEntityPosition(pared2_basket_prop, true)
            SetEntityRotation(pared2_basket_prop, 0.0, 0.0, 135.0, 0, true)

            pared1_basket_prop = CreateObject(pared, vector3(-1714.46 + -1.55, -1124.37 + -1.5, 11.80), false)
            FreezeEntityPosition(pared1_basket_prop, true)
            SetEntityRotation(pared1_basket_prop, 0.0, 0.0, -45.0, 0, true)

            pared2_basket_prop = CreateObject(pared, vector3(-1714.41 + -1.55, -1124.42 + -1.5, 11.80), false)
            FreezeEntityPosition(pared2_basket_prop, true)
            SetEntityRotation(pared2_basket_prop, 0.0, 0.0, 135.0, 0, true)

            pared1_top_basket_prop = CreateObject(pared, vector3(-1714.46 + -1.55, -1124.37 + -1.5, 13.40), false)
            FreezeEntityPosition(pared1_top_basket_prop, true)
            SetEntityRotation(pared1_top_basket_prop, 0.0, 0.0, -45.0, 0, true)

            pared2_top_basket_prop = CreateObject(pared, vector3(-1714.41 + -1.55, -1124.42 + -1.5, 13.40), false)
            FreezeEntityPosition(pared2_top_basket_prop, true)
            SetEntityRotation(pared2_top_basket_prop, 0.0, 0.0, 135.0, 0, true)
        end)
        mapacargado = true

        -- PED FERIA 1
            CreateThread(function()
                RequestModel(GetHashKey("u_m_m_aldinapoli"))
            
                while not HasModelLoaded(GetHashKey("u_m_m_aldinapoli")) do
                    Wait(1)
                end

                local npc = CreatePed(4, "u_m_m_aldinapoli", -1716.7, -1120.9, 12.15, 100, false, true)
                DecorSetInt(npc, 'SPAWNEDPED', 1)
                local coords = GetEntityCoords(npc)
                SetEntityHeading(npc, 100)
                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                RequestAnimDict("anim@amb@nightclub@peds@")

                while (not HasAnimDictLoaded("anim@amb@nightclub@peds@")) do			
                    Wait(1000)
                end
                    
                Wait(200)
                TaskPlayAnim(npc,"anim@amb@nightclub@peds@","rcmme_amanda1_stand_loop_cop",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
            end)
        -- PED FERIA 2
            CreateThread(function()
                RequestModel(GetHashKey("u_m_m_aldinapoli"))
                
                while not HasModelLoaded(GetHashKey("u_m_m_aldinapoli")) do
                    Wait(1)
                end

                local npc = CreatePed(4, "u_m_m_aldinapoli", -1713.7, -1117.9, 12.15, 100, false, true)
                DecorSetInt(npc, 'SPAWNEDPED', 1)
                local coords = GetEntityCoords(npc)
                SetEntityHeading(npc, 100)
                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                RequestAnimDict("anim@amb@nightclub@peds@")

                while (not HasAnimDictLoaded("anim@amb@nightclub@peds@")) do			
                Wait(1000)
                end
                    
                Wait(200)
                TaskPlayAnim(npc,"anim@amb@nightclub@peds@","rcmme_amanda1_stand_loop_cop",1.0, 1.0, -1, 9, 1.0, 0, 0, 0) --]]
            end)
    end
end
--
----- CREAR SITIO TIROS ----

AddEventHandler("wave-fair:bola:client:startmarker", function()
    local notified = false
    local inZone
    CreateThread(function()
        while true do
            local s = 1000
            if #(GetEntityCoords(PlayerPedId()) - vec3(-1714.2, -1115.2, 13.2)) < 60.0 then
                loadmap()
                if #(GetEntityCoords(PlayerPedId()) - vec3(-1714.2, -1115.2, 13.2)) < 1.5 then
                    s = 0
                    inZone = 'ball'
                    if not notified then
                        notified = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para jugar', 'interact_fair')
                    end
                    DrawMarker(1, -1714.0, -1115.4, 12.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 0, 153, 255, 255, false, true, 2, nil, nil, false)

                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("wave-fair:bola:server:checkplayer")
                        exports['ZC-HelpNotify']:close('interact_fair')
                        notified = false
                        break
                    end
                else
                    if inZone == 'ball' then
                        inZone = nil
                    end
                end
                if #(GetEntityCoords(PlayerPedId()) - vec3(-1714.2 + bola2_x, -1115.2 + bola2_y, 13.2)) < 1.5 then
                    s = 0
                    inZone = 'ball2'
                    if not notified then
                        notified = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para jugar', 'interact_fair')
                    end
                    DrawMarker(1, -1714.0 + bola2_x, -1115.4 + bola2_y, 12.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 0, 153, 255, 255, false, true, 2, nil, nil, false)

                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("wave-fair:bola:server:checkplayer2")
                        exports['ZC-HelpNotify']:close('interact_fair')
                        notified = false
                        break
                    end
                else
                    if inZone == 'ball2' then
                        inZone = nil
                    end
                end
                if #(GetEntityCoords(PlayerPedId()) - vec3(-1720.2, -1120.4, 13.2)) < 1.5 then
                    s = 0
                    inZone = 'basket'
                    if not notified then
                        notified = true
                        exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para jugar', 'interact_fair')
                    end
                    DrawMarker(1, -1719.3, -1121.0, 12.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 0, 153, 255, 255, false, true, 2, nil, nil, false)

                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("wave-fair:basket:server:checkplayer")
                        exports['ZC-HelpNotify']:close('interact_fair')
                        notified = false
                        break
                    end
                else
                    if inZone == 'basket' then
                        inZone = nil
                    end
                end
            end

            if notified and not inZone then
                notified = false
                exports['ZC-HelpNotify']:close('interact_fair')
            end

            Wait(s)
        end
    end)
end)

TriggerEvent("wave-fair:bola:client:startmarker")

RegisterNetEvent("wave-fair:bola:client:playerplaying")
AddEventHandler("wave-fair:bola:client:playerplaying", function()
    TriggerEvent("wave-fair:bola:client:startmarker")
end)

--local botella = CreateObject("prop_box_guncase_02a", vector3(-1708.25, -1119.73, 13.30), true)

RegisterNetEvent("wave-fair:bola:client:startminigame1")
AddEventHandler("wave-fair:bola:client:startminigame1", function()
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
    playingball1 = true
    local puntos = 0
    tiros_restantes = 5
    ClearAreaOfProjectiles(-1708.25, -1119.73, 13.30, 10.0, false, false, false, false)
    ClearArea(-1708.25, -1119.73, 13.30, 10.0, false, false, false, false)
    GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 200, false, true)
    local botella_fila1_1 = CreateObject("prop_amb_beer_bottle", vector3(-1708.0, -1120.70, 13.80), true)
    local botella_fila1_2 = CreateObject("prop_amb_beer_bottle", vector3(-1708.73, -1121.31, 13.80), true)
    local botella_fila2_1 = CreateObject("prop_amb_beer_bottle", vector3(-1708.18, -1119.67, 13.30), true)
    local botella_fila2_2 = CreateObject("prop_amb_beer_bottle", vector3(-1708.90, -1120.47, 13.30), true)
    local botella_fila2_3 = CreateObject("prop_amb_beer_bottle", vector3(-1709.75, -1121.08, 13.30), true)

    --local bloqueador = CreateObject("prop_elecbox_06a", vector3(-1708.75 - 0.5, -1121.60, 12.4), false)
    FreezeEntityPosition(bloqueador, true)
    SetEntityRotation(bloqueador, 0.0, 0.0, -45.0, 0, true)

    CreateThread(function()
        while playingball1 do
            if #(GetEntityCoords(PlayerPedId()) - vec3(-1714.2, -1115.2, 13.2)) > 3.5 then
                W.Notify('Feria', "¡Te has alejado demasiado de la caseta!")
                playingball1 = false
                break
            end
            Wait(1000)
        end
    end)

    while true do
        if playingball1 then
            if IsPedShooting(PlayerPedId()) then
                tiros_restantes = tiros_restantes - 1

                if tiros_restantes == 0 then
                    break
                end

                GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 200, false, true)
            end
        else
            break
        end
        Wait(1)
    end

    Wait(1000)
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    if #(GetEntityCoords(botella_fila1_1) - vec3(-1708.0, -1120.70, 13.80)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila1_2) - vec3(-1708.73, -1121.31, 13.80)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila2_1) - vec3(-1708.18, -1119.67, 13.30)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila2_2) - vec3(-1708.90, -1120.47, 13.30)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila2_3) - vec3(-1709.75, -1121.08, 13.30)) > 0.2 then puntos = puntos + 1 end

    playingball1 = false
    W.Notify('FERIA',"Puntos: ~g~" .. puntos)
    Wait(3000)

    DeleteObject(botella_fila1_1)
    DeleteObject(botella_fila1_2)
    DeleteObject(botella_fila2_1)
    DeleteObject(botella_fila2_2)
    DeleteObject(botella_fila2_3)

    TriggerServerEvent("wave-fair:bola:server:gamefinalized1")
    TriggerEvent("wave-fair:bola:client:startmarker")
end)

RegisterNetEvent("wave-fair:bola:client:startminigame2")
AddEventHandler("wave-fair:bola:client:startminigame2", function()
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
    playingball2 = true
    local puntos = 0
    tiros_restantes = 5
    ClearAreaOfProjectiles(-1708.25 + bola2_x, -1119.73 + bola2_y, 13.30, 10.0, false, false, false, false)
    ClearArea(-1708.25 + bola2_x, -1119.73 + bola2_y, 13.30, 10.0, false, false, false, false)
    GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 200, false, true)
    local botella_fila1_1 = CreateObject("prop_amb_beer_bottle", vector3(-1708.0 + bola2_x, -1120.70 + bola2_y, 13.80), true)
    local botella_fila1_2 = CreateObject("prop_amb_beer_bottle", vector3(-1708.73 + bola2_x, -1121.31 + bola2_y, 13.80), true)
    local botella_fila2_1 = CreateObject("prop_amb_beer_bottle", vector3(-1708.18 + bola2_x, -1119.67 + bola2_y, 13.30), true)
    local botella_fila2_2 = CreateObject("prop_amb_beer_bottle", vector3(-1708.90 + bola2_x, -1120.47 + bola2_y, 13.30), true)
    local botella_fila2_3 = CreateObject("prop_amb_beer_bottle", vector3(-1709.75 + bola2_x, -1121.08 + bola2_y, 13.30), true)
    FreezeEntityPosition(bloqueador, true)
    SetEntityRotation(bloqueador, 0.0, 0.0, -45.0, 0, true)

    CreateThread(function()
        while playingball2 do
            if #(GetEntityCoords(PlayerPedId()) - vec3(-1714.2 + bola2_x, -1115.2 + bola2_y, 13.2)) > 3.5 then
                W.Notify('Feria', "¡Te has alejado demasiado de la caseta!")
                playingball2 = false
                break
            end
            Wait(1000)
        end
    end)

    while true do
        if playingball2 then
            if IsPedShooting(PlayerPedId()) then
                tiros_restantes = tiros_restantes - 1

                if tiros_restantes == 0 then
                    break
                end

                GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 200, false, true)
            end
        else
            break
        end
        Wait(1)
    end

    Wait(1000)
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    if #(GetEntityCoords(botella_fila1_1) - vec3(-1708.0 + bola2_x, -1120.70 + bola2_y, 13.80)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila1_2) - vec3(-1708.73 + bola2_x, -1121.31 + bola2_y, 13.80)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila2_1) - vec3(-1708.18 + bola2_x, -1119.67 + bola2_y, 13.30)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila2_2) - vec3(-1708.90 + bola2_x, -1120.47 + bola2_y, 13.30)) > 0.2 then puntos = puntos + 1 end
    if #(GetEntityCoords(botella_fila2_3) - vec3(-1709.75 + bola2_x, -1121.08 + bola2_y, 13.30)) > 0.2 then puntos = puntos + 1 end

    playingball2 = false
    W.Notify('FERIA',"Puntos: ~g~" .. puntos)
    Wait(3000)

    DeleteObject(botella_fila1_1)
    DeleteObject(botella_fila1_2)
    DeleteObject(botella_fila2_1)
    DeleteObject(botella_fila2_2)
    DeleteObject(botella_fila2_3)

    TriggerServerEvent("wave-fair:bola:server:gamefinalized2")
    TriggerEvent("wave-fair:bola:client:startmarker")
end)

local acciertos_basket = 0

RegisterNetEvent("wave-fair:basket:client:startgame1")
AddEventHandler("wave-fair:basket:client:startgame1", function()
    -- Fisicas Aro
    playingbasket1 = true

    local taza1 = nil
    local taza2 = nil
    local taza3 = nil
    local taza4 = nil
    local taza5 = nil
    local taza6 = nil
    local taza7 = nil

        CreateThread(function()
            acciertos_basket = 0
            local taza = 'prop_tennis_ball'

            RequestModel(taza)
            Wait(100)

            taza1 = CreateObject(taza, vector3(-1715.3, -1124.81, 15.16), true)
            FreezeEntityPosition(taza1, true)
            taza2 = CreateObject(taza, vector3(-1715.63, -1124.97, 15.16), true)
            FreezeEntityPosition(taza2, true)
            taza3 = CreateObject(taza, vector3(-1715.64, -1125.3, 15.16), true)
            FreezeEntityPosition(taza3, true)
            taza4 = CreateObject(taza, vector3(-1715.03, -1125.0, 15.16), true)
            FreezeEntityPosition(taza4, true)
            taza5 = CreateObject(taza, vector3(-1715.4, -1125.48, 15.16), true)
            FreezeEntityPosition(taza5, true)
            taza6 = CreateObject(taza, vector3(-1715.49, -1124.85, 15.16), true)
            FreezeEntityPosition(taza6, true)
            taza7 = CreateObject(taza, vector3(-1715.64, -1125.14, 15.16), true)
            FreezeEntityPosition(taza7, true)

            Wait(50)


            SetEntityVisible(taza1, false, 0)
            SetEntityVisible(taza2, false, 0)
            SetEntityVisible(taza3, false, 0)
            SetEntityVisible(taza4, false, 0)
            SetEntityVisible(taza5, false, 0)
            SetEntityVisible(taza6, false, 0)
            SetEntityVisible(taza7, false, 0)
        end)
    -- Fisicas Aro

    local tiros = 5
    SetFollowPedCamViewMode(4)
    ShakeGameplayCam("DRUNK_SHAKE", 0.3)

    CreateThread(function()
        while playingbasket1 do
            if #(GetEntityCoords(PlayerPedId()) - vec3(-1720.2, -1120.4, 13.2)) > 3.0 then
                W.Notify('Feria', "¡Te has alejado demasiado de la canasta!")
                playingbasket1 = false
                exports['ZC-HelpNotify']:close('interact_fair')
                break
            end
            Wait(1000)
        end
    end)
    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para tirar', 'interact_fair2')
    while tiros >= 1 do
        if playingbasket1 then
            if IsControlJustPressed(0, 38) then
                tiros = tiros - 1
                tirolibre()
                Wait(3000)
            end
            Wait(1)
        else
            break
        end
    end
    exports['ZC-HelpNotify']:close('interact_fair2')
    playingbasket1 = false
    W.Notify('Feria', "Puntos: ~g~" .. acciertos_basket)
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)

    DeleteObject(taza1)
    DeleteObject(taza2)
    DeleteObject(taza3)
    DeleteObject(taza4)
    DeleteObject(taza5)
    DeleteObject(taza6)
    DeleteObject(taza7)

    Wait(3000)


    TriggerServerEvent("wave-fair:basket:server:gamefinalized1")
    TriggerEvent("wave-fair:bola:client:startmarker")
end)

    function tirolibre()
        CreateThread(function()
            ingame = true

            if not HasModelLoaded("prop_bskball_01") then
                -- If the model isnt loaded we request the loading of the model and wait that the model is loaded
                RequestModel("prop_bskball_01")
            
                while not HasModelLoaded("prop_bskball_01") do
                    Wait(1)
                end
            end

            SetFollowPedCamViewMode(4)

            local ball_basket_player = CreateObject("prop_bskball_01", vector3(-1718.9, -1121.1, 13.1), true)
            SetAnimRate(ball_basket_player, 5.0, 0, 0)

            cameraRotation = GetGameplayCamRot()
            direction = RotationToDirection(cameraRotation)

            ApplyForceToEntity(ball_basket_player, 1, direction.x * 18, direction.y * 18, direction.z * 30, 0.1, 0.1, 0.1, 1, false, true, true, true, true)

            CreateThread(function()
                while ingame do
                    if #(GetEntityCoords(ball_basket_player) - vector3(-1715.35, -1125.14, 15.12)) < 0.15 then
                        acciertos_basket = acciertos_basket + 1

                        PlaySoundFromCoord(-1, "CHECKPOINT_AHEAD", -1715.35, -1125.14, 15.12, "HUD_MINI_GAME_SOUNDSET", 1, true)
                        --PlaySound(2, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET")
                        SetPtfxAssetNextCall("core")
                        StartNetworkedParticleFxNonLoopedAtCoord("ent_ray_prologue_elec_crackle_sp", -1715.35, -1125.14, 15.12, 0.0, 0.0, 0.0, 1.50, false, false, false, false)
                        break
                    end
                    Wait(1)
                end
            end)

            Wait(3000)
            ingame = false

            SetPtfxAssetNextCall("core")
            StartNetworkedParticleFxNonLoopedOnEntity("exp_grd_vehicle_lod", ball_basket_player, 0.0, 0.0, 0.0, 2.50, false, false, false, false)

            Wait(1)
            DeleteObject(ball_basket_player)
        end)
    end

    function RayCastGamePlayCamera(distance)
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

    function RayCastPed(pos,distance,ped)
        local cameraRotation = GetGameplayCamRot()
        local direction = RotationToDirection(cameraRotation)
        local destination = 
        { 
            x = pos.x + direction.x * distance, 
            y = pos.y + direction.y * distance, 
            z = pos.z + direction.z * distance 
        }

        local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(pos.x, pos.y, pos.z, destination.x, destination.y, destination.z, -1, ped, 1))
        return b, c
    end
--]]

AddEventHandler('playerDropped', function()
    if playingball1 then
        TriggerServerEvent("wave-fair:bola:server:gamefinalized1")
    elseif playingball2 then
        TriggerServerEvent("wave-fair:bola:server:gamefinalized2")
    elseif playingbasket1 then
        TriggerServerEvent("wave-fair:basket:server:gamefinalized1")
    end
end)  

loadmap()