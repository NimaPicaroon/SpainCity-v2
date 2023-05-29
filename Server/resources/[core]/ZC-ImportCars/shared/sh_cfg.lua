Cfg = {}

Cfg.AvailableCars = { -- Lista con los vehículos que pueden aparecer en la importación
    "sultan2",
    "everon",
    "kamacho",
    "riata",
    "contender",
    "baller4",
    "landstalker2",
    "toros",
    "comet4",
    "exemplar",
    "felon",
    "oracle2",
    "raiden",
    "neon",
    "revolter",
    "jugular",
    "schafter4",
    "cinquemila",
}

Cfg.MoneySections = { -- Baremo de recompesas, la [1] tiene que ser inferior a la [2].
    [1] = 4000,
    [2] = 4500,
}

Cfg.PoliceNeeded = 4 -- Policía necesaria para comenzar la actividad

Cfg.TickPolice = 4 -- (seconds) Tiempo cada cuanto se actualiza el localizador

Cfg.TickPoliceDuration = 4 -- (minutos) Tiempo que el localizador está activo

Cfg.CurrentImportersAtTheSameTime = 4 -- Máximo de importaciones activos simultaneamente

Cfg.Starter = {
    coords = vector4(755.68, -1839.2, 28.29, 180.53),
    ped = "ig_isldj_01",
    onlyGangs = true
} 

Cfg.FirstUbications = { -- Ubicaciones de los peds que otorgarán el vehículo
    {
        coords = vector4(1493.88, 3760.44, 32.97, 216.92),
        model = "ig_isldj_01",
        vehSpawner = vector4(1496.4, 3757.08, 32.97, 216),
    },
    {
        coords = vector4(-277.4, 199.6, 84.69, 270.8),
        model = "ig_isldj_01",
        vehSpawner = vector4(-271.16, 199.52, 84.73, 269.04),
    },
    {
        coords = vector4(1732.56, -1534.76, 111.77, 252.08),
        model = "ig_isldj_01",
        vehSpawner = vector4(1739.28, -1537.52, 111.73, 265.08),
    },
    {
        coords = vector4(2136.24, 1936.44, 92.85, 96.8),
        model = "ig_isldj_01",
        vehSpawner = vector4(2120.12, 1943.4, 92.85, 14.56),
    },
    {
        coords = vector4(-519.5, -2876.87, 6.3, 7.3),
        model = "ig_isldj_01",
        vehSpawner = vector4(-527.24, -2872.57, 5.0, 42.48),
    },
}

Cfg.SecondUbications = { -- Ubicaciones posibles dónde puede entregar el jugador el vehículo (esto hará un random y seleccionará una de ellas aleatoriamente)
    {
        coords = vector3(1970.11, 5181.24, 46.9),
    },
    {
        coords = vector3(171.92, 6361.44, 30.49),
    },
    {
        coords = vector3(3804.2, 4466.12, 3.85),
    },
    {
        coords = vector3(765.55, -3187.59, 5.07),
    },
    {
        coords = vector3(-1350.84, -751.07, 22.3),
    },
}