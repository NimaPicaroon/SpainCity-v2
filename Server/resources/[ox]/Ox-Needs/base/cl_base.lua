NeedsController = setmetatable({ }, NeedsController)
NeedsController._variables = {
    _ped = nil,
    _pos = nil,
    _eating = false,
    _prop = nil,
    props = nil
}
NeedsController.__index = NeedsController

ItemProps = {
    ['cremavegetal'] = 'v_res_fa_pottea',
    ['papeldeliar'] = 'p_cs_papers_03',
    ['meteorite'] = 'prop_choc_meto',
    ['vip_cockatoos'] = 'prop_cs_r_business_card',
    ['moet2'] = 'prop_bottle_cognac',
    ['phone'] = 'prop_phone_ing_03',
    ['burger'] = 'prop_cs_burger_01',
    ['chaser'] = 'prop_choc_ego',
    ['hotdog'] = 'prop_cs_hotdog_01',
    ['taco'] = 'prop_taco_01',
    ['powerade'] = "prop_energy_drink",
    ['creditcard'] = "prop_cs_credit_card",
    ['membership'] = "p_ld_id_card_01",
    ['WEAPON_PISTOL'] = 'w_pi_pistol',
    ['WEAPON_KNIFE'] = 'prop_w_me_knife_01',
    ['WEAPON_DAGGER'] = 'prop_w_me_dagger',
    ['WEAPON_BAT'] = 'w_me_bat',
    ['WEAPON_BOTTLE'] = 'prop_w_me_bottle',
    ['WEAPON_CROWBAR'] = 'w_me_crowbar',
    ['WEAPON_FLASHLIGHT'] = 'w_me_flashlight',
    ['WEAPON_GOLFCLUB'] = 'w_me_gclub',
    ['WEAPON_HAMMER'] = 'prop_tool_hammer',
    ['WEAPON_HATCHET'] = 'prop_w_me_hatchet',
    ['WEAPON_KNUCKLE'] = 'w_me_knuckle',
    ['WEAPON_MACHETE'] = 'prop_ld_w_me_machette',
    ['WEAPON_SWITCHBLADE'] = 'w_me_switchblade',
    ['WEAPON_NIGHTSTICK'] = 'w_me_nightstick',
    ['WEAPON_WRENCH'] = 'prop_cs_wrench',
    ['WEAPON_BATTLEAXE'] = 'w_me_battleaxe',
    ['WEAPON_POOLCUE'] = 'w_me_poolcue',
    ['WEAPON_STONE_HATCHET'] = 'w_me_stonehatchet',
    ['WEAPON_PISTOL_MK2'] = 'w_pi_pistolmk2',
    ['WEAPON_COMBATPISTOL'] = 'w_pi_combatpistol',
    ['WEAPON_APPISTOL'] = 'w_pi_appistol',
    ['WEAPON_STUNGUN'] = 'w_pi_stungun',
    ['WEAPON_PISTOL50'] = 'w_pi_pistol50',
    ['WEAPON_SNSPISTOL'] = 'w_pi_sns_pistol',
    ['WEAPON_SNSPISTOL_MK2'] = 'w_pi_sns_pistolmk2',
    ['WEAPON_HEAVYPISTOL'] = 'w_pi_heavypistol',
    ['WEAPON_VINTAGEPISTOL'] = 'w_pi_vintage_pistol',
    ['WEAPON_FLAREGUN'] = 'w_pi_flaregun',
    ['WEAPON_MARKSMANPISTOL'] = 'w_pi_singleshot',
    ['WEAPON_REVOLVER'] = 'w_pi_revolver',
    ['WEAPON_REVOLVER_MK2'] = 'w_pi_revolvermk2',
    ['WEAPON_DOUBLEACTION'] = 'w_pi_wep1_gun',
    ['WEAPON_CERAMICPISTOL'] = 'w_pi_ceramic_pistol',
    ['WEAPON_MICROSMG'] = 'w_sb_microsmg',
    ['WEAPON_SMG'] = 'w_sb_smg',
    ['WEAPON_SMG_MK2'] = 'w_sb_smgmk2',
    ['WEAPON_ASSAULTSMG'] = 'w_sb_assaultsmg',
    ['WEAPON_COMBATPDW'] = 'w_sb_pdw',
    ['WEAPON_MACHINEPISTOL'] = 'w_sb_compactsmg',
    ['WEAPON_MINISMG'] = 'w_sb_minismg',
    ['WEAPON_PUMPSHOTGUN'] = 'w_sg_pumpshotgun',
    ['WEAPON_PUMPSHOTGUN_MK2'] = 'w_sg_pumpshotgunmk2',
    ['WEAPON_SAWNOFFSHOTGUN'] = 'w_sg_sawnoff',
    ['WEAPON_ASSAULTRIFLE'] = 'w_ar_assaultrifle',
    ['WEAPON_ASSAULTRIFLE_MK2'] = 'w_ar_assaultriflemk2',
    ['WEAPON_CARBINERIFLE'] = 'w_ar_carbinerifle',
    ['WEAPON_CARBINERIFLE_MK2'] = 'w_ar_carbineriflemk2',
    ['WEAPON_ADVANCEDRIFLE'] = 'w_ar_advancedrifle',
    ['WEAPON_SPECIALCARBINE'] = 'w_ar_specialcarbine',
    ['WEAPON_SPECIALCARBINE_MK2'] = 'w_ar_specialcarbinemk2',
    ['WEAPON_BULLPUPRIFLE'] = 'w_ar_bullpuprifle',
    ['WEAPON_COMPACTRIFLE'] = 'w_ar_assaultrifle_smg',
    ['WEAPON_SNIPERRIFLE'] = 'w_sr_sniperrifle',
    ['WEAPON_HEAVYSNIPER'] = 'w_sr_heavysniper',
    ['WEAPON_HEAVYSNIPER_MK2'] = 'w_sr_heavysnipermk2',
    ['WEAPON_BZGAS'] = 'prop_gas_grenade',
    ['WEAPON_MOLOTOV'] = 'w_ex_molotov',
    ['WEAPON_STICKYBOMB'] = 'w_ex_pe',
    ['WEAPON_SNOWBALL'] = 'w_ex_snowball',
    ['WEAPON_BALL'] = 'prop_tennis_ball',
    ['WEAPON_FLARE'] = 'prop_flare_01',
    ['WEAPON_PETROLCAN'] = 'prop_jerrycan_01a',
    ['GADGET_PARACHUTE'] = 'prop_parachute',
    ['WEAPON_FIREEXTINGUISHER'] = 'prop_fire_exting_1a',
    ['bread'] = 'prop_sandwich_01',
    ['pistol_clip'] = 'prop_ld_ammo_pack_01',
    ['appistol_clip'] = 'prop_ld_ammo_pack_01',
    ['tec_clip'] = 'prop_ld_ammo_pack_01',
    ['fusil_clip'] = 'prop_ld_ammo_pack_03',
    ['shotgun_clip'] = 'prop_ld_ammo_pack_02',
    ['sns_clip'] = 'prop_ld_ammo_pack_01',
    ['vintage_clip'] = 'prop_ld_ammo_pack_01',
    ['heavypistol_clip'] = 'prop_ld_ammo_pack_01',
    ['uzi_clip'] = 'prop_ld_ammo_pack_03',
    ['skorpion_clip'] = 'prop_ld_ammo_pack_03',
    ['subfusil_clip'] = 'prop_ld_ammo_pack_03',
    ['sniper_clip'] = 'v_ret_gc_ammo1',
    ['emptyclip'] = 'v_ret_gc_ammo8',
    ['pistol_rounds'] = 'prop_box_ammo07b',
    ['smg_rounds'] = 'prop_box_ammo07b',
    ['rifle_rounds'] = 'prop_box_ammo07b',
    ['shotgun_rounds'] = 'prop_box_ammo07b',
    ['sniper_rounds'] = 'prop_box_ammo07b',
    ['remote'] = 'prop_cs_remote_01',
    ['hifi'] = 'prop_boombox_01',
    ['radio'] = 'prop_cs_hand_radio',
    ['carkey'] = 'p_car_keys_01',
    ['house_keys'] = 'prop_cs_keys_01',
    ['motelkey'] = 'prop_cs_keys_01',
    ['anxiolytic'] = 'prop_cs_pills',
    ['cola'] = 'prop_ecola_can',
    ['sprunk'] = 'v_res_tt_can03',
    ['bean_machine_coffe'] = 'p_ing_coffeecup_01',
    ['raine'] = 'ba_prop_club_water_bottle',
    ['water'] = 'ba_prop_club_water_bottle',
    ['piswasser'] = 'prop_amb_beer_bottle',
    ['mount_whisky'] = 'prop_whiskey_bottle',
    ['tequila'] = 'prop_tequila_bottle',
    ['nogo_vodka'] = 'prop_vodka_bottle',
    ['cheque'] = 'prop_cd_paper_pile2',
    ['tabaccopack'] = 'prop_cigar_pack_01',
    ['cigarrete'] = 'ng_proc_cigarette01a',
    ['coffee'] = 'p_ing_coffeecup_01',
    ['spraycan'] = 'prop_cs_spray_can',
    ['sprayremover'] = 'prop_blox_spray',

    --otros items
    ['laptop'] = 'prop_laptop_02_closed',
    ['microwave'] = 'prop_microwave_1',
    ['coffemaker'] = 'prop_coffee_mac_02',
    ['tv'] = 'prop_tv_flat_01',
    ['telescope'] = 'prop_t_telescope_01b',
    ['art'] = 'ch_prop_vault_painting_01b',

    --drugs
    ['pasta_coca'] = 'prop_coke_block_01',
    ['clorhidrato_coca'] = 'prop_coke_block_half_b',
    ['chivato_coca'] = 'prop_meth_bag_01',
    ['bloque_hachis'] = 'hei_prop_heist_weed_block_01',
    ['amoniaco'] = 'v_ind_cs_bottle',
    ['soda_caustica'] = 'p_cs_script_bottle_s',
    ['pill'] = 'prop_cs_pills',
    ['pill2'] = 'prop_cs_pills',
    ['mortero'] = 'bkr_prop_coke_mortalpestle',
    ['bolsa_hermetica'] = 'bkr_prop_weed_bag_01a',
    ['balanza'] = 'bkr_prop_coke_scale_01',
    ['tamiz'] = 'bkr_prop_coke_fullsieve_01a', -- cambiar
    ['maceta'] = 'bkr_prop_weed_plantpot_stack_01b',
    ['extasis'] = 'hei_prop_pill_bag_01',
    ['codeina'] = 'prop_cs_script_bottle_01',
    ['cogollos_marihuana'] = 'bkr_prop_weed_bud_01b',
    ['bolsa_marihuana'] = 'bkr_prop_weed_smallbag_01a',
    ['ramas_marihuana'] = 'p_weed_bottle_s',
    ['agua_purificada'] = 'prop_ld_flow_bottle',
    ['fertilizante'] = 'bkr_prop_weed_spray_01a',
    ['cizallas'] = 'prop_tool_pliers',
    ['bolsa_opio'] = 'bkr_prop_weed_smallbag_01a',
    ['opio_triturado'] = 'bkr_prop_weed_smallbag_01a',
    ['cristal_opio'] = 'prop_weed_bottle',
    ['lean'] = "lean",
    ['bote_vacio'] = "prop_cs_pills",
    ['bote_extasis'] = "prop_cs_pills",
    ['paintingg'] = 'ch_prop_vault_painting_01g',
    ['paintingf'] = "ch_prop_vault_painting_01f",
    ['paintingh'] = "ch_prop_vault_painting_01h",
    ['paintingj'] = "ch_prop_vault_painting_01j",
    ['vanDiamond'] = "h4_prop_h4_diamond_01a",
    ['lighter'] = 'p_cs_lighter_01'
}

exports('isBusy', function()
    return NeedsController._variables._eating
end)

NeedsController.drink = function(item, itemData, data)
    if type(item) ~= 'string' then
        return
    end

    if type(itemData) ~= 'table' then
        return
    end

    if type(data) ~= 'table' then
        return
    end

    local self = {}
    self.item = item
    self.itemData = itemData
    self.uses = 1
    self.data = data
    self.shown = false

    Citizen.CreateThread(function()
        NeedsController._variables._eating = true
        if NeedsController._variables._eating then
            NeedsController._variables._prop = CreateObject(GetHashKey(ItemProps[self.item]), NeedsController._variables._pos.x, NeedsController._variables._pos.y, NeedsController._variables._pos.z + 0.2, true, true, true)
            AttachEntityToEntity(NeedsController._variables._prop, NeedsController._variables._ped, GetPedBoneIndex(NeedsController._variables._ped, 28422), self.data.Pos1 , self.data.Pos2, self.data.Pos3, self.data.Pos4 , self.data.Pos5, self.data.Pos6, true, true, false, true, 1, true)

            while NeedsController._variables._eating do
                 --if not self.shown then
                     --self.shown = true
                     --exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para beber', 'needs_drink')
                     --exports['ZC-HelpNotify']:open('Usa <strong>X</strong> para cancelar', 'stop_needs_drink')
                 --end

                -- if not IsEntityPlayingAnim(NeedsController._variables._ped, 'amb@code_human_wander_drinking_fat@beer@male@base', 'static', 3) then
                --     RequestAnimDict('amb@code_human_wander_drinking_fat@beer@male@base')
                --     while not HasAnimDictLoaded('amb@code_human_wander_drinking_fat@beer@male@base') do 
                --         Citizen.Wait(0) 
                --     end

                --     TaskPlayAnim(NeedsController._variables._ped, 'amb@code_human_wander_drinking_fat@beer@male@base', 'static', 1.0, -1.0, -1, 49, 1, false, false, false)
                --     RemoveAnimDict('amb@code_human_wander_drinking_fat@beer@male@base')
                -- end

                local status = W.GetPlayerData().status

                    if self.uses > 0 then
                        RequestAnimDict('amb@code_human_wander_drinking@male@idle_a')
                        while not HasAnimDictLoaded('amb@code_human_wander_drinking@male@idle_a') do 
                            Citizen.Wait(0) 
                        end
    
                        self.uses = self.uses - 1
                        TaskPlayAnim(NeedsController._variables._ped, 'amb@code_human_wander_drinking@male@idle_a', 'idle_c', 1.0, -1.0, 3000, 49, 1, false, false, false)
                        RemoveAnimDict('amb@code_human_wander_drinking@male@idle_a')
                        Citizen.Wait(3000)
                        ClearPedTasks(NeedsController._variables._ped)
                        status.thirst = status.thirst + 30.0

                        TriggerServerEvent('core:updateStatus', status)
                    else
                        NeedsController._variables._eating = false
                        ClearPedTasks(NeedsController._variables._ped)
                        DetachEntity(NeedsController._variables._prop, 1, 1)
                        DeleteObject(NeedsController._variables._prop)

                        exports['ZC-HelpNotify']:close('needs_drink')
                        exports['ZC-HelpNotify']:close('stop_needs_drink')
                    end


                -- if IsControlJustPressed(0, 73) then -- X
                --     NeedsController._variables._eating = false
                --     ClearPedTasks(NeedsController._variables._ped)
                --     DetachEntity(NeedsController._variables._prop, 1, 1)
                --     DeleteObject(NeedsController._variables._prop)

                --     exports['ZC-HelpNotify']:close('needs_drink')
                --     exports['ZC-HelpNotify']:close('stop_needs_drink')
                -- end

                Citizen.Wait(0)
            end
        end
    end)
end

NeedsController.food = function(item, itemData, data)
    if type(item) ~= 'string' then
        return
    end

    if type(itemData) ~= 'table' then
        return
    end

    if type(data) ~= 'table' then
        return
    end

    local self = {}
    self.item = item
    self.itemData = itemData
    self.uses = 1
    self.data = data
    self.shown = false

    Citizen.CreateThread(function()
        NeedsController._variables._eating = true

        if NeedsController._variables._eating then
            NeedsController._variables._prop = CreateObject(GetHashKey(ItemProps[self.item]), NeedsController._variables._pos.x, NeedsController._variables._pos.y, NeedsController._variables._pos.z + 0.2, true, true, true)
            AttachEntityToEntity(NeedsController._variables._prop, NeedsController._variables._ped, GetPedBoneIndex(NeedsController._variables._ped, 18905), self.data.Pos1 , self.data.Pos2, self.data.Pos3, self.data.Pos4 , self.data.Pos5, self.data.Pos6, true, true, false, true, 1, true)
        
            while NeedsController._variables._eating do
                -- if not self.shown then
                --     self.shown = true

                --     exports['ZC-HelpNotify']:open('Usa <strong>Y</strong> para comer', 'needs_eat')
                --     exports['ZC-HelpNotify']:open('Usa <strong>X</strong> para cancelar', 'stop_needs_eat')
                -- end

               -- if IsControlJustPressed(0, 246) then -- E
                    local status = W.GetPlayerData().status

                    if self.uses > 0 then
                        RequestAnimDict('mp_player_inteat@burger')
                        while not HasAnimDictLoaded('mp_player_inteat@burger') do 
                            Citizen.Wait(0) 
                        end

                        self.uses = self.uses - 1
                        TaskPlayAnim(NeedsController._variables._ped, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, 3000, 49, 1, false, false, false)
                        RemoveAnimDict('mp_player_inteat@burger')
                        Citizen.Wait(3000)
                        ClearPedTasks(NeedsController._variables._ped)
                        status.hunger = status.hunger + 30.0

                        TriggerServerEvent('core:updateStatus', status)
                    else
                        NeedsController._variables._eating = false
                        ClearPedTasks(NeedsController._variables._ped)
                        DetachEntity(NeedsController._variables._prop, 1, 1)
                        DeleteObject(NeedsController._variables._prop)
                        exports['ZC-HelpNotify']:close('needs_eat')
                        exports['ZC-HelpNotify']:close('stop_needs_eat')
                    end
                --end

                -- if IsControlJustPressed(0, 73) then -- X
                --     NeedsController._variables._eating = false
                --     ClearPedTasks(NeedsController._variables._ped)
                --     DetachEntity(NeedsController._variables._prop, 1, 1)
                --     DeleteObject(NeedsController._variables._prop)
                --     exports['ZC-HelpNotify']:close('needs_eat')
                --     exports['ZC-HelpNotify']:close('stop_needs_eat')
                -- end

                Citizen.Wait(0)
            end
        end
    end)
end

NeedsController.cancel = function()
    NeedsController._variables._eating = false
    ClearPedTasks(NeedsController._variables._ped)
    DetachEntity(NeedsController._variables._prop, 1, 1)
    DeleteObject(NeedsController._variables._prop)

    exports['ZC-HelpNotify']:close('needs_drink')
    exports['ZC-HelpNotify']:close('stop_needs_drink')
    exports['ZC-HelpNotify']:close('needs_eat')
    exports['ZC-HelpNotify']:close('stop_needs_eat')
end

RegisterNetEvent('needs:cancel', NeedsController.cancel)

NeedsController.eat = function(item, data, itype)
    if type(item) ~= 'table' then
        return
    end

    if type(data) ~= 'table' then
        return
    end

    if type(itype) ~= 'string' then
        return
    end

    local self = {}
    self.item = item
    self.data = data
    self.itype = itype

    if NeedsController._variables._eating then
        return
    end

    if exports['ZC-Smoke']:isBusy() then
        W.Notify('Alimentación', 'No puedes hacer ahora esto', 'error')
        return
    end

    if self.itype == 'drink' then
        NeedsController.drink(self.item.name, self.item, self.data)
    elseif self.itype == 'food' then
        NeedsController.food(self.item.name, self.item, self.data)
    end
end

RegisterNetEvent('Ox-Needs:eat', NeedsController.eat)

NeedsController.set = function()
    while true do
        if not NeedsController._variables._ped or (NeedsController._variables._ped and NeedsController._variables._ped ~= PlayerPedId()) then
            NeedsController._variables._ped = PlayerPedId()
        end

        if NeedsController._variables._ped then
            if not NeedsController._variables._pos or (NeedsController._variables._pos and NeedsController._variables._pos ~= GetEntityCoords(NeedsController._variables._ped)) then
                NeedsController._variables._pos = GetEntityCoords(NeedsController._variables._ped)
            end
        end

        Citizen.Wait(1500)
    end
end

Citizen.CreateThread(NeedsController.set)