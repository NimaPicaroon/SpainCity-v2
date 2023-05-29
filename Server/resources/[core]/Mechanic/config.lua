Config = Config or {}

Config.Debug = true -- Set to True to enable Debug Prints
Config.MoneyType = 'bank'
Config.RepairMoneyType = 'money'
Config.DefaultRepairPrice = 500 -- Repair price that is used if a vehicle-specific price is not available
Config.BaseRepairPrice = 0 -- Starting repair price. Every player's vehicle damage (0-1000) is added to it later. If the final price is 0 or less, the repair menu does not appear
Config.RepairPriceMultiplier = 1.0 -- Every player's vehicle damage (0-1000) is multiplier by this number, and then added to the base repair price
Config.UseRadial = false -- Will use qb-radial menu for entering instead of press E
Config.allowGovPlateIndex = false -- Setting this to true will allow all vehicles to purchase gov plate index "Blue on White #3" (only for emergency vehicles otherwise)

Config.DisableWhenMechanicsOnline = false -- Disables customs completely if enough mechanics are online and on-duty
Config.MinOnlineMechanics = 1 -- The amount of mechanics that have to be online and on-duty to disable customs (mechanics can still use them)
Config.DisabledCategoriesMechanics = {
    repair = false,
    mods = false,
    armor = false,
    respray = false,
    liveries = false,
    wheels = false,
    tint = false,
    plate = false,
    extras = false,
    neons = false,
    xenons = false,
    horn = false,
    turbo = false,
    cosmetics = false,
} -- `true` to disable category if enough mechanics are online and on-duty, `false` to ignore

Config.PayWithSocietyWhenJobRestricted = true -- Whether to have job societies pay for employees if the location is restricted to the job
Config.PaidBySociety = {
    -- 'mechanic',
} -- List of job societies that pay for employees, regardless of the customs location

maxVehiclePerformanceUpgrades = 0 -- | All Upgrades: 0 | No Upgrades: -1 | Can be -1 to 4

-- ADJUST PRICING
vehicleCustomisationPrices = {
    cosmetics = {price = 400},
    respray = {price = 1000},
    performance = {prices = {0, 3250, 5500, 10450, 15250, 20500, 25000}},
    turbo = {prices = {0, 15000}},
    wheels = {price = 400},
    customwheels = {price = 600},
    wheelsmoke = {price = 400},
    windowtint = {price = 400},
    neonside = {price = 100},
    neoncolours = {price = 500},
    headlights = {price = 100},
    xenoncolours = {price = 500},
    oldlivery = {price = 500},
    plateindex = {price = 1000}
}

-- WINDOW TINTS

vehicleWindowTintOptions = {
    {name = "None", id = 0},
    {name = "Pure Black", id = 1},
    {name = "Darksmoke", id = 2},
    {name = "Lightsmoke", id = 3}
}

-- HEADLIGHTS

vehicleXenonOptions = {
    xenonColours = {
        {name = "Stock", id = 255},
        {name = "White", id = 0}, {name = "Blue", id = 1},
        {name = "Electric Blue", id = 2},
        {name = "Mint Green", id = 3},
        {name = "Lime Green", id = 4},
        {name = "Yellow", id = 5},
        {name = "Golden Shower", id = 6},
        {name = "Orange", id = 7},
        {name = "Red", id = 8},
        {name = "Pony Pink", id = 9},
        {name = "Hot Pink", id = 10},
        {name = "Purple", id = 11},
        {name = "Blacklight", id = 12}
    }
}

-- WHEELS

vehicleWheelOptions = {
    {category = "Neumaticos personalizados", id = -1, wheelID = 23},
    {category = "Deportivo", id = 0, wheelID = 23},
    {category = "Muscle", id = 1, wheelID = 23},
    {category = "Lowrider", id = 2, wheelID = 23},
    {category = "SUV", id = 3, wheelID = 23},
    {category = "Todoterreno", id = 4, wheelID = 23},
    {category = "Tuner", id = 5, wheelID = 23},
    {category = "Motocicleta", id = 6, wheelID = 23},
    {category = "Lujo", id = 7, wheelID = 23},
    {category = "BennysWheel", id = 8, wheelID = 23},
    {category = "BespokeWheel", id = 9, wheelID = 23},
    {category = "Dragster", id = 10, wheelID = 23},
    {category = "Calle", id = 11, wheelID = 23},
    {category = "Rally", id = 12, wheelID = 23},
}

-- TIRE SMOKE

vehicleTyreSmokeOptions = {
    { name = "Humo blanco", r = 254, g = 254, b = 254},
    { name = "Humo negro", r = 1, g = 1, b = 1},
    { name = "Humo azul", r = 0, g = 150, b = 255},
    { name = "Humo amarillo", r = 255, g = 255, b = 50},
    { name = "Humo naranja", r = 255, g = 153, b = 51},
    { name = "Humo rojo", r = 255, g = 10, b = 10},
    { name = "Humo verde", r = 10, g = 255, b = 10},
    { name = "Humo purpura", r = 153, g = 10, b = 153},
    { name = "Humo rosa", r = 255, g = 102, b = 178},
    { name = "Humo gris", r = 128, g = 128, b = 128}
}

-- NEONS

vehicleNeonOptions = {
    category = "Neons",
    neonTypes = {
        {name = "Front Neon", id = 2},
        {name = "Rear Neon", id = 3},
        {name = "Left Neon", id = 0},
        {name = "Right Neon", id = 1}
    },
    neonColours = {
        { name = "White", r = 222, g = 222, b = 255},
        { name = "Blue", r = 2, g = 21, b = 255},
        { name = "Electric Blue", r = 3, g = 83, b = 255},
        { name = "Mint Green", r = 0, g = 255, b = 140},
        { name = "Lime Green", r = 94, g = 255, b = 1},
        { name = "Yellow", r = 255, g = 255, b = 0},
        { name = "Golden Shower", r = 255, g = 150, b = 0},
        { name = "Orange", r = 255, g = 62, b = 0},
        { name = "Red", r = 255, g = 1, b = 1},
        { name = "Pony Pink", r = 255, g = 50, b = 100},
        { name = "Hot Pink", r = 255, g = 5, b = 190},
        { name = "Purple", r = 35, g = 1, b = 255},
        { name = "Blacklight", r = 15, g = 3, b = 255}
    }
}

-- MAIN COMPONENTS

vehicleCustomisation = {
    {category = "Spoiler", id = 0},
    {category = "Parachoques delantero", id = 1},
    {category = "Parachoques trasero", id = 2},
    {category = "Faldones laterales", id = 3},
    {category = "Escape", id = 4},
    {category = "Arco de seguridad", id = 5},
    {category = "Rejilla", id = 6},
    {category = "Capo", id = 7},
    {category = "Paragolpes izquierdo", id = 8},
    {category = "Paragolpes derecho", id = 9},
    {category = "Techo", id = 10},
    {category = "Mejora del motor", id = 11},
    {category = "Mejora de los frenos", id = 12},
    {category = "Mejora de la transmision", id = 13},
    {category = "Mejora de la suspension", id = 15},
    {category = "Mejora de la armadura", id = 16},
    {category = "Mejora del turbo", id = 18},
    {category = "Placas de matricula", id = 25},
    {category = "Recorte A", id = 27},
    {category = "Adornos", id = 28},
    {category = "Salpicadero", id = 29},
    {category = "Cuadro de instrumentos", id = 30},
    {category = "Altavoces de puerta", id = 31},
    {category = "Asientos", id = 32},
    {category = "Volante", id = 33},
    {category = "Palanca de cambios", id = 34},
    {category = "Placa", id = 35},
    {category = "Altavoz", id = 36},
    {category = "Maletero", id = 37},
    {category = "Hidraulico", id = 38},
    {category = "Bloque de motor", id = 39},
    {category = "Filtro de aire", id = 40},
    {category = "Estabilizador", id = 41},
    {category = "Cubrearco", id = 42},
    {category = "Antena", id = 43},
    {category = "Recorte B", id = 44},
    {category = "Deposito de combustible", id = 45},
    {category = "Ventana", id = 46},
    {category = "Calcas", id = 48},
    {category = "Bocinas", id = 14,
        hornNames = {
            {name = "Claxon de camion", id = 0},
            {name = "Claxon de policia", id = 1},
            {name = "Claxon de payaso", id = 2},
            {name = "Claxon musical 1", id = 3},
            {name = "Claxon musical 2", id = 4},
            {name = "Claxon musical 3", id = 5},
            {name = "Claxon musical 4", id = 6},
            {name = "Claxon musical 5", id = 7},
            {name = "Trombon triste", id = 8},
            {name = "Claxon clasico 1", id = 9},
            {name = "Claxon clasico 2", id = 10},
            {name = "Claxon clasico 3", id = 11},
            {name = "Claxon clasico 4", id = 12},
            {name = "Claxon clasico 5", id = 13},
            {name = "Claxon clasico 6", id = 14},
            {name = "Claxon clasico 7", id = 15},
            {name = "Escala - Do", id = 16},
            {name = "Escala - Re", id = 17},
            {name = "Escala - Mi", id = 18},
            {name = "Escala - Fa", id = 19},
            {name = "Escala - Sol", id = 20},
            {name = "Escala - La", id = 21},
            {name = "Escala - Si", id = 22},
            {name = "Escala - Do", id = 23},
            {name = "Claxon Jazz 1", id = 24},
            {name = "Claxon Jazz 2", id = 25},
            {name = "Claxon Jazz 3", id = 26},
            {name = "Bucle de claxon Jazz", id = 27},
            {name = "Star Spangled Banner 1", id = 28},
            {name = "Star Spangled Banner 2", id = 29},
            {name = "Star Spangled Banner 3", id = 30},
            {name = "Star Spangled Banner 4", id = 31},
            {name = "Bucle de claxon clasico 8", id = 32},
            {name = "Bucle de claxon clasico 9", id = 33},
            {name = "Bucle de claxon clasico 10", id = 34},
            {name = "Claxon clasico 8", id = 35},
            {name = "Claxon clasico 9", id = 36},
            {name = "Claxon clasico 10", id = 37},
            {name = "Bucle de funeral", id = 38},
            {name = "Funeral", id = 39},
            {name = "Bucle de espeluznante", id = 40},
            {name = "Espeluznante", id = 41},
            {name = "Bucle de San Andreas", id = 42},
            {name = "San Andreas", id = 43},
            {name = "Bucle de Liberty City", id = 44},
            {name = "Liberty City", id = 45},
            {name = "Bucle festivo 1", id = 46},
            {name = "Festivo 1", id = 47},
            {name = "Bucle festivo 2", id = 48},
            {name = "Festivo 2", id = 49},
            {name = "Bucle festivo 3", id = 50},
            {name = "Festivo 3", id = 51}
        }
    }
}

-- COLORS

vehicleResprayOptions = {
    {category = "Standard", id = 0,
        colours = {
            {name = "Negro", id = 0},
            {name = "Carbon Negro", id = 147},
            {name = "Grafito", id = 1},
            {name = "Anhracite Negro", id = 11},
            {name = "Negro Acero", id = 2},
            {name = "Acero Oscuro", id = 3},
            {name = "Plata", id = 4},
            {name = "Plata Azulado", id = 5},
            {name = "Laminado Acero", id = 6},
            {name = "Shadow Plata", id = 7},
            {name = "Piedra Plata", id = 8},
            {name = "Medianoche Plata", id = 9},
            {name = "Fundido Plata", id = 10},
            {name = "Rojo", id = 27},
            {name = "Torino Rojo", id = 28},
            {name = "Formula Rojo", id = 29},
            {name = "Lava Rojo", id = 150},
            {name = "Blaze Rojo", id = 30},
            {name = "Gracia Rojo", id = 31},
            {name = "Granate Rojo", id = 32},
            {name = "Atardecer Rojo", id = 33},
            {name = "Cabernet Rojo", id = 34},
            {name = "Vino Rojo", id = 143},
            {name = "Candy Rojo", id = 35},
            {name = "Rosa Caliente", id = 135},
            {name = "Pfsiter Rosa", id = 137},
            {name = "Salmon Rosa", id = 136},
            {name = "Amanecer Naranja", id = 36},
            {name = "Naranja", id = 38},
            {name = "Naranja Brillante", id = 138},
            {name = "Oro", id = 99},
            {name = "Bronce", id = 90},
            {name = "Amarillo", id = 88},
            {name = "Amarillo Carrera", id = 89},
            {name = "Amarillo Rojizo", id = 91},
            {name = "Verde Oscuro", id = 49},
            {name = "Verde Carrera", id = 50},
            {name = "Verde Mar", id = 51},
            {name = "Verde Oliva", id = 52},
            {name = "Verde Brillante", id = 53},
            {name = "Verde Gasolina", id = 54},
            {name = "Verde Lima", id = 92},
            {name = "Azul Medianoche", id = 141},
            {name = "Azul Galaxia", id = 61},
            {name = "Azul Oscuro", id = 62},
            {name = "Azul Saxon", id = 63},
            {name = "Azul", id = 64},
            {name = "Azul Marino", id = 65},
            {name = "Azul Puerto", id = 66},
            {name = "Azul Diamante", id = 67},
            {name = "Azul Surf", id = 68},
            {name = "Azul Nautico", id = 69},
            {name = "Azul Carrera", id = 73},
            {name = "Azul Ultra", id = 70},
            {name = "Azul Claro", id = 74},
            {name = "Chocolate Marron", id = 96},
            {name = "Bison Marron", id = 101},
            {name = "Creeen Marron", id = 95},
            {name = "Feltzer Marron", id = 94},
            {name = "Arce Marron", id = 97},
            {name = "Arce Marron", id = 103},
            {name = "Marron Sienna", id = 104},
            {name = "Silla de Montar Marron", id = 98},
            {name = "Marron Musgo", id = 100},
            {name = "Arce Dulce Marron", id = 102},
            {name = "Marron Paja", id = 99},
            {name = "Marron Arenoso", id = 105},
            {name = "Marron Lavado", id = 106},
            {name = "Schafter Purpura", id = 71},
            {name = "Spinnaker Purpura", id = 72},
            {name = "Medianoche Purpura", id = 142},
            {name = "Purpura Brillante", id = 145},
            {name = "Crema", id = 107},
            {name = "Blanco Hielo", id = 111},
            {name = "Blanco Escarchado", id = 112}
        }
    },
    {category = "Matte", id = 1,
        colours = {{name = "Black", id = 12},
            {name = "Gris", id = 13},
            {name = "Gris Claro", id = 14},
            {name = "Blanco Hielo", id = 131},
            {name = "Azul", id = 83},
            {name = "Azul Oscuro", id = 82},
            {name = "Azul Medianoche", id = 84},
            {name = "Morado Medianoche", id = 149},
            {name = "Morado Schafter", id = 148},
            {name = "Rojo", id = 39},
            {name = "Rojo Oscuro", id = 40},
            {name = "Naranja", id = 41},
            {name = "Amarillo", id = 42},
            {name = "Verde Lima", id = 55},
            {name = "Verde", id = 128},
            {name = "Verde Bosque", id = 151},
            {name = "Verde Follaje", id = 155},
            {name = "Oliva Oscuro", id = 152},
            {name = "Tierra Oscura", id = 153},
            {name = "Desierto Arena", id = 154}
        }
    },
    {category = "Metals", id = 2,
            colours = {{name = "Brushed Steel", id = 117},
            {name = "Brushed Black Steel", id = 118},
            {name = "Brushed Aluminium", id = 119},
            {name = "Pure Gold", id = 158},
            {name = "Brushed Gold", id = 159},
            {name = "Chrome", id = 120}
        }
    }
}
