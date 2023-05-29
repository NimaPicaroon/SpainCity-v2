SmokeController = setmetatable({ }, SmokeController)
SmokeController._variables = {
    smoking = false,
    smokeNet = nil,
    cigarette = nil,
    duration = 0,
    smokeds = 0
}
SmokeController.__index = SmokeController

exports('isBusy', function()
    return SmokeController._variables.smoking
end)

SmokeController._variables.startSmoke = function(typeSmoke)
    if not SmokeController._variables.smoking then
        W.Notify('Tabaco', 'No puedes hacer ahora esto', 'error')
        return
    end
    
    if exports['Ox-Needs']:isBusy() then
        W.Notify('Tabaco', 'No puedes hacer ahora esto', 'error')
        return
    end

    local self = {}
    self.shown = false
    self.smokeds = math.random(10, 13)
    self.typeSmoke = typeSmoke
    self.label = 'cigarro'
    self.first = false

    if self.typeSmoke == 'joint' then
        self.label = 'porro'
    end

    while SmokeController._variables.smoking do
        if self.smokeds <= 0 then
            if self.typeSmoke == 'joint' then
                SmokeController._variables.smokeds = SmokeController._variables.smokeds + 1
            end

            SmokeController._variables.smoking = false
            W.Notify('Tabaco', 'Te has ~y~terminado~w~ el ~y~'..self.label..'~w~.', 'verify')

            if SmokeController._variables.smokeds >= 4 then
                local random = math.random(1, 3)

                if random == 3 then
                    SetEntityHealth(PlayerPedId(), 0)
                else
                    W.Notify('Tabaco', '¡Tranquilizate con los porros que puede darte un amarillo!', 'info')
                end
            end

            DetachEntity(SmokeController._variables.cigarette, 1, 1)
            DeleteObject(SmokeController._variables.cigarette)

            if self.shown then
                exports['ZC-HelpNotify']:close('interact_smoke')
                exports['ZC-HelpNotify']:close('interact_throwsmoke')
            end
        end

        local playerPed = PlayerPedId()
        DisableControlAction(0, 229, true)
        DisableControlAction(0, 223, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 347, true)

        if not self.shown then
            self.shown = true

            exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para fumar', 'interact_smoke')
            exports['ZC-HelpNotify']:open('Usa <strong>X</strong> para tirar el '..self.label..'', 'interact_throwsmoke')
        end

        if IsControlJustPressed(0, 246) and self.smokeds > 0 then -- button to smoke
            RequestAnimDict('amb@world_human_aa_smoke@male@idle_a')
            while not HasAnimDictLoaded('amb@world_human_aa_smoke@male@idle_a') do 
                Citizen.Wait(0)
            end
    
            TaskPlayAnim(playerPed, 'amb@world_human_aa_smoke@male@idle_a', 'idle_c', 1.0, -1.0, 4000, 49, 1, false, false, false)
            RemoveAnimDict('amb@world_human_aa_smoke@male@idle_a')
            Wait(4000)
            ClearPedTasks(playerPed)
            self.smokeds = self.smokeds - 1

            print(self.typeSmoke)
            if self.typeSmoke == 'joint' then
                if not self.first then
                    local identity = W.GetPlayerData().identity
                    
                    self.first = true
                    ExecuteCommand('do Empezaría a oler a porro alrededor de '..identity.name..' '..identity.lastname..'.')
                end
            end

            if SmokeController._variables.duration <= 0 and self.typeSmoke == 'joint' then
                if self.smokeds <= 8 and self.typeSmoke == 'joint' then
                    SmokeController._variables.duration = SmokeController._variables.duration + (1 * 60 * 1000)
                end
            end

            if self.typeSmoke == 'joint' and self.smokeds <= 8 then
                Citizen.CreateThread(SmokeController.animations)
            end

            TriggerServerEvent('ZCore:removeStress', 2)
        end

        if IsControlJustPressed(0, 73) then -- throw the cigarette
            SmokeController._variables.smoking = false

            W.Notify('Tabaco', 'Has ~y~tirado~w~ el ~y~'..self.label..'~w~.', 'verify')
            DetachEntity(SmokeController._variables.cigarette, 1, 1)
            ClearPedTasks(playerPed)

            if self.shown then
                exports['ZC-HelpNotify']:close('interact_smoke')
                exports['ZC-HelpNotify']:close('interact_throwsmoke')
            end
        end

        if IsEntityInWater(playerPed) then
            SmokeController._variables.smoking = false
            W.Notify('Tabaco', 'Se te ha mojado el '..self.label..'', 'error')

            DetachEntity(SmokeController._variables.cigarette, 1, 1)
            DeleteObject(SmokeController._variables.cigarette)

            if self.shown then
                exports['ZC-HelpNotify']:close('interact_smoke')
                exports['ZC-HelpNotify']:close('interact_throwsmoke')
            end
        end

        Citizen.Wait(5)
    end
end

SmokeController.animations = function()
    local playerPed = PlayerPedId()

    while SmokeController._variables.duration > 0 do
        playerPed = PlayerPedId()
        SmokeController._variables.duration = SmokeController._variables.duration - 1

        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(playerPed, true)
        SetPedMovementClipset(playerPed, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
        SetPedIsDrunk(playerPed, true)
        SetPedAccuracy(playerPed, 0)
        DoScreenFadeIn(1000)            

        Wait(0)
    end 

    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)
end

SmokeController.useCigarrete = function(itemData, typeSmoke)
    if type(itemData) ~= 'table' then
        return
    end

    local self = {}
    self.itemData = itemData
    self.playerPed = PlayerPedId()
    self.playerPos = GetEntityCoords(self.playerPed)
    self.type = typeSmoke

    if SmokeController._variables.smoking then
        W.Notify('Tabaco', 'Ya estás fumando', 'error')
        
        return
    end

    if self.itemData then
        if self.type == 'cigarrete' then
            TriggerServerEvent('ZCore:removeItem', 1, self.itemData)
            RequestAnimDict('amb@world_human_smoking@male@male_a@enter')
            while not HasAnimDictLoaded('amb@world_human_smoking@male@male_a@enter') do 
                Citizen.Wait(0)
            end

            TaskPlayAnim(self.playerPed, 'amb@world_human_smoking@male@male_a@enter', 'enter', 1.0, -1.0, 1000, 49, 1, false, false, false)
            RemoveAnimDict('amb@world_human_smoking@male@male_a@enter')
            Citizen.Wait(1000)

            SmokeController._variables.cigarette = CreateObject(`ng_proc_cigarette01a`, self.playerPos.x, self.playerPos.y, self.playerPos.z + 0.9, true, true, true)
            AttachEntityToEntity(SmokeController._variables.cigarette, self.playerPed, GetPedBoneIndex(self.playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
            Citizen.Wait(800)

            local lighter = CreateObject(`p_cs_lighter_01`, self.playerPos.x, self.playerPos.y, self.playerPos.z + 0.9, true, true, true)
            AttachEntityToEntity(lighter, self.playerPed, GetPedBoneIndex(self.playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
            RequestAnimDict('misscarsteal2peeing')
            while not HasAnimDictLoaded('misscarsteal2peeing') do 
                Citizen.Wait(0)
            end

            TaskPlayAnim(self.playerPed, 'misscarsteal2peeing', 'peeing_loop', 1.0, -1.0, 2000, 49, 1, false, false, false)
            RemoveAnimDict('misscarsteal2peeing')
            Citizen.Wait(2000)
            DetachEntity(lighter, 1, 1)
            DeleteObject(lighter)
            Citizen.Wait(1000)

            SmokeController._variables.smoking = true
            Citizen.CreateThread(function() SmokeController._variables.startSmoke('cigarrete') end)
        elseif self.type == 'joint' then
            TriggerServerEvent('ZCore:removeItem', 1, self.itemData)
            RequestAnimDict('amb@world_human_smoking@male@male_a@enter')
            while not HasAnimDictLoaded('amb@world_human_smoking@male@male_a@enter') do 
                Citizen.Wait(0)
            end

            TaskPlayAnim(self.playerPed, 'amb@world_human_smoking@male@male_a@enter', 'enter', 1.0, -1.0, 1000, 49, 1, false, false, false)
            RemoveAnimDict('amb@world_human_smoking@male@male_a@enter')
            Citizen.Wait(1000)
            local jointProp = SMOKE_DATA.joints[math.random(1, #SMOKE_DATA.joints)]

            SmokeController._variables.cigarette = CreateObject(GetHashKey(jointProp), self.playerPos.x, self.playerPos.y, self.playerPos.z + 0.9, true, true, true)
            AttachEntityToEntity(SmokeController._variables.cigarette, self.playerPed, GetPedBoneIndex(self.playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
            Citizen.Wait(800)

            local lighter = CreateObject(`p_cs_lighter_01`, self.playerPos.x, self.playerPos.y, self.playerPos.z + 0.9, true, true, true)
            AttachEntityToEntity(lighter, self.playerPed, GetPedBoneIndex(self.playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
            RequestAnimDict('misscarsteal2peeing')
            while not HasAnimDictLoaded('misscarsteal2peeing') do 
                Citizen.Wait(0)
            end

            TaskPlayAnim(self.playerPed, 'misscarsteal2peeing', 'peeing_loop', 1.0, -1.0, 2000, 49, 1, false, false, false)
            RemoveAnimDict('misscarsteal2peeing')
            Citizen.Wait(2000)
            DetachEntity(lighter, 1, 1)
            DeleteObject(lighter)
            Citizen.Wait(1000)

            SmokeController._variables.smoking = true
            Citizen.CreateThread(function() SmokeController._variables.startSmoke('joint') end)
        end
    end
end

RegisterNetEvent('smoke:useCigarrete', SmokeController.useCigarrete)

SmokeController.usePack = function(itemData)
    if type(itemData) ~= 'table' then
        return
    end

    local self = {}
    self.itemData = itemData

    if self.itemData then
        W.OpenDialog('¿Cuántos cigarros quieres sacar?', 'cigar_quantity', function(amount)
            local cigarretes = tonumber(amount)

            if type(cigarretes) ~= 'number' then
                W.Notify('Tabaco', 'Solo se permiten ~r~números~w~.', 'error')
                
                return
            end

            if cigarretes <= 0 then
                W.Notify('Tabaco', 'Esta cantidad es ~r~inválida~w~.', 'error')
                
                return
            end

            if cigarretes > self.itemData.metadata.cigarretes then
                W.Notify('Tabaco', 'No tienes tantos cigarros.', 'error')
                
                return
            end

            if cigarretes > 0 then
                W.Progressbar("unpacking_cigarretes", "Sacando cigarro/s...", 5500, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true}, {}, {}, {}, function() end)
                exports['ZC-Inventory']:closeInv()
                local playerPed = PlayerPedId()
                local playerPos = GetEntityCoords(playerPed)
            
                RequestAnimDict('amb@world_human_smoking@male@male_a@enter')
                while not HasAnimDictLoaded('amb@world_human_smoking@male@male_a@enter') do 
                    Citizen.Wait(0)
                end

                TaskPlayAnim(playerPed, 'amb@world_human_smoking@male@male_a@enter', 'enter', 1.0, -1.0, 1000, 49, 1, false, false, false)
                RemoveAnimDict('amb@world_human_smoking@male@male_a@enter')
                Citizen.Wait(800)

                local tabaccoPack = CreateObject(GetHashKey('prop_cigar_pack_01'), playerPos.x, playerPos.y, playerPos.z + 0.9,  true,  true, true)
                AttachEntityToEntity(tabaccoPack, playerPed, GetPedBoneIndex(playerPed, 64016), 0.020, -0.05, -0.010, 100.0, 0.0, 0.0, true, true, false, true, 1, true)

                RequestAnimDict('mp_arresting')
                while not HasAnimDictLoaded('mp_arresting') do 
                    Citizen.Wait(0)
                end

                TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 1.0, -1.0, 3000, 49, 1, false, false, false)
                RemoveAnimDict('mp_arresting')
                Citizen.Wait(3000)
                DetachEntity(tabaccoPack, 1, 1)
                Citizen.Wait(2000)
                DeleteObject(tabaccoPack)

                TriggerServerEvent('smoke:getCigarretes', self.itemData, cigarretes)
            end
        end)
    end
end

RegisterNetEvent('smoke:usePack', SmokeController.usePack)

SmokeController.usePaper = function(itemData)
    exports['ZC-Inventory']:closeInv()

    W.OpenMenu('¿Qué quieres liar?', 'use_smoke_paper', {
        { label = 'Porro de Chocolate', value = 'joint_type', valueLabel = 'Chocolate', item = 'hachis' },
        { label = 'Porro de Marihuana', value = 'joint_type', valueLabel = 'Marihuana', item = 'cogollos_marihuana' },
    }, function(data, menu)
        W.DestroyMenu(menu)
        local hasItem, hasItemData = W.HaveItem(data.item)

        if hasItem and (hasItemData and hasItemData.quantity > 0) then
            W.Progressbar("using_smoke_paper", "Liando un "..data.label.."..", 5500, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true}, {}, {}, {}, function() end)
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
        
            RequestAnimDict('amb@world_human_smoking@male@male_a@enter')
            while not HasAnimDictLoaded('amb@world_human_smoking@male@male_a@enter') do 
                Citizen.Wait(0)
            end

            TaskPlayAnim(playerPed, 'amb@world_human_smoking@male@male_a@enter', 'enter', 1.0, -1.0, 1000, 49, 1, false, false, false)
            RemoveAnimDict('amb@world_human_smoking@male@male_a@enter')
            Citizen.Wait(800)

            local paper = CreateObject(GetHashKey('p_cs_papers_02'), playerPos.x, playerPos.y, playerPos.z + 0.9,  true,  true, true)
            AttachEntityToEntity(paper, playerPed, GetPedBoneIndex(playerPed, 64016), 0.020, -0.05, -0.010, 100.0, 0.0, 0.0, true, true, false, true, 1, true)

            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do 
                Citizen.Wait(0)
            end

            TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 1.0, -1.0, 3000, 49, 1, false, false, false)
            RemoveAnimDict('mp_arresting')
            Citizen.Wait(3000)
            DetachEntity(paper, 1, 1)
            Citizen.Wait(2000)
            DeleteObject(paper)

            W.TriggerCallback('smoke:usedItem', function(gived)
                if gived then
                    W.Notify('Tabaco', 'Has liado un porro', 'verify')
                end
            end, {
                paperRemove = {
                    name = itemData.name,
                    amount = 1,
                    slotId = itemData.slotId
                },
                drugRemove = {
                    name = data.item,
                    slotId = hasItemData.slotId
                },
                itemAdd = {
                    name = 'joint',
                    amount = math.random(1, 3),
                    metadata = data.value,
                    metadataLabel = data.valueLabel
                }
            })
        else
            W.Notify('Tabaco', '¿Cómo pretendes liar esto?', 'error')
        end
    end, function()
    end)
end

RegisterNetEvent('smoke:usePaper', SmokeController.usePaper)