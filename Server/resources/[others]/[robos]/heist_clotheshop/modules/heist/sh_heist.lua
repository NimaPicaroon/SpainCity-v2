HEIST_DATA = {
    cops = 3,
    shops = {
        [1] = {
            coords = vec4(-1447.64, -240.04, 48.85 - 0.98, 44.88),
            model = `a_f_y_femaleagent`,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [2] = {
            coords = vec4(-706.44, -151.2, 36.45 - 0.98, 113.19),
            model = `a_f_y_femaleagent`,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [3] = {
            coords = vec4(122.88, -212.92, 53.61 - 0.98, 233.84),
            model = `a_f_y_femaleagent`,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [4] = {
            coords = vec4(-166.96, -301.52, 38.77 - 0.98, 246.72),
            model = `a_f_y_femaleagent`,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [5] = {
            coords = vec4(1200.76, 2707.32, 37.29 - 0.98, 93.8),
            model = `a_f_y_femaleagent`,
            defaultCooldown = 12 * 60 * 4000,
            data = {
                robbed = false,
                robbing = false,
                cooldown = 12 * 60 * 4000, ---4 hour
                entity = nil
            },
        },
        [6] = {
            coords = vec4(621.32, 2754.0, 41.13 - 0.98, 91.72),
            model = `a_f_y_femaleagent`,
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
    GlobalState.HeistClotheshops = HEIST_DATA.shops
end