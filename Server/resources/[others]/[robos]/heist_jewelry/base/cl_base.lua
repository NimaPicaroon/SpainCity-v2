VangelicoHeist = {
    ['startPeds'] = {},
    ['painting'] = {},
    ['gasMask'] = false,
    ['globalObject'] = nil,
    ['globalItem'] = nil,
}

StartHeist = function()
    W.TriggerCallback('Wave:GetPlayersJob', function(players)
        
        if players and #players >= 0 then
            
                TriggerEvent('character:getSkin', function(skin)
                    if skin and skin.bags_1 > 0 then
                        local random = 1
                        local glassConfig = Config['VangelicoInside']['glassCutting']
                        loadModel(glassConfig['rewards'][random]['object']['model'])
                        loadModel(glassConfig['rewards'][random]['displayObj']['model'])
                        loadModel('h4_prop_h4_glass_disp_01a')
                        local glass = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01a'), -617.4622, -227.4347, 37.057, 1, 1, 0)
                        SetEntityHeading(glass, -53.06)
                        local reward = CreateObject(GetHashKey(glassConfig['rewards'][random]['object']['model']), glassConfig['rewardPos'].xy, glassConfig['rewardPos'].z + 0.195, 1, 1, 0)
                        SetEntityHeading(reward, glassConfig['rewards'][random]['object']['rot'])
                        local rewardDisp = CreateObject(GetHashKey(glassConfig['rewards'][random]['displayObj']['model']), glassConfig['rewardPos'], 1, 1, 0)
                        SetEntityRotation(rewardDisp, glassConfig['rewards'][random]['displayObj']['rot'])
                        TriggerServerEvent('vangelicoheist:server:globalObject', glassConfig['rewards'][random]['object']['model'], random)
                
                        for k, v in pairs(Config['VangelicoInside']['painting']) do
                            loadModel(v['object'])
                            VangelicoHeist['painting'][k] = CreateObjectNoOffset(GetHashKey(v['object']), v['objectPos'], 1, 0, 0)
                            SetEntityRotation(VangelicoHeist['painting'][k], 0, 0, v['objHeading'], 2, true)
                        end
                
                        TriggerServerEvent('vangelicoheist:server:toggle', true)
                        TriggerServerEvent('vangelicoheist:server:insideLoop')
                        TriggerServerEvent('ZC-Dispatch:sendAlert', 'police', '¡La Joyería Vangelico está siendo robada, necesitamos refuerzos rápido!', GetEntityCoords(PlayerPedId()), GetPlayerServerId(PlayerId()), 'heist', 'jewelry')
                    
                        W.Notify('Joyería', '¡Estás robando la Joyería Vangelico!', 'info')
                    else
                        W.Notify('Joyería', 'Necesitas una mochila para poder hacer esto.', 'error')
                    end
                end)
        end
    end, 'police', true)
end

Citizen.CreateThread(function()
    while true do
        local msec = 1000

        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local playerWeapon = GetSelectedPedWeapon(playerPed)
        local OwnData = W.GetPlayerData()

        if playerPed and playerPos then
            local dist = #(playerPos - vec3(-628.47, -235.4, 38.06))

            if not GlobalState.ActiveHeist then
                if dist < 2.5 and AVAILABLE_WEAPONS[playerWeapon] and not GlobalState.HackingJewelry then
                    msec = 5

                    W.ShowText(vec3(-628.47, -235.4, 38.06), '~y~Joyería\n~w~Dispara', 0.6, 8)
                    if dist < 1.5 then
                        if IsPedShooting(playerPed) then
                            if OwnData.gang.name then
                                StartHeist()
                            else
                                W.Notify('Joyería', 'Para robar tienes que ser banda.', 'error')
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(msec)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(vec3(-628.47, -235.4, 38.06))
    SetBlipSprite(blip, 439)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Joyeria')
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('vangelicoheist:client:globalObject')
AddEventHandler('vangelicoheist:client:globalObject', function(obj, index)
    VangelicoHeist['globalObject'] = obj
    VangelicoHeist['globalItem'] = Config['VangelicoInside']['glassCutting']['rewards'][index]['item']
end)

RegisterNetEvent('vangelicoheist:client:insideLoop')
AddEventHandler('vangelicoheist:client:insideLoop', function()
    insideLoop = true
    inZone = false
    local shown = false
    Citizen.CreateThread(function()
        while insideLoop do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local sleep = 1000
            local dist = #(pedCo - vector3(-617.4622, -227.4347, 37.057))
            inZone = false

            if dist <= 1.5 and not Config['VangelicoInside']['glassCutting']['loot'] and not busy then
                sleep = 1
                inZone = true

                W.ShowText(vec3(-617.4622, -227.4347, 37.057 + 1.0), '~y~Joyería\n~w~Agujerear cristal', 0.6, 8)
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('character:getSkin', function(skin)
                        if skin.bags_1 > 0 then
                            OverheatScene()
                        else
                            W.Notify('Joyería', 'Necesitas una mochila para poder hacer esto.', 'error')
                        end
                    end)
                end
            end

            if dist >= 40.0 and robber then
                break
            end

            for k, v in pairs(Config['VangelicoInside']['painting']) do
                local dist = #(pedCo - v['objectPos'])

                if dist <= 1.5 and not v['loot'] and not busy then
                    sleep = 1

                    inZone = true
                    W.ShowText(vec3(v.objectPos.x, v.objectPos.y, v.objectPos.z), '~y~Vangelico\n~w~Cortar cuadro', 0.6, 8)
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('character:getSkin', function(skin)
                            if skin.bags_1 > 0 then
                                PaintingScene(k)
                            else
                                W.Notify('Joyería', 'Necesitas una mochila para poder hacer esto.', 'error')
                            end
                        end)
                    end
                end
            end

            for k, v in pairs(Config['VangelicoInside']['smashScenes']) do
                local dist = #(pedCo - v['objPos'])

                if dist <= 1.3 and not v['loot'] and not busy then
                    sleep = 1

                    inZone = true
                    W.ShowText(vec3(v.objPos.x, v.objPos.y, v.objPos.z), '~y~Vangelico\n~w~Romper vitrina', 0.6, 8)
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('character:getSkin', function(skin)
                            if skin.bags_1 > 0 then
                                Smash(k)
                            else
                                W.Notify('Joyería', 'Necesitas una mochila para poder hacer esto.', 'error')
                            end
                        end)
                    end
                end
            end

            if inZone and not shown then
                shown = true

                exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'smash_scenes_vangelico')
            elseif not inZone and shown then
                shown = false

                exports['ZC-HelpNotify']:close('smash_scenes_vangelico')
            end
            
            Citizen.Wait(1)
        end
    end)
end)

RegisterNetEvent('vangelicoheist:client:lootSync')
AddEventHandler('vangelicoheist:client:lootSync', function(type, index)
    if index then
        Config['VangelicoInside'][type][index]['loot'] = true
    else
        Config['VangelicoInside'][type]['loot'] = true
    end
end)

function PaintingScene(sceneId)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local shown = false
    if weapon ~= GetHashKey('WEAPON_SWITCHBLADE') then W.Notify('Joyería', '¿Cómo pretendes cortar este cuadro?', 'error') return end
    -- ESX.TriggerServerCallback('vangelicoheist:server:hasItem', function(hasItem, itemLabel)
    --     if hasItem then
            TriggerServerEvent('vangelicoheist:server:lootSync', 'painting', sceneId)
            robber = true
            busy = true
            local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)
            local scenes = {false, false, false, false}
            local animDict = "anim_heist@hs3f@ig11_steal_painting@male@"
            scene = Config['VangelicoInside']['painting'][sceneId]
            sceneObject = GetClosestObjectOfType(scene['objectPos'], 1.0, GetHashKey(scene['object']), 0, 0, 0)
            scenePos = scene['scenePos']
            sceneRot = scene['sceneRot']
            loadAnimDict(animDict)
            
            for k, v in pairs(ArtHeist['objects']) do
                loadModel(v)
                ArtHeist['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)

                DeleteEntity(ArtHeist['sceneObjects'][1])
            end
            
            for i = 1, 10 do
                ArtHeist['scenes'][i] = NetworkCreateSynchronisedScene(scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 2, true, false, 1065353216, 0, 1065353216)
                NetworkAddPedToSynchronisedScene(ped, ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(sceneObject, ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][3], 1.0, -1.0, 1148846080)
                NetworkAddEntityToSynchronisedScene(ArtHeist['sceneObjects'][1], ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][4], 1.0, -1.0, 1148846080)
                NetworkAddEntityToSynchronisedScene(ArtHeist['sceneObjects'][2], ArtHeist['scenes'][i], animDict, 'ver_01_' .. ArtHeist['animations'][i][5], 1.0, -1.0, 1148846080)
            end

            cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
            SetCamActive(cam, true)
            RenderScriptCams(true, 0, 3000, 1, 0)
            
            ArtHeist['cuting'] = true
            FreezeEntityPosition(ped, true)
            NetworkStartSynchronisedScene(ArtHeist['scenes'][1])
            PlayCamAnim(cam, 'ver_01_top_left_enter_cam_ble', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            Wait(3000)
            NetworkStartSynchronisedScene(ArtHeist['scenes'][2])
            PlayCamAnim(cam, 'ver_01_cutting_top_left_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            repeat
                if not shown then
                    shown = true
                    exports['ZC-HelpNotify']:open('Usa <strong>FLECHA</strong> para cortar', 'cut_paint_vangelico')
                end

                if IsControlJustPressed(0, 175) then
                    scenes[1] = true
                    shown = false
                    exports['ZC-HelpNotify']:close('cut_paint_vangelico')
                end
                Wait(1)
            until scenes[1] == true
            NetworkStartSynchronisedScene(ArtHeist['scenes'][3])
            PlayCamAnim(cam, 'ver_01_cutting_top_left_to_right_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            Wait(3000)
            NetworkStartSynchronisedScene(ArtHeist['scenes'][4])
            PlayCamAnim(cam, 'ver_01_cutting_top_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            repeat
                if not shown then
                    shown = true
                    exports['ZC-HelpNotify']:open('Usa <strong>FLECHA</strong> para cortar', 'cut_paint_vangelico')
                end
                if IsControlJustPressed(0, 173) then
                    scenes[2] = true
                    shown = false
                    exports['ZC-HelpNotify']:close('cut_paint_vangelico')
                end
                Wait(1)
            until scenes[2] == true
            NetworkStartSynchronisedScene(ArtHeist['scenes'][5])
            PlayCamAnim(cam, 'ver_01_cutting_right_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            Wait(3000)
            NetworkStartSynchronisedScene(ArtHeist['scenes'][6])
            PlayCamAnim(cam, 'ver_01_cutting_bottom_right_idle_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            repeat
                if not shown then
                    shown = true
                    exports['ZC-HelpNotify']:open('Usa <strong>FLECHA</strong> para cortar', 'cut_paint_vangelico')
                end
                if IsControlJustPressed(0, 174) then
                    scenes[3] = true
                    shown = false
                    exports['ZC-HelpNotify']:close('cut_paint_vangelico')
                end
                Wait(1)
            until scenes[3] == true
            NetworkStartSynchronisedScene(ArtHeist['scenes'][7])
            PlayCamAnim(cam, 'ver_01_cutting_bottom_right_to_left_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            Wait(3000)
            repeat
                if not shown then
                    shown = true
                    exports['ZC-HelpNotify']:open('Usa <strong>FLECHA</strong> para cortar', 'cut_paint_vangelico')
                end
                if IsControlJustPressed(0, 173) then
                    scenes[4] = true
                    shown = false
                    exports['ZC-HelpNotify']:close('cut_paint_vangelico')
                end
                Wait(1)
            until scenes[4] == true
            NetworkStartSynchronisedScene(ArtHeist['scenes'][9])
            PlayCamAnim(cam, 'ver_01_cutting_left_top_to_bottom_cam', animDict, scenePos['xy'], scenePos['z'] - 1.0, sceneRot, 0, 2)
            Wait(1500)
            W.Progressbar("smash_vitrine", 'Guardando cuadro..', 9000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() end, function() end)
            NetworkStartSynchronisedScene(ArtHeist['scenes'][10])
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            Wait(7500)
            TriggerServerEvent('vangelicoheist:server:rewardItem', scene['rewardItem'], 1)
            ClearPedTasks(ped)
            FreezeEntityPosition(ped, false)
            RemoveAnimDict(animDict)
            for k, v in pairs(ArtHeist['sceneObjects']) do
                DeleteObject(v)
            end
            DeleteObject(sceneObject)
            DeleteEntity(sceneObject)
            ArtHeist['sceneObjects'] = {}
            ArtHeist['scenes'] = {}
            scenes = {false, false, false, false}
            busy = false
    --     else
    --         ShowNotification(Strings['need_this'] .. itemLabel)
    --     end
    -- end, Config['VangelicoHeist']['requiredItems'][2])
end

function OverheatScene()
    -- ESX.TriggerServerCallback('vangelicoheist:server:hasItem', function(hasItem, itemLabel)
    --     if hasItem then
            TriggerServerEvent('vangelicoheist:server:lootSync', 'glassCutting')
            robber = true
            busy = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@scripted@heist@ig16_glass_cut@male@'
            sceneObject = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)
            globalObj = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 5.0, GetHashKey(VangelicoHeist['globalObject']), 0, 0, 0)
            loadAnimDict(animDict)
            RequestScriptAudioBank('DLC_HEI4/DLCHEI4_GENERIC_01', -1)

            cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
            SetCamActive(cam, true)
            RenderScriptCams(true, 0, 3000, 1, 0)

            for k, v in pairs(Overheat['objects']) do
                loadModel(v)
                Overheat['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)

                DeleteEntity(Overheat['sceneObjects'][1])
            end

            local newObj = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01b'), GetEntityCoords(sceneObject), 1, 1, 0)
            SetEntityHeading(newObj, GetEntityHeading(sceneObject))

            for i = 1, #Overheat['animations'] do
                Overheat['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(ped, Overheat['scenes'][i], animDict, Overheat['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(Overheat['sceneObjects'][1], Overheat['scenes'][i], animDict, Overheat['animations'][i][2], 1.0, -1.0, 1148846080)
                NetworkAddEntityToSynchronisedScene(Overheat['sceneObjects'][2], Overheat['scenes'][i], animDict, Overheat['animations'][i][3], 1.0, -1.0, 1148846080)
                if i ~= 5 then
                    NetworkAddEntityToSynchronisedScene(sceneObject, Overheat['scenes'][i], animDict, Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
                else
                    NetworkAddEntityToSynchronisedScene(newObj, Overheat['scenes'][i], animDict, Overheat['animations'][i][4], 1.0, -1.0, 1148846080)
                end
            end

            local sound1 = GetSoundId()
            local sound2 = GetSoundId()

            NetworkStartSynchronisedScene(Overheat['scenes'][1])
            PlayCamAnim(cam, 'enter_cam', animDict, scenePos, sceneRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'enter') * 1000)

            NetworkStartSynchronisedScene(Overheat['scenes'][2])
            PlayCamAnim(cam, 'idle_cam', animDict, scenePos, sceneRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'idle') * 1000)

            NetworkStartSynchronisedScene(Overheat['scenes'][3])
            PlaySoundFromEntity(sound1, "StartCutting", Overheat['sceneObjects'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
            loadPtfxAsset('scr_ih_fin')
            UseParticleFxAssetNextCall('scr_ih_fin')
            fire1 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_cut', Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0, 1065353216, 1065353216, 1065353216, 0)
            PlayCamAnim(cam, 'cutting_loop_cam', animDict, scenePos, sceneRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'cutting_loop') * 1000)
            StopSound(sound1)
            StopParticleFxLooped(fire1)

            NetworkStartSynchronisedScene(Overheat['scenes'][4])
            PlaySoundFromEntity(sound2, "Overheated", Overheat['sceneObjects'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
            UseParticleFxAssetNextCall('scr_ih_fin')
            fire2 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_overheat', Overheat['sceneObjects'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0)
            PlayCamAnim(cam, 'overheat_react_01_cam', animDict, scenePos, sceneRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'overheat_react_01') * 1000)
            StopSound(sound2)
            StopParticleFxLooped(fire2)

            DeleteObject(sceneObject)
            NetworkStartSynchronisedScene(Overheat['scenes'][5])
            Wait(2000)
            DeleteObject(globalObj)
            TriggerServerEvent('vangelicoheist:server:rewardItem', VangelicoHeist['globalItem'], 1)
            PlayCamAnim(cam, 'success_cam', animDict, scenePos, sceneRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'success') * 1000 - 2000)
            DeleteObject(Overheat['sceneObjects'][2])
            ClearPedTasks(ped)
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            busy = false
    --     else
    --         ShowNotification(Strings['need_this'] .. itemLabel)
    --     end
    -- end, Config['VangelicoHeist']['requiredItems'][1])
end

local prevAnim = ''
function Smash(index)
    local ped = PlayerPedId()
    local weapon = false

    if not AVAILABLE_WEAPONS[GetSelectedPedWeapon(ped)] then
        W.Notify('Joyería', '¿Cómo pretendes romper esta vitrina?', 'error')
        
        return 
    end

    robber = true
    busy = true
    TriggerServerEvent('vangelicoheist:server:lootSync', 'smashScenes', index)
    local pedCo = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    local animDict = 'missheist_jewel'
    local ptfxAsset = "scr_jewelheist"
    local particleFx = "scr_jewel_cab_smash"
    loadAnimDict(animDict)
    loadPtfxAsset(ptfxAsset)
    local sceneConfig = Config['VangelicoInside']['smashScenes'][index]
    SetEntityCoords(ped, sceneConfig['scenePos'])
    local anims = {
        {'smash_case_necklace', 300},
        {'smash_case_d', 300},
        {'smash_case_e', 300},
        {'smash_case_f', 300}
    }
    local selected = ''
    repeat
        selected = anims[math.random(1, #anims)]
    until selected ~= prevAnim
    prevAnim = selected

    if index == 4 or index == 10 or index == 14 or index == 8 then
        selected = {'smash_case_necklace_skull', 300}
    end
    
    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 0, 0, 0)
    
    W.Progressbar("smash_vitrine", 'Rompiendo vitrina..', GetAnimDuration(animDict, selected[1]) * 1000 - 1000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() end, function() end)
    scene = NetworkCreateSynchronisedScene(sceneConfig['scenePos'], sceneConfig['sceneRot'], 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene, animDict, selected[1], 2.0, 4.0, 1, 0, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
    PlayCamAnim(cam, 'cam_' .. selected[1], animDict, sceneConfig['scenePos'], sceneConfig['sceneRot'], 0, 2)

    Wait(300)

    TriggerServerEvent('vangelicoheist:server:smashSync', sceneConfig)
    for i = 1, 5 do
        PlaySoundFromCoord(-1, "Glass_Smash", sceneConfig['objPos'], 0, 0, 0)
    end
    SetPtfxAssetNextCall(ptfxAsset)
    StartNetworkedParticleFxNonLoopedAtCoord(particleFx, sceneConfig['objPos'], 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
    Wait(GetAnimDuration(animDict, selected[1]) * 1000 - 1000)
    random = math.random(1, #Config['VangelicoHeist']['smashRewards'])
    TriggerServerEvent('vangelicoheist:server:rewardItem', Config['VangelicoHeist']['smashRewards'][random]['item'], math.random(2, 3))
    ClearPedTasks(PlayerPedId())
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    busy = false
end

RegisterNetEvent('vangelicoheist:client:smashSync')
AddEventHandler('vangelicoheist:client:smashSync', function(sceneConfig)
    CreateModelSwap(sceneConfig['objPos'], 0.3, GetHashKey(sceneConfig['oldModel']), GetHashKey(sceneConfig['newModel']), 1)
end)

--Thanks to d0p3t
function PlayCutscene(cut, coords)
    while not HasThisCutsceneLoaded(cut) do 
        RequestCutscene(cut, 8)
        Wait(0) 
    end
    CreateCutscene(false, coords)
    Finish(coords)
    RemoveCutscene()
    DoScreenFadeIn(500)
end

function CreateCutscene(change, coords)
    local ped = PlayerPedId()
        
    local clone = ClonePedEx(ped, 0.0, false, true, 1)
    local clone2 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone3 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone4 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone5 = ClonePedEx(ped, 0.0, false, true, 1)

    SetBlockingOfNonTemporaryEvents(clone, true)
    SetEntityVisible(clone, false, false)
    SetEntityInvincible(clone, true)
    SetEntityCollision(clone, false, false)
    FreezeEntityPosition(clone, true)
    SetPedHelmet(clone, false)
    RemovePedHelmet(clone, true)
    
    if change then
        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_2', 0, GetEntityModel(ped), 64)
        
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_1', 0, GetEntityModel(clone2), 64)
    else
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)

        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_2', 0, GetEntityModel(clone2), 64)
    end

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(clone3, 'MP_3', 0, GetEntityModel(clone3), 64)
    
    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(clone4, 'MP_4', 0, GetEntityModel(clone4), 64)
    
    SetCutsceneEntityStreamingFlags('MP_5', 0, 1)
    RegisterEntityForCutscene(clone5, 'MP_5', 0, GetEntityModel(clone5), 64)
    
    Wait(10)
    if coords then
        StartCutsceneAtCoords(coords, 0)
    else
        StartCutscene(0)
    end
    Wait(10)
    ClonePedToTarget(clone, ped)
    Wait(10)
    DeleteEntity(clone)
    DeleteEntity(clone2)
    DeleteEntity(clone3)
    DeleteEntity(clone4)
    DeleteEntity(clone5)
    Wait(50)
    DoScreenFadeIn(250)
end

function Finish(coords)
    if coords then
        local tripped = false
        repeat
            Wait(0)
            if (timer and (GetCutsceneTime() > timer))then
                DoScreenFadeOut(250)
                tripped = true
            end
            if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
            DoScreenFadeOut(250)
            tripped = true
            end
        until not IsCutscenePlaying()
        if (not tripped) then
            DoScreenFadeOut(100)
            Wait(150)
        end
        return
    else
        Wait(18500)
        StopCutsceneImmediately()
    end
end

RegisterNetEvent('vangelicoheist:client:resetHeist')
AddEventHandler('vangelicoheist:client:resetHeist', function()
    insideLoop = false
    gasLoop = false
    for k, v in pairs(Config['VangelicoInside']['smashScenes']) do
        v['loot'] = false
        CreateModelSwap(v['objPos'], 0.3, GetHashKey(v['newModel']), GetHashKey(v['oldModel']), 1)
    end
    for k, v in pairs(Config['VangelicoInside']['painting']) do
        v['loot'] = false
        object = GetClosestObjectOfType(v['objectPos'], 1.0, GetHashKey(v['object']), 0, 0, 0)
        DeleteObject(object)
    end
    Config['VangelicoInside']['glassCutting']['loot'] = false
    glassObjectDel = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
    glassObjectDel2 = GetClosestObjectOfType(-617.4622, -227.4347, 37.057, 1.0, GetHashKey('h4_prop_h4_glass_disp_01b'), 0, 0, 0)
    DeleteObject(glassObjectDel)
    DeleteObject(glassObjectDel2)
    StopParticleFxLooped(ptfx, 1)
end)

function Outside(index)
    ShowNotification(Strings['deliver_to_buyer'])
    loadModel('baller')
    buyerBlip = addBlip(Config['VangelicoHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
    buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['VangelicoHeist']['finishHeist']['buyerPos'].xy + 3.0, Config['VangelicoHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
    while true do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local dist = #(pedCo - Config['VangelicoHeist']['finishHeist']['buyerPos'])

        if dist <= 15.0 then
            PlayCutscene('hs3f_all_drp3', Config['VangelicoHeist']['finishHeist']['buyerPos'])
            DeleteVehicle(buyerVehicle)
            RemoveBlip(buyerBlip)
            TriggerServerEvent('vangelicoheist:server:sellRewardItems')
            break
        end
        Wait(1)
    end
end

function addBlip(coords, sprite, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Citizen.Wait(50)
	end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 50)
end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

RegisterNetEvent('vangelicoheist:client:showNotification')
AddEventHandler('vangelicoheist:client:showNotification', function(str)
    ShowNotification(str)
end)