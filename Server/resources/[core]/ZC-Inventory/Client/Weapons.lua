Weapons = {}
Weapons.Variables = {open = false, slotUsed = nil}
Weapons.Busy = false
Weapons.SlotsUsed = {}
Weapons.Weapons = {
    [GetHashKey("WEAPON_PISTOL")] = {clip = "pistol_clip", ammoType = "pistol_rounds", dict="weapons@pistol@pistol_str", anim="reload_aim"},
    [GetHashKey("WEAPON_APPISTOL")] = {clip = "appistol_clip", ammoType = "subfusil_rounds", dict="weapons@pistol@ap_pistol_str", anim="reload_aim"},
    [GetHashKey("WEAPON_PISTOL50")] = {clip = "50pistol_clip", ammoType = "sniper_rounds", dict="weapons@pistol@pistol_50_str", anim="reload_aim"},
    [GetHashKey("WEAPON_MACHINEPISTOL")] = {clip = "tec_clip", ammoType = "subfusil_rounds", dict="anim@weapons@pistol@machine_str", anim="reload_aim"},
    [GetHashKey("WEAPON_SNSPISTOL")] = {clip = "sns_clip", ammoType = "pistol_rounds", dict="weapons@pistol@pistol_str", anim="reload_aim"},
    --[GetHashKey("WEAPON_PISTOL_MK2")] = {clip = "pistol_clip", ammoType = "pistol_rounds", dict="weapons@pistol@pistol_str", anim="reload_aim"},
    [GetHashKey("WEAPON_DOUBLEACTION")] = {clip = "sns_clip", ammoType = "pistol_rounds", dict="anim@weapons@pistol@doubleaction_str", anim="w_reload_aim"},
    [GetHashKey("WEAPON_COMBATPISTOL")] = {clip = "pistol_clip", ammoType = "pistol_rounds", dict="weapons@pistol@combat_pistol_str", anim="reload_aim"},
    [GetHashKey("WEAPON_HEAVYPISTOL")] = {clip = "heavypistol_clip", ammoType = "pistol_rounds", dict="weapons@pistol@pistol_str", anim="reload_aim"},
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = {clip = "vintage_clip", ammoType = "pistol_rounds", dict="weapons@pistol@pistol_str", anim="reload_aim"},
    [GetHashKey("WEAPON_SMG")] = {clip = "subfusil_clip", ammoType = "subfusil_rounds", dict="weapons@submg@assault_smg_str", anim="reload_aim"},
    [GetHashKey("WEAPON_MINISMG")] = {clip = "skorpion_clip", ammoType = "subfusil_rounds", dict="weapons@submg@assault_smg_str", anim="reload_aim"},
    --[GetHashKey("WEAPON_SMG_MK2")] = {clip = "subfusil_clip", ammoType = "subfusil_rounds", dict="weapons@submg@assault_smg_str", anim="reload_aim"},
    [GetHashKey("WEAPON_COMBATPDW")] = {clip = "subfusil_clip", ammoType = "subfusil_rounds", dict="anim@weapons@rifle@lo@pdw_str", anim="reload_aim"},
    --[GetHashKey("WEAPON_MACHINEPISTOL")] = {clip = "pistol_clip", ammoType = "subfusil_rounds", dict="anim@weapons@pistol@machine_str", anim="reload_aim"},
    [GetHashKey("WEAPON_MICROSMG")] = {clip = "uzi_clip", ammoType = "subfusil_rounds", dict="weapons@submg@micro_smg_str", anim="reload_aim"},
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="weapons@rifle@hi@assault_rifle_str", anim="reload_aim"},
    [GetHashKey("WEAPON_COMPACTRIFLE")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="anim@weapons@heavy@compactgl_str", anim="reload_aim"},
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="weapons@first_person@aim_rng@generic@assault_rifle@bullpup_rifle@str", anim="reload_aim"},
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="weapons@submg@advanced_rifle_str", anim="reload_aim"},
    --[GetHashKey("WEAPON_CARBINERIFLE_MK2")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="weapons@rifle@lo@carbine_str", anim="reload_aim"},
    [GetHashKey("WEAPON_CARBINERIFLE")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="weapons@rifle@lo@carbine_str", anim="reload_aim"},
    [GetHashKey("WEAPON_SPECIALCARBINE")] = {clip = "fusil_clip", ammoType = "fusil_rounds", dict="anim@weapons@rifle@lo@spcarbine_str", anim="reload_aim"},
    --[GetHashKey("WEAPON_PUMPSHOTGUN_MK2")] = {clip = "shotgun_clip", ammoType = "shotgun_rounds", dict="anim@weapons@rifle@lo@pump_mk2_str", anim="reload_aim"},
    [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = {clip = "shotgun_clip", ammoType = "shotgun_rounds", dict="weapons@rifle@lo@sawnoff_str", anim="reload_aim"},
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = {clip = "shotgun_clip", ammoType = "shotgun_rounds", dict="weapons@rifle@lo@pump_str", anim="reload_aim"},
    [GetHashKey("WEAPON_SNIPERRIFLE")] = {clip = "sniper_clip", ammoType = "sniper_rounds", dict="weapons@rifle@hi@sniper_rifle_str", anim="reload_aim"},
    [GetHashKey("WEAPON_HEAVYSNIPER")] = {clip = "sniper_clip", ammoType = "sniper_rounds", dict="weapons@rifle@lo@sniper_heavy_str", anim="reload_aim"}
}

local reloading = false

Weapons.Open = function()
    if not Weapons.Variables.open then
        Weapons.Variables.open = true
        local slots = W.GetItemsForInventory()['slots']
        SendNUIMessage({ hotbar = slots })
        Wait(5500)
        Weapons.Variables.open = false
    end
end

RegisterNetEvent('inventory:openHotbar', Weapons.Open)

Weapons.SelectWeapon = function(slot)
    if not exports['ZC-Menupersonal']:CanUseWeapons() then return end
    if Weapons.SlotsUsed[slot] ~= true then
        Weapons.SlotsUsed[slot] = true
        local slots = W.GetItemsForInventory()['slots']
        local playerPed = PlayerPedId()
        local playerWeapon = GetSelectedPedWeapon(playerPed)
        local found, ammoClip = GetAmmoInClip(playerPed, playerWeapon)
        if Weapons.Variables.slotUsed then
            for k,v in pairs(slots) do
                if tonumber(v.slot) == Weapons.Variables.slotUsed then
                    AddAmmoToPed(playerPed, GetSelectedPedWeapon(PlayerPedId()), v.metadata.bullets)

                    TriggerServerEvent('weapons:updateAmmo', v, Weapons.Variables.slotUsed)
                end
            end
        end
        Weapons.Variables.slotUsed = slot
        slots = W.GetItemsForInventory()['slots']
        for k,v in pairs(slots) do
            if tonumber(v.slot) == slot then
                if v.metadata.life > 0 then
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey(v.name), true)
                    SetPedAmmo(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), v.metadata.bullets)

                    -- if IsPedInAnyVehicle(PlayerPedId()) then
                    --     AddAmmoToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), v.metadata.bullets)
                    -- else
                    --     SetAmmoInClip(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), v.metadata.bullets)
                    -- end

                    if v.metadata.attachments then
                        for _, attachment in pairs(v.metadata.attachments) do
                            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(v.name), attachment.component)
                        end
                    end
                else
                    Weapons.SlotsUsed[slot] = false
                    W.Notify('Armas', 'Esta ~r~arma está rota~w~.', 'error')
                    Weapons.Variables.slotUsed = nil
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                    TriggerServerEvent("weapons:removeWeapon", v)
                end
                if (v.name == "WEAPON_BZGAS" and GetAmmoInPedWeapon(playerPed, GetHashKey(v.name)) == 0) or (v.name == "WEAPON_PETROLCAN" and GetAmmoInPedWeapon(playerPed, GetHashKey(v.name)) == 0) then
                    TriggerServerEvent("weapons:removeWeapon", v)
                end
            end
        end
        SendNUIMessage({ hotbar = slots, select = tonumber(slot) })

        CreateThread(function()
            while Weapons.SlotsUsed[slot] do
                local playerPed = PlayerPedId()
                local playerWeapon = GetSelectedPedWeapon(playerPed)
                local found, ammoClip = GetAmmoInClip(playerPed, playerWeapon)
                local ammoactual = GetAmmoInPedWeapon(playerPed, playerWeapon)

                if IsPedShooting(playerPed) then
                    for k,v in pairs(slots) do
                        if tonumber(v.slot) == slot then
                            v.metadata.bullets = ammoactual

                            TriggerServerEvent('weapons:updateAmmo', v, Weapons.Variables.slotUsed)
                        end
                    end
                end

                Wait(0)
            end
        end)
    else
        local slots = W.GetItemsForInventory()['slots']
        local playerPed = PlayerPedId()
        local playerWeapon = GetSelectedPedWeapon(playerPed)
        local found, ammoClip = GetAmmoInClip(playerPed, playerWeapon)
        for k,v in pairs(slots) do
            if tonumber(v.slot) == Weapons.Variables.slotUsed then
                SetAmmoInClip(playerPed, playerWeapon, v.metadata.bullet)

                TriggerServerEvent('weapons:updateAmmo', v, Weapons.Variables.slotUsed)
            end
        end
        Weapons.Variables.slotUsed = nil
        Weapons.SlotsUsed[slot] = false
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
    end
end

for i = 1, 5 do
    RegisterKeyMapping('hotbar'..i, 'Usar el slot '..i..' del hotbar', 'keyboard', i)

    RegisterCommand("hotbar"..i, function ()
        --if exports['Ox-Phone']:IsPhoneOpened() then return end
        if exports['Ox-Jobcreator']:IsHandcuffed() then return end
        if exports['ZC-Ambulance']:IsDead() then return end
        if exports['ZC-Menu']:isOpened() then return end

        Weapons.SelectWeapon(i)
    end)
end

-- Clips

RegisterNetEvent('inventory:useClip2', function(itemData)
    local playerPed = PlayerPedId()
    local playerWeapon = GetSelectedPedWeapon(playerPed)
    local found, ammoClip = GetAmmoInClip(playerPed, playerWeapon)
    local maxAmmoClip = GetMaxAmmoInClip(playerPed, playerWeapon, 1)

    if Weapons.Variables.slotUsed and Weapons.Weapons[playerWeapon]  then
        local have = W.HaveItem(Weapons.Weapons[playerWeapon].clip)
        if have > 0 then
            AddAmmoToPed(playerPed, playerWeapon, maxAmmoClip)
            TriggerServerEvent('ZC-Inventory:removeItem', Weapons.Weapons[playerWeapon].clip, 1, itemData.slotId)
            TriggerServerEvent('ZC-Inventory:giveItem', 'emptyclip', 1)
            local slots = W.GetItemsForInventory()['slots']
                for k,v in pairs(slots) do
                    if tonumber(v.slot) == Weapons.Variables.slotUsed then
                        v.metadata.bullets = GetAmmoInPedWeapon(playerPed, playerWeapon)
                        TriggerServerEvent('weapons:updateAmmo', v, Weapons.Variables.slotUsed)
                    end
                end
        else 
            W.Notify('Cargador', 'No tienes cargadores para este arma', 'error')
        end
    else
        W.Notify('Cargador', 'No tienes el arma correcta en la mano.', 'error')
    end
end)

RegisterNetEvent('inventory:useClip', function(itemData)
    local playerPed = PlayerPedId()
    local playerWeapon = GetSelectedPedWeapon(playerPed)
    local found, ammoClip = GetAmmoInClip(playerPed, playerWeapon)
    local maxAmmoClip = GetMaxAmmoInClip(playerPed, playerWeapon, 1)
    local ammoactual = GetAmmoInPedWeapon(playerPed, playerWeapon)
    
    if Weapons.Variables.slotUsed and Weapons.Weapons[playerWeapon]  then
        local have = W.HaveItem(Weapons.Weapons[playerWeapon].clip)
        if have > 0 then
            reloading = true
            print (ammoactual)
            --print (maxAmmoClip)
            -- if ammoClip <= maxAmmoClip then
                local slots = W.GetItemsForInventory()['slots']

                --SetAmmoInClip(PlayerPedId(), playerWeapon, 0)
                --SetPedAmmo(PlayerPedId(), playerWeapon, maxAmmoClip)
                local canUse = true
                for k,v in pairs(slots) do
                    if tonumber(v.slot) == Weapons.Variables.slotUsed then
                        if v.metadata.life > 0 then
                            v.metadata.bullets = ammoactual

                            -- TriggerServerEvent('ZC-Inventory:removeItem', Weapons.Weapons[playerWeapon].clip, 1, itemData.slotId)
                            -- TriggerServerEvent('ZC-Inventory:giveItem', 'emptyclip', 1)
                            -- if ammoClip > 0 then
                            --     TriggerServerEvent('ZC-Inventory:giveItem', Weapons.Weapons[playerWeapon].ammoType, ammoClip)
                            -- end

                            TriggerServerEvent('weapons:updateAmmo', v, Weapons.Variables.slotUsed, Weapons.Weapons[playerWeapon].ammoType)
                        else
                            canUse = false
                            W.Notify('Armas', 'Esta ~r~arma se ha roto~w~.', 'error')
                            reloading = false
                            Weapons.Variables.slotUsed = nil
                            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                            for i = 1, 5 do
                                Weapons.SlotsUsed[i] = false
                            end
                            TriggerServerEvent("weapons:removeWeapon", v)
                        end
                    end
                end

                -- if canUse then
                --     W.Progressbar("taking_bullets", 'Usando cargador...', 1200, false, true, {
                --         disableMovement = false,
                --         disableCarMovement = false,
                --         disableMouse = false,
                --         disableCombat = true,
                --     }, {}, {}, {}, function() -- Done
                --         W.Notify('Cargador', 'Has metido ~y~x'..GetMaxAmmoInClip(playerPed, playerWeapon, 1)..' balas~w~ en tu cargador', 'verify')
                --         reloading = false
                --     end, function()
                --         W.Notify('Cargador', 'Has cancelado la acción', 'error')
                --         reloading = false
                --     end)
                -- end
            -- else
            --     W.Notify('Cargador', 'El cargador ya está lleno', 'error')
            --     reloading = false
            -- end
        -- else
        --     W.Notify('Cargador', 'No tienes cargadores para este arma', 'error')
        --     reloading = false
        end
    end
end)



RegisterCommand('vermuni', function()
    local playerPed = PlayerPedId()
    local playerWeapon = GetSelectedPedWeapon(playerPed)
    local found, ammoClip = GetAmmoInClip(playerPed, playerWeapon)
    local test1 = GetAmmoInPedWeapon(playerPed, playerWeapon)
    local maxAmmoClip = GetMaxAmmoInClip(playerPed, playerWeapon, 1)

    print (playerWeapon)
end)

RegisterCommand('reloadweapon', function()
    local playerPed = PlayerPedId()
    local playerWeapon = GetSelectedPedWeapon(playerPed)
    if not Weapons.Weapons[playerWeapon] then
        return
    end

    local quantity, itemData = W.HaveItem(Weapons.Weapons[playerWeapon].clip)
    if quantity > 0 then
        if type(itemData.metadata) == 'string' then
            itemData.metadata = json.decode(itemData.metadata)
        end

        TriggerEvent('inventory:useClip', itemData)
    end
end)

RegisterKeyMapping('reloadweapon', 'Recargar tu arma', 'keyboard', 'R')

UseEmptyClip = function(item)
    local elements = {
        { label = 'Pistolas', value = 'pistol_clip' },
        { label = 'Subfusiles', value = 'subfusil_clip' },
        { label = 'Rifles', value = 'fusil_clip' },
        { label = 'Escopetas', value = 'shotgun_clip' },
        { label = 'Francotiradores', value = 'sniper_clip' }
    }

    local subparts = {
        ['pistol_clip'] = {
            { label = 'Cargador de SNS (6 balas)', value = 'sns_clip', bullets = 6, bulletType = 'pistol_rounds' },
            { label = 'Cargador de Pistola (12 balas)', value = 'pistol_clip', bullets = 12, bulletType = 'pistol_rounds' },
            { label = 'Cargador Vintage (7 balas)', value = 'vintage_clip', bullets = 7, bulletType = 'pistol_rounds' },
            { label = 'Cargador de P.Pesada (18 balas)', value = 'heavypistol_clip', bullets = 18, bulletType = 'pistol_rounds' },
            { label = 'Cargador de .50 (9 balas)', value = '50pistol_clip', bullets = 9, bulletType = 'sniper_rounds' },
            { label = 'Cargador de P. AP (18 balas)', value = 'appistol_clip', bullets = 18, bulletType = 'subfusil_rounds' },
        },
        ['subfusil_clip'] = {
            { label = 'Cargador UZI (16 balas)', value = 'uzi_clip', bullets = 16, bulletType = 'subfusil_rounds' },
            { label = 'Cargador Skorpion (20 balas)', value = 'skorpion_clip', bullets = 20, bulletType = 'subfusil_rounds' },
            { label = 'Cargador Subfusil (30 balas)', value = 'subfusil_clip', bullets = 30, bulletType = 'subfusil_rounds' },
            { label = 'Cargador TEC-9 (12 balas)', value = 'tec_clip', bullets = 12, bulletType = 'subfusil_rounds' },
        },
        ['shotgun_clip'] = {
            { label = 'Cargador Escopeta (8 cartuchos)', value = 'shotgun_clip', bullets = 8, bulletType = 'shotgun_rounds' },
        },
        ['fusil_clip'] = {
            { label = 'Cargador Fusil (30 balas)', value = 'fusil_clip', bullets = 30, bulletType = 'fusil_rounds' },
        },
        ['sniper_clip'] = {
            { label = 'Cargador Sniper (10 balas)', value = 'sniper_clip', bullets = 10, bulletType = 'sniper_rounds' }
        }
    }

    exports['ZC-Inventory']:closeInv()
    W.OpenMenu('Creación de Cargadores', 'create_clips', elements, function(data, name)
        W.DestroyMenu(name)

        if not subparts[data.value] then
            return
        end

        Wait(200)
        W.OpenMenu('Creación de Cargadores', 'create_clips2', subparts[data.value], function(data2, name2)
            W.DestroyMenu(name2)

            local found = false
            local inventory = W.GetItemsForInventory().data

            for i = 1, #inventory, 1 do
                if inventory[i].name == data2.bulletType then
                    found = true

                    if inventory[i].quantity >= data2.bullets then
                        ExecuteCommand('me Mete las balas en el cargador vacío')
                        ExecuteCommand('e parkingmeter')

                        W.Progressbar("taking_bullets", 'Metiendo balas en el cargador...', 3500, false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            ClearPedSecondaryTask(PlayerPedId())
                            ClearPedTasksImmediately(PlayerPedId())

                            TriggerServerEvent('ZC-Inventory:removeItem', inventory[i].name, data2.bullets, inventory[i].slotId)
                            TriggerServerEvent('ZC-Inventory:removeItem', item.name, 1, item.slotId)
                            TriggerServerEvent('ZC-Inventory:giveItem', data2.value, 1, false)

                            W.Notify('Cargador', 'Has metido ~y~x'..data2.bullets..' balas~w~ en tu cargador', 'verify')
                            reloading = false
                        end, function()
                            W.Notify('Cargador', 'Has cancelado la acción', 'error')
                            reloading = false
                        end)
                    else
                        W.Notify('Cargadores', 'No tienes ~r~balas suficientes~w~ para hacer este cargador', 'error')
                    end
                end
            end

            if not found then
                W.Notify('Cargadores', 'Necesitas ~r~balas~w~ para poder hacer esto', 'error')
            end
        end)
    end)
end

RegisterNetEvent('inventory:useEmptyclip', UseEmptyClip)

UseAttachment = function(attachment, itemData)
    if not attachment then return end
    if not itemData or not itemData.slotId then return end
    
    if not Weapons.Variables.slotUsed then
        return W.Notify('Componentes', 'Necesitas un arma en la mano para poder usar esto', 'error')
    end

    local Entity = PlayerPedId()
    local Weapon = GetSelectedPedWeapon(Entity)
    local Slots = W.GetItemsForInventory()['slots']
    local Attachments = W.Attachments[Weapon]
    local WeaponData = nil

    if not Attachments then
        return
    end

    if Attachments[attachment].item == itemData.name then
        if Weapons.Variables.slotUsed then
            for k,v in pairs(Slots) do
                if tonumber(v.slot) == Weapons.Variables.slotUsed then
                    WeaponData = v.slotId
                end
            end

            TriggerServerEvent('inventory:equipAttachment', WeaponData, itemData, Attachments[attachment])
        end
    end
end

RegisterNetEvent('inventory:useAttachment', UseAttachment)

AddAttachment = function(WeaponSlot, Attachment)
    local SlotId = nil
    local Slots = W.GetItemsForInventory()['slots']

    if not Weapons.Variables.slotUsed then
        return W.Notify('Componentes', 'No tienes ningún arma en tus manos', 'error')
    end

    for k,v in pairs(Slots) do
        if tonumber(v.slot) == Weapons.Variables.slotUsed then
            SlotId = v.slotId
        end
    end

    if SlotId == WeaponSlot then
        local Entity = PlayerPedId()
        local Weapon = GetSelectedPedWeapon(Entity)

        GiveWeaponComponentToPed(Entity, Weapon, Attachment.component)
    end
end

RegisterNetEvent('inventory:addAttachment', AddAttachment)

CreateThread(function()
    SetWeaponsNoAutoswap(true)
    RefillAmmoInstantly(false)
end)

local accesories = {
	{name = GetHashKey("COMPONENT_AT_PI_FLSH"), value = 'linterna'},
    {name = GetHashKey("COMPONENT_AT_PI_RAIL_02"), value = 'mounted_scope'},
    {name = GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_SMG_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"), value = 'camuflaje'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"), value = 'scope'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_MACRO"), value = 'scope'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_SMALL"), value = 'scope'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"), value = 'scope'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"), value = 'scope'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2"), value = 'mediumscope'},
    {name = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"), value = 'largescope'},
    {name = GetHashKey("COMPONENT_AT_SIGHTS_SMG"), value = 'holografik_scope'},
    {name = GetHashKey("COMPONENT_AT_SIGHTS"), value = 'holografik_scope'},
    {name = GetHashKey("COMPONENT_AT_AR_AFGRIP"), value = 'culata'},
    {name = GetHashKey("COMPONENT_AT_AR_AFGRIP_02"), value = 'culata'},
    {name = GetHashKey("COMPONENT_AT_PI_SUPP_02"), value = 'silenciador'},
    {name = GetHashKey("COMPONENT_AT_PI_SUPP"), value = 'silenciador'},
    {name = GetHashKey("COMPONENT_AT_AR_SUPP_02"), value = 'silenciador'},
    {name = GetHashKey("COMPONENT_AT_AR_SUPP"), value = 'silenciador'},
    {name = GetHashKey("COMPONENT_AT_PI_FLSH"), value = 'linterna'},
    {name = GetHashKey("COMPONENT_AT_PI_FLSH_03"), value = 'linterna'},
    {name = GetHashKey("COMPONENT_AT_PI_FLSH_02"), value = 'linterna'},
    {name = GetHashKey("COMPONENT_AT_AR_FLSH"), value = 'linterna'}
}

function loadAnimDict(dict)
  while ( not HasAnimDictLoaded(dict)) do
    RequestAnimDict(dict)
    Wait(50)
  end
end


RegisterNetEvent('esx_attachments_bleiker:MountedScope')
AddEventHandler('esx_attachments_bleiker:MountedScope', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)
			
	if currentWeaponHash == GetHashKey("WEAPON_PISTOL_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL_MK2"), GetHashKey("COMPONENT_AT_PI_RAIL"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SNSPISTOL_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_PI_RAIL_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 		
	else 
		W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio')
        TriggerServerEvent('ZC-Inventory:giveItem', "mounted_scope", 1)
	end
end)

RegisterNetEvent('eden_accesories:yusuf')
AddEventHandler('eden_accesories:yusuf', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_SMG_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo")   		
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo")  		
	elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"))  
		W.Notify("Arma","Acabas de equipar tu camuflaje de lujo") 
	else 
		W.Notify("Arma","No tienes un arma en la mano o tu arma no soporta un camuflaje de lujo")
        TriggerServerEvent('ZC-Inventory:giveItem', "camuflaje", 1)
	end
end)

RegisterNetEvent('esx_attachments_bleiker:scope')
AddEventHandler('esx_attachments_bleiker:scope', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_SMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSMG") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_SCOPE_MACRO"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente')  
	elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPDW") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"), GetHashKey("COMPONENT_AT_SCOPE_SMALL"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_SCOPE_MACRO"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_AT_SCOPE_SMALL"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	else 
		W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio')  		
        TriggerServerEvent('ZC-Inventory:giveItem', "scope", 1)
	end
end)

RegisterNetEvent('esx_attachments_bleiker:mediumscope')
AddEventHandler('esx_attachments_bleiker:mediumscope', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_PUMPSHOTGUN_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	else 
		W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio')  	
        TriggerServerEvent('ZC-Inventory:giveItem', "mediumscope", 1)
	end
end)

RegisterNetEvent('esx_attachments_bleiker:largescope')
AddEventHandler('esx_attachments_bleiker:largescope', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE_MK2"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE_MK2"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	else 
	  W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio') 
      TriggerServerEvent('ZC-Inventory:giveItem', "largescope", 1)
	end
end)

RegisterNetEvent('esx_attachments_bleiker:holografik')
AddEventHandler('esx_attachments_bleiker:holografik', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_SMG_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG_MK2"), GetHashKey("COMPONENT_AT_SIGHTS_SMG"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_PUMPSHOTGUN_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), GetHashKey("COMPONENT_AT_SIGHTS"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE_MK2"), GetHashKey("COMPONENT_AT_SIGHTS"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente')  
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), GetHashKey("COMPONENT_AT_SIGHTS"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	else 
		W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio') 		
        TriggerServerEvent('ZC-Inventory:giveItem', "holografik_scope", 1)
	end
end)

RegisterNetEvent('esx_attachments_bleiker:grip')
AddEventHandler('esx_attachments_bleiker:grip', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_COMBATPDW") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente')
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
  elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE_MK2"), GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE_MK2"), GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
  else 
    W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio')   
    TriggerServerEvent('ZC-Inventory:giveItem', "culata", 1)
  end
end)

RegisterNetEvent('esx_attachments_bleiker:Suppressor')
AddEventHandler('esx_attachments_bleiker:Suppressor', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
	  GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP_02"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SNSPISTOL_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SNSPISTOL_MK2"), GetHashKey("COMPONENT_AT_PI_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL_MK2"), GetHashKey("COMPONENT_AT_PI_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
  elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SMG_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG_MK2"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_VINTAGEPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_VINTAGEPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE_MK2"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE_MK2"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 	
	else 
		W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio')  		
        TriggerServerEvent('ZC-Inventory:giveItem', "silenciador", 1)
	end
end)

RegisterNetEvent('esx_attachments_bleiker:flashlight')
AddEventHandler('esx_attachments_bleiker:flashlight', function()
  local ped = PlayerPedId()
  local currentWeaponHash = GetSelectedPedWeapon(ped)

	if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
    W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SNSPISTOL_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SNSPISTOL_MK2"), GetHashKey("COMPONENT_AT_PI_FLSH_03"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PISTOL_MK2"), GetHashKey("COMPONENT_AT_PI_FLSH_02"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSMG") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_SMG_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SMG_MK2"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPDW") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_PUMPSHOTGUN") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 				
	elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
	  GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
	  W.Notify("Arma",'Has equipado el accesorio correctamente') 					
	elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_SPECIALCARBINE_MK2"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 				
	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 				
	elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
		GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_CARBINERIFLE_MK2"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
		W.Notify("Arma",'Has equipado el accesorio correctamente') 
	else
		W.Notify("Arma",'No tienes un arma en la mano o tu arma no soporta el accesorio')  	
        TriggerServerEvent('ZC-Inventory:giveItem', "linterna", 1)	
    end
end)

RegisterNetEvent('ZC-Inventory:bulletproof', function()
	local playerPed = PlayerPedId()

    local lastSkin = exports['ZC-Character']:GetSkin()
    local sex = lastSkin['sex']
    if sex == "mp_m_freemode_01" then
        local playerPed = PlayerPedId()
        SetPedComponentVariation(playerPed, 9, 15, 2, 2)
    else
        SetPedComponentVariation(playerPed, 9, 17, 2, 2)
    end

	AddArmourToPed(playerPed, 100)
	SetPedArmour(playerPed, 100)
end)

RegisterNetEvent('inventory:useRepairkit', function(item)
	local playerPed		= GetPlayerPed(-1)
	local coords		= GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then

			W.Progressbar("using_repairkit", 'Usando kit de reparación....', 20 * 1000, false, true, {									
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },{									
                animDict = 'mini@repair',
                anim = 'fixing_a_ped' 
            }, {}, {}, function()
                TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        		SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				SetVehicleEngineOn(vehicle, true, true)
				ClearPedTasksImmediately(playerPed)
                TriggerServerEvent('ZC-Inventory:removeItem', 'repairkit', 1, item.slotId)
            end)
		end
	end
end)