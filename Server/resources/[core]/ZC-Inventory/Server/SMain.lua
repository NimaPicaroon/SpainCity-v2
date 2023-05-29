GiveItem = function(name, amount, metadata)
    local src = source
    local player = W.GetPlayer(src)
    if not metadata then
        metadata = W.DefaultMetadata[name] or false
    end
    if player.canHoldItem(name, amount) then
        player.addItemToInventory(name, amount, metadata)
    end
end

RegisterNetEvent("ZC-Inventory:giveItem", GiveItem)

RemoveItem = function(name, amount, slotId)
    local src = source
    local player = W.GetPlayer(src)

    if slotId > 0 then
        player.removeItemFromInventory(name, amount, slotId)
         player.Notify('INVENTARIO', 'Has perdido ~y~x'..amount..' '..W.Items[name].label..'~w~', 'info')
    end
end

RegisterNetEvent("ZC-Inventory:removeItem", RemoveItem)

UpdateAmmo = function(data, slotData, removeLife)
    local src = source
    local player = W.GetPlayer(src)

    if removeLife then
        local remove = 1
        if removeLife == "pistol_rounds" then
            remove = 1
        elseif removeLife == "subfusil_rounds" then
            remove = 1
        elseif removeLife == "fusil_rounds" then
            remove = 1
        elseif removeLife == "shotgun_rounds" then
            remove = 1
        elseif removeLife == "sniper_rounds" then
            remove = 2
        end
        player.updateItemdata('life', data.slotId, remove, 'remove')
    end

    player.updateRoundsSlot(data.slotId, data.metadata.bullets)
    player.updateRounds(data.slotId, data.metadata.bullets)
end

RegisterNetEvent('weapons:updateAmmo', UpdateAmmo)

RemoveWeapon = function(data)
    local src = source
    local player = W.GetPlayer(src)

    player.removeItemFromInventory(data.name, 1, data.slotId)
end

RegisterNetEvent('weapons:removeWeapon', RemoveWeapon)

-- Attachments
HasAttachment = function(Component, Attachments)
    local retval = false
    local key = nil
    for k, v in pairs(Attachments) do
        if v.component == Component then
            key = k
            retval = true
        end
    end
    return retval, key
end

EquipAttachment = function(WeaponSlot, AttachmentData, Attachment)
    local Id = source
    local Entity = W.GetPlayer(Id)
    local Inventory = Entity.getInventory()

    if not Entity then
        return
    end

    local Weapon = Entity.getItemFromSlot(WeaponSlot)

    if not Weapon then
        return print('weapon not found?')
    end

    if Weapon.metadata.attachments then
        local Attach = HasAttachment(Attachment.component, Weapon.metadata.attachments)

        if not Attach then
            local AddAttachment = Entity.addComponent(WeaponSlot, Attachment)

            if AddAttachment then
                Entity.removeItemFromInventory(AttachmentData.name, 1, AttachmentData.slotId)
                TriggerClientEvent('inventory:addAttachment', Id, WeaponSlot, Attachment)
                --print('odio los negros')

            end
        else
            return Entity.Notify('Componentes', 'Tu arma ya tiene este componente agregado', 'error')
        end
    end
end

RegisterNetEvent('inventory:equipAttachment', EquipAttachment)

W.Attachments = {
    [`WEAPON_PISTOL`] = {
        ['camuflaje'] = {
            component = `COMPONENT_PISTOL_VARMOD_LUXE`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP_02`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_PI_FLSH`,
            item = 'linterna'
        }
    },
    [`WEAPON_PISTOL_MK2`] = {
        ['camuflaje'] = {
            component = `COMPONENT_PISTOL_MK2_CAMO`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP_02`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_PI_FLSH_02`,
            item = 'linterna'
        },
        ['mounted_scope'] = {
            component = `COMPONENT_AT_PI_RAIL`,
            item = 'mounted_scope'
        }
    },
    [`WEAPON_COMBATPISTOL`] = {
        ['camuflaje'] = {
            component = `COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_PI_FLSH`,
            item = 'linterna'
        }
    },
    [`WEAPON_HEAVYPISTOL`] = {
        ['camuflaje'] = {
            component = `COMPONENT_HEAVYPISTOL_VARMOD_LUXE`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_PI_FLSH`,
            item = 'linterna'
        }
    },
    [`WEAPON_VINTAGEPISTOL`] = {
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP`,
            item = 'silenciador'
        }
    },
    [`WEAPON_SMG`] = {
        ['camuflaje'] = {
            component = `COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_AR_SUPP_02`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MACRO`,
            item = 'linterna'
        }
    },
    [`WEAPON_SMG_MK2`] = {
        ['camuflaje'] = {
            component = `COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2`,
            item = 'scope'
        },
        ['holografik_scope'] = {
            component = `COMPONENT_AT_SIGHTS_SMG`,
            item = 'holografik_scope'
        },
        ['medium_scope'] = {
            component = `COMPONENT_AT_SCOPE_SMALL_SMG_MK2`,
            item = 'medium_scope'
        }
    }, 
        [`WEAPON_SMG_MK2`] = {
        ['camuflaje'] = {
            component = `COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2`,
            item = 'scope'
        },
        ['holografik_scope'] = {
            component = `COMPONENT_AT_SIGHTS_SMG`,
            item = 'holografik_scope'
        },
        ['medium_scope'] = {
            component = `COMPONENT_AT_SCOPE_SMALL_SMG_MK2`,
            item = 'medium_scope'
        }
    },
    [`WEAPON_COMBATPDW`] = {
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_SMALL`,
            item = 'scope'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        }
    },
    [`WEAPON_MACHINEPISTOL`] = {
        ['silenciador'] = {
            component = `COMPONENT_AT_PI_SUPP`,
            item = 'silenciador'
        }
    },
    [`WEAPON_MICROSMG`] = {
        ['camuflaje'] = {
            component = `COMPONENT_MICROSMG_VARMOD_LUXE`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_AR_SUPP_02`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_PI_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MACRO`,
            item = 'scope'
        }
    },
    [`WEAPON_ASSAULTRIFLE`] = {
        ['camuflaje'] = {
            component = `COMPONENT_ASSAULTRIFLE_VARMOD_LUXE`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_AR_SUPP_02`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MACRO`,
            item = 'scope'
        }
    },
    [`WEAPON_CARBINERIFLE`] = {
        ['camuflaje'] = {
            component = `COMPONENT_CARBINERIFLE_VARMOD_LUXE`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_AR_SUPP`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MEDIUM`,
            item = 'scope'
        }
    },
    [`WEAPON_CARBINERIFLE_MK2`] = {
        ['camuflaje'] = {
            component = `COMPONENT_CARBINERIFLE_VARMOD_LUXE`,
            item = 'camuflaje'
        },
        ['silenciador'] = {
            component = `COMPONENT_AT_AR_SUPP`,
            item = 'silenciador'
        },
        ['linterna'] = {
            component = `COMPONENT_AT_AR_FLSH`,
            item = 'linterna'
        },
        ['scope'] = {
            component = `COMPONENT_AT_SCOPE_MACRO_MK2`,
            item = 'scope'
        },
        ['holografik_scope'] = {
            component = `COMPONENT_AT_SIGHTS`,
            item = 'holografik_scope'
        },
        ['medium_scope'] = {
            component = `COMPONENT_AT_SCOPE_MEDIUM_MK2`,
            item = 'medium_scope'
        }
    },
}