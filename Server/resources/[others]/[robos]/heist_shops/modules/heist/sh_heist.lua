HEIST_DATA = {
    cops = 3,
    shops = {
        [1] = {
            coords = vec4(549.32, 2669.68, 42.16 - 0.98, 87.92),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [2] = {
            coords = vec4(2676.6, 3280.24, 55.24 - 0.98, 338.92),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [3] = {
            coords = vec4(1697.84, 4923.04, 42.08 - 0.98, 319.92),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [4] = {
            coords = vec4(1164.92,-323.64, 69.2 - 0.98, 100.32),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [5] = {
            coords = vec4(-1222.0, -908.32, 12.32 - 0.98, 37.08),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [6] = {
            coords = vec4(-2966.32, 391.12, 15.04 - 0.98, 92.04),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [7] = {
            coords = vec4(372.92, 328.2, 103.56 - 0.98, 248.12),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [8] = {
            coords = vec4(2555.24, 380.92, 108.64 - 0.98, 354.56),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [9] = {
            coords = vec4(-1486.28, -378.0, 40.16 - 0.98, 136.92),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [10] = {
            coords = vec4(1728.64, 6416.8, 35.04 - 0.98, 238.96),
            model = 416176080,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
    }
}

if IsDuplicityVersion() then
    GlobalState.HeistShops = HEIST_DATA.shops
end