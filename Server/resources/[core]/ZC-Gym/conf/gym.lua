Settings.Skills = {
    ['stress'] = {label = 'estrés', points = 1},
    ['strength'] = {label = 'fuerza', points = 1},
    ['stamina'] = {label = 'estamina', points = 1}
}

Settings.Gyms = {
    [1] = {
        name = 'Gimnasio Sur',
        shop = vector3(-1195.6, -1577.7, 4.2),
        points = {
            ['yoga'] = {
                coords = vector3(-1217.2, -1541.9, 4.5),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
            ['yoga-2'] = {
                coords = vector3(-1224.6, -1547.01, 4.5),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
            ['yoga-3'] = {
                coords = vector3(-1219.5, -1543.5, 4.5),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
            ['yoga-4'] = {
                coords = vector3(-1222.1, -1545.3, 4.5),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
             ['run'] = {
                 coords = vector3(-1213.32, -1533.56, 4),
                 message = 'Hacer ejercicio',
                 action = 'Velocidad',
                 specificZone = 'beach'
             },
            ['Push_Up'] = {
                coords = vector3(-1204.76, -1564.36, 4.3),
                heading = 29.5,
                message = 'Hacer ejercicio',
                action = 'Dominadas'
            },
            ['Push_Up-2'] = {
                coords = vector3(-1199.88, -1571.28, 4.3),
                heading = 214.5,
                message = 'Hacer ejercicio',
                action = 'Dominadas'
            },
            ['weights-1'] = {
                coords = vector3(-1210.04, -1561.28, 4.3),
                heading = 269.5,
                message = 'Hacer ejercicio',
                action = 'Pesas'
            },
            ['weights-2'] = {
                coords = vector3(-1198.24, -1573.52, 4.3),
                heading = 33.5,
                message = 'Hacer ejercicio',
                action = 'Pesas'
            },
            ['Situps-1'] = {
                coords = vector3(-1199.28, -1563.28, 4.3),
                heading = 129.5,
                message = 'Hacer ejercicio',
                action = 'Abdominales'
            },
            ['Situps-2'] = {
                coords = vector3(-1200.52, -1577.24, 4.3),
                heading = 307.5,
                message = 'Hacer ejercicio',
                action = 'Abdominales'
            },
            ['Situps-3'] = {
                coords = vector3(-1207.72, -1566.24, 4.3),
                heading = 313.5,
                message = 'Hacer ejercicio',
                action = 'Abdominales'
            },
            ['Flex-1'] = {
                coords = vector3(-1209.2, -1564.24, 4.3),
                heading = 304.5,
                message = 'Hacer ejercicio',
                action = 'Flexiones'
            },
            ['Flex-2'] = {
                coords = vector3(-1202.48, -1559.24, 4.3),
                heading = 124.5,
                message = 'Hacer ejercicio',
                action = 'Flexiones'
            },
            ['Flex-3'] = {
                coords = vector3(-1196.16, -1567.8, 4.3),
                heading = 222.5,
                message = 'Hacer ejercicio',
                action = 'Flexiones'
            }
        },
    },
    [2] = {
        name = 'Gimnasio Norte',
        shop = vector3(1238.52, 2718.88, 37.55),
        points = {
            ['yoga'] = {
                coords = vector3(1240.16, 2705.48, 37.55),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
            ['yoga-2'] = {
                coords = vector3(1242.72, 2704.12, 37.55),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
            ['yoga-3'] = {
                coords = vector3(1245.48, 2702.44, 37.55),
                message = 'Hacer ejercicio',
                action = 'Yoga'
            },
            -- ['run'] = {
            --     coords = vector3(-1213.32, -1533.56, 4),
            --     message = 'Hacer ejercicio',
            --     action = 'Velocidad',
            --     specificZone = 'beach'
            -- },
            ['Push_Up'] = {
                coords = vector3(1250.08, 2717.8, 37.55),
                heading = 29.5,
                message = 'Hacer ejercicio',
                action = 'Dominadas'
            },
            ['Push_Up-2'] = {
                coords = vector3(1249.84, 2715.8, 37.55),
                heading = 214.5,
                message = 'Hacer ejercicio',
                action = 'Dominadas'
            },
            ['weights-1'] = {
                coords = vector3(1246.64, 2705.96, 37.55),
                heading = 269.5,
                message = 'Hacer ejercicio',
                action = 'Pesas'
            },
            ['weights-2'] = {
                coords = vector3(1244.52, 2712.48, 37.55),
                heading = 33.5,
                message = 'Hacer ejercicio',
                action = 'Pesas'
            },
            ['Situps-1'] = {
                coords = vector3(1241.32, 2709.16, 37.55),
                heading = 129.5,
                message = 'Hacer ejercicio',
                action = 'Abdominales'
            },
            ['Situps-2'] = {
                coords = vector3(1241.44, 2712.04, 37.55),
                heading = 307.5,
                message = 'Hacer ejercicio',
                action = 'Abdominales'
            },
            ['Flex-1'] = {
                coords = vector3(1240.84, 2715.92, 37.55),
                heading = 304.5,
                message = 'Hacer ejercicio',
                action = 'Flexiones'
            },
            ['Flex-2'] = {
                coords = vector3(1243.3, 2717.88, 37.55),
                heading = 124.5,
                message = 'Hacer ejercicio',
                action = 'Flexiones'
            },
        },
    },
}

Settings.Bikes = {
    { coords = vec4(-704.12, -942.36, 19.33, 94.31) },
    { coords = vec4(-522.32, -257.68, 34.84, 304.62) },
    { coords = vec4(-51.56, -1768.81, 29.22, 57.41) },
    { coords = vec4(1230.8, 2725.96, 38.0, 189.11) },
    { coords = vec4(287.64, -1590.04, 29.57, 15.04) },
    { coords = vec4(1253.6, 2697.24, 37.05, 0.0) },
    { coords = vec4(1980.52, 3747.12, 31.21, 0.0) },
    { coords = vec4(2491.68, 4123.68, 37.25, 0.0) },
    { coords = vec4(-1192.68, -1546.04, 3.57, 254.48) },
    { coords = vec4(-1034.56, -2732.73, 19.17, 334.48) },
}