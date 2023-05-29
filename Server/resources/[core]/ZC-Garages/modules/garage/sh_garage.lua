GARAGES_DATA = {
    garages = {
        [1] = { -- Central Garage [1]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('a_m_m_eastsa_01'), -- Ped model
                position = vec4(215.66, -810.01, 30.71, 338.76) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(215.66, -810.01, 30.71), -- Menu where you can select your car
                spawner = vec4(216.4, -788.88, 30.88, 157.0) -- Position of the garage spawner
            },
        },
        [2] = { -- Central Impound [2]
            name = 'Deposito',
            blip = true, -- Set blip for the garage
            impound = true, -- Set if the specified garage is an impound of vehicles
            garage = 2, -- Specify the garage will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can get out from deposit.
            job = false, -- Specify a job for the garage.
            text = '~y~Deposito',
            vehicles = nil,
            blipData = {
                sprite = 473,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('a_m_m_eastsa_01'), -- Ped model
                position = vec4(409.55, -1623.11, 29.29, 231.57) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(409.55, -1623.11, 29.29), -- Menu where you can select your car
                spawner = vec4(404.55, -1643.45, 28.87, 230.52) -- Position of the garage spawner
            },
        },
        [3] = {-- Garaje Grove [5]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_strpreach_01'), -- Ped model
                position = vec4(-5.72, -1738.64, 29.37, 127.36) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-5.72, -1738.64, 29.37), -- Menu where you can select your car
                spawner = vec4(-8.48, -1743.32, 29.37, 48.8) -- Position of the garage spawner
            },
        },
        [4] = {-- Garaje A.Vista [6]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_m_mexboss_02'), -- Ped model
                position = vec4(1161.46, -1467.04, 34.84, 92.44) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1161.46, -1467.04, 34.84), -- Menu where you can select your car
                spawner = vec4(1150.74, -1472.58, 34.69, 358.32) -- Position of the garage spawner
            },
        },
        [5] = {-- Garaje Gimnasio [7]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_strpreach_01'), -- Ped model
                position = vec4(-1186.32, -1508.48, 4.41, 18.72) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1186.32, -1508.48, 4.41), -- Menu where you can select your car
                spawner = vec4(-1193.64, -1491.72, 4.41, 213.68) -- Position of the garage spawner
            },
        },
        [6] = {-- Garaje Hawick Avenue [8]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_talmm'), -- Ped model
                position = vec4(277.8, -345.92, 44.97, 250) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(277.8, -345.92, 44.97), -- Menu where you can select your car
                spawner = vec4(290.72, -337.04, 44.97, 155.92) -- Position of the garage spawner
            },
        },
        [7] = {-- Garaje Clinton Avenue [9]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_talmm'), -- Ped model
                position = vec4(363.76, 296.32, 103.53, 246.12) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(363.76, 296.32, 103.53), -- Menu where you can select your car
                spawner = vec4(378.64, 287.76, 103.21, 63.84) -- Position of the garage spawner
            },
        },
        [8] = {-- Garaje Mirror Park [10]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_talmm'), -- Ped model
                position = vec4(1034.32, -766.4, 58.05, 229.68) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1034.32, -766.4, 58.05), -- Menu where you can select your car
                spawner = vec4(1021.2, -765.0, 58.01, 313.36) -- Position of the garage spawner
            },
        },
        [9] = {-- Garaje Tequila-la [11]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_brucie2'), -- Ped model
                position = vec4(-562.08, 322.12, 84.45, 76.24) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-562.08, 322.12, 84.45), -- Menu where you can select your car
                spawner = vec4(-571.92, 328.36, 84.57, 266.28) -- Position of the garage spawner
            },
        },
        [10] = {-- Garaje Rancho [12]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_f_y_vagos_01'), -- Ped model
                position = vec4(399.69, -1923.42, 24.79, 9.76) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(399.69, -1923.42, 24.79), -- Menu where you can select your car
                spawner = vec4(399.93, -1916.51, 24.8, 357.2) -- Position of the garage spawner
            },
        },
        [11] = {-- Garaje Boulevard del Perro [13]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_reporter'), -- Ped model
                position = vec4(-1512.96, -443.64, 35.65, 84.2) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1512.96, -443.64, 35.65), -- Menu where you can select your car
                spawner = vec4(-1522.32, -440.6, 35.49, 209.12) -- Position of the garage spawner
            },
        },
        [12] = {-- Garaje Route 68 [14]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 23, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_reporter'), -- Ped model
                position = vec4(1053.84, 2657.88, 39.61, 274.96) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1053.84, 2657.88, 39.61), -- Menu where you can select your car
                spawner = vec4(1058.68, 2661.64, 39.61, 350.12) -- Position of the garage spawner
            },
        }, 
        [13] = {-- Garaje Sandy [15]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 23, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('u_m_y_tattoo_01'), -- Ped model
                position = vec4(337.88, 2632.84, 44.53, 191.16) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(337.88, 2632.84, 44.53), -- Menu where you can select your car
                spawner = vec4(342.96, 2626.96, 44.57, 107.8) -- Position of the garage spawner
            },
        },
        [14] = {-- Garaje Federal [16]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 23, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('mp_s_m_armoured_01'), -- Ped model
                position = vec4(1852.8, 2590.56, 45.73, 267) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1852.8, 2590.56, 45.73), -- Menu where you can select your car
                spawner = vec4(1854.76, 2575.12, 45.73, 263.72) -- Position of the garage spawner
            },
        },
        [15] = {-- Garaje Mountain View [17]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 23, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('mp_m_waremech_01'), -- Ped model
                position = vec4(1729.2, 3707.44, 34.21, 23.08) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1729.2, 3707.44, 34.21), -- Menu where you can select your car
                spawner = vec4(1725.32, 3714.12, 34.29, 18.64) -- Position of the garage spawner
            },
        }, 

        [16] = {-- Garaje Grapeseed [18]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 23, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('mp_m_waremech_01'), -- Ped model
                position = vec4(1706.32, 4795.2, 42.01, 36.56) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1706.32, 4795.2, 42.01), -- Menu where you can select your car
                spawner = vec4(1695.72, 4802.84, 41.89, 161.76) -- Position of the garage spawner
            },
        }, 

        [17] = {-- Garaje Granja [19]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 23, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_hic'), -- Ped model
                position = vec4(1548.04, 2190.44, 78.89, 3.44) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1548.04, 2190.44, 78.89), -- Menu where you can select your car
                spawner = vec4(1546.72, 2203.64, 78.69, 87.8) -- Position of the garage spawner
            },
        }, 
        [18] = {-- Garaje Paleto [20]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 22, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_hic'), -- Ped model
                position = vec4(115.4, 6641.8, 31.86, 47.4) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(115.4, 6641.8, 31.86), -- Menu where you can select your car
                spawner = vec4(108.36, 6642.36, 31.49, 129.56) -- Position of the garage spawner
            },
        },
        [19] = {-- Garaje Aeropuerto [25]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('cs_fbisuit_01'), -- Ped model
                position = vec4(-790.56, -2084.32, 9.09, 45.08) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-790.56, -2084.32, 9.09), -- Menu where you can select your car
                spawner = vec4(-788.48, -2078.88, 8.97, 58.32) -- Position of the garage spawner
            },
        },
        [20] = {-- Garaje Barcos [26]
            name = 'Puerto',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 14 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Puerto', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 427,
                colour = 4,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('cs_fbisuit_01'), -- Ped model
                position = vec4(-862.98, -1325.0, 1.61, 288.47) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-862.98, -1325.0, 1.61), -- Menu where you can select your car
                spawner = vec4(-859.57, -1328.74, 1.0, 109.7) -- Position of the garage spawner
            },
        },
        [21] = {-- Garaje Barcos [27]
            name = 'Deposito_Barcos',
            blip = true, -- Set blip for the garage
            impound = true, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 14 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Deposito del Puerto', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 473,
                colour = 0,
                scale = 0.7,
            },
            ped = { -- Ped data
                model = GetHashKey('cs_fbisuit_01'), -- Ped model
                position = vec4(-754.65, -1369.11, 1.6, 51.11) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-754.65, -1369.11, 1.6), -- Menu where you can select your car
                spawner = vec4(-753.68, -1362.98, 0.40, 230.36) -- Position of the garage spawner
            },
        },
        [22] = {-- Deposito Paleto [28]
            name = 'Deposito',
            blip = true, -- Set blip for the garage
            impound = true, -- Set if the specified garage is an impound of vehicles
            garage = 22, -- Specify the garage will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can get out from deposit.
            job = false, -- Specify a job for the garage.
            text = '~y~Deposito',
            vehicles = nil,
            blipData = {
                sprite = 473,
                colour = 0,
                scale = 0.7,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_hic'), -- Ped model
                position = vec4(-200.08, 6234.33, 31.5, 222.92) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-200.08, 6234.33, 31.5), -- Menu where you can select your car
                spawner = vec4(-199.7, 6214.58, 31.49, 225.7) -- Position of the garage spawner
            },
        },
        [23] = {-- Deposito Sandy [29]
            name = 'Deposito',
            blip = true, -- Set blip for the garage
            impound = true, -- Set if the specified garage is an impound of vehicles
            garage = 23, -- Specify the garage will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can get out from deposit.
            job = false, -- Specify a job for the garage.
            text = '~y~Deposito',
            vehicles = nil,
            blipData = {
                sprite = 473,
                colour = 0,
                scale = 0.7,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_hic'), -- Ped model
                position = vec4(1697.25, 3595.6, 35.61, 299.67) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1697.25, 3595.6, 35.61), -- Menu where you can select your car
                spawner = vec4(1707.25, 3593.67, 35.42, 257.74) -- Position of the garage spawner
            },
        },
        [24] = { -- Madrazos [30]
            name = "Garaje Central",
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 25, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = 'madrazo', -- Specify a job for the garage.
            text = '~y~Garaje de sociedad', -- Text will show up the ped
            vehicles = nill, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.8,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_hic'), -- Ped model
                position = vec4(1239.66, 2731.38, 38.25, 266.99) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1239.66, 2731.38, 38.25), -- Menu where you can select your car
                spawner = vec4(1250.48, 2730.21, 38.5, 266.94) -- Position of the garage spawner
            },
        },
        [25] = { -- Deposito Madrazo [31]
            name = 'Deposito',
            blip = false, -- Set blip for the garage
            impound = true, -- Set if the specified garage is an impound of vehicles
            garage = 24, -- Specify the garage will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can get out from deposit.
            job = "madrazo", -- Specify a job for the garage.
            text = '~y~Deposito',
            vehicles = 'society',
            blipData = {
                sprite = 473,
                colour = 7,
                scale = 0.7,
            },
            ped = { -- Ped data
                model = GetHashKey('a_m_m_eastsa_01'), -- Ped model
                position = vec4(1572.12, 2263.08, 73.93, 349.57) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1572.12, 2263.08, 73.93), -- Menu where you can select your car
                spawner = vec4(1569.24, 2203.96, 77.61, 89.52) -- Position of the garage spawner
            },
        },
        [26] = {-- Garaje Ace Cafe [32]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_isldj_01'), -- Ped model
                position = vec4(-2207.6, 1115.04, -24.19, 275.24) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-2207.6, 1115.04, -24.19), -- Menu where you can select your car
                spawner = vec4(-2201.0, 1115.32, -24.19, 269.04) -- Position of the garage spawner
            },
        },
        [27] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_hic'), -- Ped model
                position = vec4(1396.92, 1113.96, 114.89, 5.32) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(1396.92, 1113.96, 114.89), -- Menu where you can select your car
                spawner = vec4(1414.96, 1118.48, 114.89, 87.08) -- Position of the garage spawner
            },
        },
        [28] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('csb_ramp_marine'), -- Ped model
                position = vec4(-1868.98, 2958.07, 32.82, 332.32) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1868.98, 2958.07, 32.82), -- Menu where you can select your car
                spawner = vec4(-1864.96, 2965.48, 31.82, 339.08) -- Position of the garage spawner
            },
        },
        [29] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_y_cop_01'), -- Ped model
                position = vec4(429.98, -973.07, 25.71, 168.32) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(429.98, -973.07, 25.71), -- Menu where you can select your car
                spawner = vec4(434.96,-977.48, 25.72, 177.08) -- Position of the garage spawner
            },
        },
        [30] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_y_cop_01'), -- Ped model
                position = vec4(-423.67, -341.49, 24.23, 100.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-423.67, -341.49, 24.23), -- Menu where you can select your car
                spawner = vec4(-431.91, -342.74, 24.23, 104.31) -- Position of the garage spawner
            },
        },
        [31] = {-- Garaje Fuente Blanca [33]
            name = 'Aeropuerto',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 32, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 423,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_pilot_01'), -- Ped model
                position = vec4(-1668.59, -3103.14, 13.94, 336.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1668.59, -3103.14, 13.94), -- Menu where you can select your car
                spawner = vec4(-1640.86, -3097.71, 13.94, 315.16) -- Position of the garage spawner
            },
        },
        [32] = {-- Garaje Fuente Blanca [33]
            name = 'Deposito Aereo',
            blip = true, -- Set blip for the garage
            impound = true, -- Set if the specified garage is an impound of vehicles
            garage = 32, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Deposito Aereo', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 473,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_pilot_01'), -- Ped model
                position = vec4(-1522.22, -3216.59, 14.65, 330.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1522.22, -3216.59, 14.65), -- Menu where you can select your car
                spawner = vec4(-1498.55, -3202.74, 13.94, 19.16) -- Position of the garage spawner
            },
        },
        [33] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('mp_m_fibsec_01'), -- Ped model
                position = vec4(375.9, -1621.24, 29.29, 143.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(375.9, -1621.24, 29.29), -- Menu where you can select your car
                spawner = vec4(386.5, -1617.99, 29.29, 299.16) -- Position of the garage spawner
            },
        },
        [34] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('mp_m_fibsec_01'), -- Ped model
                position = vec4(2516.92, -355.8, 94.13, 231.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(2516.92, -355.8, 94.13), -- Menu where you can select your car
                spawner = vec4(2534.01, -362.76, 92.99, 301.16) -- Position of the garage spawner
            },
        },
        [35] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = true, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_gardener_01'), -- Ped model
                position = vec4(888.12, -1.25, 78.76, 154.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(888.12, -1.25, 78.76), -- Menu where you can select your car
                spawner = vec4(882.71, -5.01, 78.76, 147.16) -- Position of the garage spawner
            },
        },
        [36] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_highsec_02'), -- Ped model
                position = vec4(-3031.21, 92.66, 12.35, 314.14) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-3031.21, 92.66, 12.35), -- Menu where you can select your car
                spawner = vec4(-3017.55, 88.01, 11.61, 333.14) -- Position of the garage spawner
            },
        },
        [37] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_highsec_02'), -- Ped model
                position = vec4(-208.43, -1981.43, 27.62, 274.7) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-208.43, -1981.43, 27.62), -- Menu where you can select your car
                spawner = vec4(-199.74, -1975.53, 27.62, 15.14) -- Position of the garage spawner
            },
        },
    [38] = {-- Garaje Barcos [26]
            name = 'Puerto',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 14 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Puerto', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 427,
                colour = 4,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('cs_fbisuit_01'), -- Ped model
                position = vec4(-283.45, 6631.06, 7.34, 255.47) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-283.45, 6631.06, 7.34), -- Menu where you can select your car
                spawner = vec4(-301.33, 6617.4, 0.0, 91.7) -- Position of the garage spawner
            },
        },
        [39] = {-- Garaje Fuente Blanca [33]
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('s_m_m_highsec_02'), -- Ped model
                position = vec4(814.9, -735.57, 27.6, 112.7) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(814.9, -735.57, 27.6), -- Menu where you can select your car
                spawner = vec4(805.07, -733.86, 27.6, 81.7) -- Position of the garage spawner
            },
        },
        [40] = {-- Garaje White Families mafia
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-1467.9, -30.15, 54.68, 319.7) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1467.9, -30.15, 54.68), -- Menu where you can select your car
                spawner = vec4(-1463.34, -26.4, 54.65, 234.68) -- Position of the garage spawner
            },
        },
        [41] = {-- Garaje Red Clover mafia
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-1780.13, 462.63, 128.31, 108.7) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1780.13, 462.63, 128.31), -- Menu where you can select your car
                spawner = vec4(-1797.73, 457.62, 128.31, 86.68) -- Position of the garage spawner
            },
        },
        [42] = {-- Garaje Santana mafia
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-1896.26, 2053.53, 140.97, 160.7) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-1896.26, 2053.53, 140.97), -- Menu where you can select your car
                spawner = vec4(-1888.0, 2045.24, 140.87, 247.7) -- Position of the garage spawner
            },
        },
        [43] = {-- Garaje drivers
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = 'drivers', -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-77.67, 364.33, 112.44, 158.81) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-77.67, 364.33, 112.44), -- Menu where you can select your car
                spawner = vec4(-83.55, 352.87, 112.44, 275.7) -- Position of the garage spawner
            },
        },
        [43] = {-- Garaje drivers
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-705.67, -973.9, 20.39, 223.81) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-705.67, -973.9, 20.39), -- Menu where you can select your car
                spawner = vec4(-696.53, -982.76, 20.39, 358.7) -- Position of the garage spawner
            },
        },
        [44] = {-- Garaje cosanostra
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-115.64, 997.08, 235.76, 112.81) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-115.64, 997.08, 235.76), -- Menu where you can select your car
                spawner = vec4(-123.18, 995.62, 235.75, 151.7) -- Position of the garage spawner
            },
        },
        [45] = {-- Garaje cosanostra
            name = 'Garaje Central',
            blip = false, -- Set blip for the garage
            impound = false, -- Set if the specified garage is an impound of vehicles
            deposit = 2, -- Specify the deposit will the vehicle goes
            classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
            job = false, -- Specify a job for the garage.
            text = '~y~Garaje', -- Text will show up the ped
            vehicles = nil, -- Set the models vehicles can save on this garage
            blipData = {
                sprite = 290,
                colour = 0,
                scale = 0.6,
            },
            ped = { -- Ped data
                model = GetHashKey('g_m_importexport_01'), -- Ped model
                position = vec4(-2610.54, 1672.54, 141.87, 313.81) -- Position of the ped
            },
            positions = { -- Positions of the garage
                menu = vec3(-2610.54, 1672.54, 141.87), -- Menu where you can select your car
                spawner = vec4(-2603.03, 1677.0, 141.87, 214.7) -- Position of the garage spawner
            },
        },
        [46] = {-- Garaje muelle
        name = 'Garaje Central',
        blip = true, -- Set blip for the garage
        impound = false, -- Set if the specified garage is an impound of vehicles
        deposit = 2, -- Specify the deposit will the vehicle goes
        classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }, -- Specify the classes the garage can save.
        job = false, -- Specify a job for the garage.
        text = '~y~Garaje', -- Text will show up the ped
        vehicles = nil, -- Set the models vehicles can save on this garage
        blipData = {
            sprite = 290,
            colour = 0,
            scale = 0.6,
        },
        ped = { -- Ped data
            model = GetHashKey('s_m_y_construct_02'), -- Ped model
            position = vec4(211.9132, -3076.8706, 5.7827, 50.6383) -- Position of the ped 
        },
        positions = { -- Positions of the garage
            menu = vec3(211.9132, -3076.8706, 5.7827), -- Menu where you can select your car
            spawner = vec4(205.6244, -3092.2681, 5.7757, 359.1517) -- Position of the garage spawner
        },
    },
    },
}