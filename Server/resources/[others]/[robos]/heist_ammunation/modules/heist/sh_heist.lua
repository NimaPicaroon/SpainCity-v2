HEIST_DATA = {
    COPS = 4, -- Necessary cops to rob
    WEAPONS = { -- Reward weapons can drops
        PISTOLS = {
            { name = 'WEAPON_VINTAGEPISTOL' },
            { name = 'WEAPON_SNSPISTOL' },
        },
         SMGS = {
            { name = 'WEAPON_MINISMG' },
         },
    },
    STORES = { -- Stores data
        { -- North Ammunation
            name = 'North Ammunation', -- Name of the store
            coords = vec3(1700.32, 3755.34, 34.71), -- Coords of the store
            timer = 0, -- Timer to check the last time this store has been robbed
            cabinets = { -- Cabinets of the ammunation
                {
                    coords = vec4(1693.86, 3754.23, 34.71, 137.56),
                    robbed = false,
                    text = '~w~Chalecos',
                    animation = true,
                    reward = function(source)
                        local src = source
                        local ply = Wave.GetPlayer(src)

                        if not ply then
                            return
                        end

                        ply.addItemToInventory('bulletproof', math.random(3, 5))
                    end,
                },
                { 
                    coords = vec4(1693.09, 3762.56, 34.71, 47.2),
                    robbed = false,
                    text = '~w~Vitrina',
                    reward = function(source)
                        local src = source
                        local ply = Wave.GetPlayer(src)

                        if not ply then
                            return
                        end

                        ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                        ply.addItemToInventory('pistol_box', math.random(2, 3)) 
                        ply.addItemToInventory('emptyclip', math.random(5, 10))
                    end,
                },
                { 
                    coords = vec4(1693.06, 3759.92, 34.77, 47.6), 
                    robbed = false,
                    text = '~w~Vitrina',
                    reward = function(source)
                        local src = source
                        local ply = Wave.GetPlayer(src)

                        if not ply then
                            return
                        end

                        ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                        ply.addItemToInventory('emptyclip', math.random(5, 10))
                    end,
                },
                { 
                    coords = vec4(1690.67, 3760.06, 34.77, 47.08), 
                    robbed = false,
                    text = '~w~Vitrina',
                    reward = function(source)
                        local src = source
                        local ply = Wave.GetPlayer(src)
                        local random = math.random(1, 2)

                        if not ply then
                            return
                        end

                        if random == 1 then
                            ply.addItemToInventory(HEIST_DATA.WEAPONS.SMGS[math.random(1, #HEIST_DATA.WEAPONS.SMGS)].name, 1)
                        else
                            ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                        end

                        ply.addItemToInventory('shotgun_box', 1)
                        ply.addItemToInventory('emptyclip', math.random(5, 10))
                    end,
                }
            },
        },
        { -- North Ammunation
        name = 'South Ammunation', -- Name of the store
        coords = vec3(18.89, -1108.74, 29.8), -- Coords of the store
        timer = 0, -- Timer to check the last time this store has been robbed
        cabinets = { -- Cabinets of the ammunation
            {
                coords = vec4(16.97, -1109.59, 29.88, 137.56),
                robbed = false,
                text = '~w~Chalecos',
                animation = true,
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)

                    if not ply then
                        return
                    end

                    ply.addItemToInventory('bulletproof', math.random(3, 5))
                end,
            },
            { 
                coords = vec4(21.99, -1106.69, 29.8, 340.2),
                robbed = false,
                text = '~w~Vitrina',
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)

                    if not ply then
                        return
                    end

                    ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                    ply.addItemToInventory('pistol_box', math.random(2, 3)) 
                    ply.addItemToInventory('emptyclip', math.random(5, 10))
                end,
            },
            { 
                coords = vec4(24.45, -1105.54, 29.8, 340.6), 
                robbed = false,
                text = '~w~Vitrina',
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)

                    if not ply then
                        return
                    end

                    ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                    ply.addItemToInventory('emptyclip', math.random(5, 10))
                end,
            },
            { 
                coords = vec4(20.72, -1104.16, 29.8, 340.08), 
                robbed = false,
                text = '~w~Vitrina',
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)
                    local random = math.random(1, 2)

                    if not ply then
                        return
                    end

                    if random == 1 then
                        ply.addItemToInventory(HEIST_DATA.WEAPONS.SMGS[math.random(1, #HEIST_DATA.WEAPONS.SMGS)].name, 1)
                    else
                        ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                    end

                    ply.addItemToInventory('shotgun_box', 1)
                    ply.addItemToInventory('emptyclip', math.random(5, 10))
                end,
            }
        },
    },
    { -- North Ammunation
        name = 'Ammunation VIP', -- Name of the store
        coords = vec3(812.58, -2154.56, 29.7), -- Coords of the store
        timer = 0, -- Timer to check the last time this store has been robbed
        cabinets = { -- Cabinets of the ammunation
            {
                coords = vec4(814.05, -2153.15, 29.7, 270.56),
                robbed = false,
                text = '~w~Chalecos',
                animation = true,
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)

                    if not ply then
                        return
                    end

                    ply.addItemToInventory('bulletproof', math.random(3, 5))
                end,
            },
            { 
                coords = vec4(810.12, -2157.67, 29.7, 183.2),
                robbed = false,
                text = '~w~Vitrina',
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)

                    if not ply then
                        return
                    end

                    ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                    ply.addItemToInventory('pistol_box', math.random(2, 3)) 
                    ply.addItemToInventory('emptyclip', math.random(5, 10))
                end,
            },
            { 
                coords = vec4(808.74, -2159.62, 29.7, 183.6), 
                robbed = false,
                text = '~w~Vitrina',
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)

                    if not ply then
                        return
                    end

                    ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                    ply.addItemToInventory('emptyclip', math.random(5, 10))
                end,
            },
            { 
                coords = vec4(812.72, -2159.62, 29.7, 183.08), 
                robbed = false,
                text = '~w~Vitrina',
                reward = function(source)
                    local src = source
                    local ply = Wave.GetPlayer(src)
                    local random = math.random(1, 2)

                    if not ply then
                        return
                    end

                    if random == 1 then
                        ply.addItemToInventory(HEIST_DATA.WEAPONS.SMGS[math.random(1, #HEIST_DATA.WEAPONS.SMGS)].name, 1)
                    else
                        ply.addItemToInventory(HEIST_DATA.WEAPONS.PISTOLS[math.random(1, #HEIST_DATA.WEAPONS.PISTOLS)].name, math.random(1, 2))
                    end

                    ply.addItemToInventory('subfusil_box', 2)
                    ply.addItemToInventory('shotgun_box', 1)
                    ply.addItemToInventory('emptyclip', math.random(5, 10))
                end,
            }
        },
    },
    }
}