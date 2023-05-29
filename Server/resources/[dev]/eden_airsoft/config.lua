Framework = Framework or {} -- Don't touch this

Config = Config or {}

Config.Language = 'es'

Config.Price = 100 -- Price of 1 match (only the host pays)

--- Put this to true if you don't want "zones" (Press E to open the menu). If you disable this then you will need to call exports['eden_airsoft']:openMenu() to open the menu
Config.DisableZones = false

--- If DisableZones is false you need to stablish the coords were players are teleported when match finish
Config.DefaultExitCoords = vec4(-222.71, -1962.24, 27.76, 0.0)

Config.Blip = {
    sprite = 437,
    scale = 0.75,
    color = 36,
}

Config.Zones = {
    {
        name = 'Airsoft',
        coords = vec4(-222.71, -1962.24, 27.76, 10.0), -- 4th argument is radius
    }
}

-- List of blacklisted lobby names (lobby's can't contain this strings)
Config.BlacklistedLobbyNames = {
    'nigga', 'nigger', 'faggot', 'gay'
}

-- Name of the weapon with image extension. Name need to be original weapon name. Example: if you want WEAPON_PISTOL and image is jpg then: 'pistol.jpg'
Config.WeaponsData = {
    { image = 'advancedrifle.png',      label = 'Rifle avanzado' },
    { image = 'appistol.png',           label = 'Pistola AP' },
    { image = 'assaultrifle.png',       label = 'AK-47' },
    { image = 'assaultrifle_mk2.png',   label = 'Assault Rifle MK2' },
    { image = 'assaultshotgun.png',     label = 'Assault Shotgun' },
    { image = 'assaultsmg.png',         label = 'P90' },
    { image = 'autoshotgun.png',        label = 'Auto Shotgun' },
    { image = 'bullpuprifle.png',       label = ' Rifle Bullpup' },
    { image = 'bullpuprifle_mk2.png',   label = 'Bullup Rifle MK2' },
    { image = 'bullpupshotgun.png',     label = 'Bullup Shotgun' },
    { image = 'carbinerifle.png',       label = 'M4' },
    { image = 'carbinerifle_mk2.png',   label = 'Carbine Rifle MK2' },
    { image = 'combatmg.png',           label = 'Combat MG' },
    { image = 'combatmg_mk2.png',       label = 'Combat MG MK2' },
    { image = 'combatpdw.png',          label = 'Combat PDW' },
    { image = 'combatpistol.png',       label = 'Pistola Glock' },
    { image = 'compactrifle.png',       label = 'Mini AK-47' },
    { image = 'dbshotgun.png',          label = 'DB Shotgun' },
    { image = 'doubleaction.png',       label = 'Double Action' },
    { image = 'gusenberg.png',          label = 'Gusenberg' },
    { image = 'heavypistol.png',        label = 'Deagle' },
    { image = 'heavyshotgun.png',       label = 'Heavy Shotgun' },
    { image = 'heavysniper.png',        label = 'Heavy Sniper' },
    { image = 'heavysniper_mk2.png',    label = 'Heavy Sniper MK2' },
    { image = 'machinepistol.png',      label = 'Tec-09' },
    { image = 'marksmanpistol.png',     label = 'Marksman Pistol' },
    { image = 'marksmanrifle.png',      label = 'Fusil tirador' },
    { image = 'marksmanrifle_mk2.png',  label = 'Marksman Rifle MK2' },
    { image = 'mg.png',                 label = 'MG' },
    { image = 'microsmg.png',           label = 'UZI' },
    { image = 'minigun.png',            label = 'Minigun' },
    { image = 'minismg.png',            label = 'Skorpion' },
    { image = 'musket.png',             label = 'Musket' },
    { image = 'pistol.png',             label = 'Pistola' },
    { image = 'pistol50.png',           label = 'Pistol .50' },
    { image = 'pistol_mk2.png',         label = 'Pistol MK2' },
    { image = 'pumpshotgun.png',        label = 'Escopeta corredera' },
    { image = 'pumpshotgun_mk2.png',    label = 'Pump Shotgun MK2' },
    { image = 'revolver.png',           label = 'Revolver' },
    { image = 'revolver_mk2.png',       label = 'Revolver MK2' },
    { image = 'sawnoffshotgun.png',     label = 'Escopeta recortada' },
    { image = 'smg.png',                label = 'SMG' },
    { image = 'smg_mk2.png',            label = 'SMG MK2' },
    { image = 'snspistol.png',          label = 'Pistola cutre' },
    { image = 'snspistol_mk2.png',      label = 'SNS Pistol MK2' },
    { image = 'specialcarbine.png',     label = 'Special Carbine' },
    { image = 'specialcarbine_mk2.png', label = 'Special Carbine MK2' },
    { image = 'vintagepistol.png',      label = 'Pistola Vintage' },
}

Config.MapData = {
    -- ["bank"] = {
    --     ['label'] = 'Banco',
    --     ['img'] = 'bank.jpg',
    --     ["team1"] = { x = 244.43, y = 202.98, z = 105.21, h = 73.86 },
    --     ["team2"] = { x = 254.34, y = 225.39, z = 106.29, h = 163.04 },
    --     ["eteam1"] = { x = 222.06, y = 210.99, z = 105.55, h = 158.26 },
    --     ["eteam2"] = { x = 220.76, y = 206.79, z = 105.47, h = 340.43 },
    --     ["area"] = {
    --         ["Pos"] = { x = 249.33, y = 217.76, z = 100.29 },
    --         ["Size"] = { x = 80.0, y = 80.0, z = 10.0 },
    --     },
    -- },
    ["lifeinvader"] = {
        ['label'] = 'Life Invader (2v2)',
        ['img'] = 'lifeinvader.jpg',
        ["team1"] = { x = -1085.06, y = -256.12, z = 37.76, h = 301.06 },
        ["team2"] = { x = -1057.03, y = -239.54, z = 44.02, h = 115.0 },
        ["eteam1"] = { x = -1088.07, y = -257.55, z = 37.76, h = 301.6 },
        ["eteam2"] = { x = -1077.77, y = -247.37, z = 37.76, h = 112.74 },
        ["area"] =
        {
            ["Pos"] = { x = -1075.87, y = -243.6, z = 30.02 },
            ["Size"] = { x = 90.0, y = 90.0, z = 20.0 },
        },
    },
    ["skyscraper"] = {
        ['label'] = 'Sky Scraper (2v2)',
        ['img'] = 'skyscraper.jpg',
        ["team1"] = { x = -168.86, y = -1011.97, z = 254.13, h = 341.67 },
        ["team2"] = { x = -139.52, y = -952.93, z = 254.13, h = 159.49 },
        ["eteam1"] = { x = -161.05, y = -995.09, z = 254.13, h = 340.75 },
        ["eteam2"] = { x = -158.08, y = -988.08, z = 254.13, h = 157.8 },
        ["area"] =
        {
            ["Pos"] = { x = -150.83, y = -976.69, z = 244.02 },
            ["Size"] = { x = 80.0, y = 80.0, z = 20.0 },
        },
    },
    ["1v1"] = {
        ['label'] = '1v1',
        ['img'] = '1v1.jpg',
        ["team1"] = { x = -2100.9, y = 3095.54, z = 32.81, h = 332.33 },
        ["team2"] = { x = -2074.5, y = 3141.4, z = 32.81, h = 148.7 },
        ["eteam1"] = { x = -2100.78, y = 3095.96, z = 33.81, h = 327.91 },
        ["eteam2"] = { x = -2096.8, y = 3102.9, z = 33.81, h = 158.88 },
        ["area"] =
        {
            ["Pos"] = { x = -2087.34, y = 3118.99, z = 15.71 },
            ["Size"] = { x = 70.0, y = 70.0, z = 60.0 },
        },
    },
    ["portarena"] = {
        ['label'] = 'Port Arena (1v1)',
        ['img'] = 'portarena.jpg',
        ["team1"] = { x = 463.3278503418, y = -3068.751953125, z = 6.0696263313293, h = 185.27 },
        ["team2"] = { x = 449.35104370117, y = -3114.3232421875, z = 6.0700526237488, h = 358.8 },
        ["eteam1"] = { x = 466.45849609375, y = -3068.9328613281, z = 6.0696263313293, h = 185.27 },
        ["eteam2"] = { x = 451.30075073242, y = -3112.142578125, z = 6.0700526237488, h = 4.6717534065247 },
        ["area"] =
        {
            ["Pos"] = { x = 459.61117553711, y = -3093.8540039062, z = 7.3898181915283 },
            ["Size"] = { x = 70.0, y = 70.0, z = 60.0 },
        },
    },
         ["plaiceplace"] = {
         ['label'] = 'Plaice Place (3v3)',
         ['img'] = 'plaiceplace.png',
         ["team1"] = { x = -391.86, y = -2692.83, z = 6.02, h = 312.67 },
         ["team2"] = { x = -291.53, y = -2594.75, z = 6.0, h = 134.49 },
         ["eteam1"] = { x = -378.41, y = -2679.87, z = 6.0, h = 312.75 },
         ["eteam2"] = { x = -304.26, y = -2605.8, z = 6.0, h = 134.8 },
         ["area"] =
        {
             ["Pos"] = { x = -345.02, y = -2646.72, z = 1.3898181915283 },
             ["Size"] = { x = 160.0, y = 160.0, z = 50.0 },
         },
     },
     ["tejado"] = {
         ['label'] = 'Roof (2v2)',
         ['img'] = 'tejado.png',
         ["team1"] = { x = 117.3, y = -877.25, z = 134.77, h = 71.67 },
         ["team2"] = { x = 83.91, y = -865.35, z = 134.77, h = 247.8 },
         ["eteam1"] = { x = 115.48, y = -876.63, z = 134.77, h = 71.75 },
         ["eteam2"] = { x = 87.68, y = -866.46, z = 134.77, h = 247.8 },
         ["area"] =
         {
             ["Pos"] = { x = 101.72, y = -871.92, z = 130.3898181915283 },
             ["Size"] = { x = 60.0, y = 60.0, z = 10.0 },
         },
     },
    --   ["mazebankarena"] = {
    --       ['label'] = 'Maze Bank Arena (3v3)',
    --       ['img'] = 'mazebankarena.png',
    --       ["team1"] = { x = -307.84, y = -1982.12, z = 21.64, h = 49.67 },
    --       ["team2"] = { x = -340.82, y = -1954.82, z = 21.64, h = 232.49 },
    --       ["eteam1"] = { x = -314.5, y = -1976.51, z = 21.64, h = 60.29 },
    --       ["eteam2"] = { x = -334.12, y = -1960.32, z = 21.64, h = 232.8 },
    --       ["area"] =
    --       {
    --           ["Pos"] = { x = -324.73, y = -1968.79, z = 18.383 },
    --           ["Size"] = { x = 70.0, y = 70.0, z = 15.0 },
    --       },
    --   },
      ["yate"] = {
         ['label'] = 'Yate (3v3)',
         ['img'] = 'yate.png',
         ["team1"] = { x = -2018.79, y = -1039.67, z = 2.45, h = 73.67 },
         ["team2"] = { x = -2120.38, y = -1006.55, z = 7.97, h = 239.75 },
         ["eteam1"] = { x = -2023.93, y = -1037.94, z = 5.58, h = 69.8 },
         ["eteam2"] = { x = -2111.15, y = -1009.64, z = 8.97, h = 260.8 },
         ["area"] =
         {
             ["Pos"] = { x = -2072.54, y = -1022.1, z = 0.383 },
             ["Size"] = { x = 120.0, y = 120.0, z = 20.0 },
         },
     }, 
     ["fuenteblanca"] = {
        ['label'] = 'Fuente Blanca (2v2)',
        ['img'] = 'fuenteblanca.png',
        ["team1"] = { x = 1457.75, y = 1126.41, z = 114.33, h = 9.67 },
        ["team2"] = { x = 1459.48, y = 1182.24, z = 114.08, h = 178.75 },
        ["eteam1"] = { x = 1457.98, y = 1131.19, z = 114.33, h = 69.8 },
        ["eteam2"] = { x = 1459.27, y = 1175.95, z = 114.08, h = 178.8 },
        ["area"] =
        {
            ["Pos"] = { x = 1456.77, y = 1151.14, z = 110.383 },
            ["Size"] = { x = 80.0, y = 80.0, z = 14.0 },
        },
    }, 
    ["castillo"] = {
        ['label'] = 'Castillo RGB (2v2)',
        ['img'] = 'castillo.png',
        ["team1"] = { x = -3740.09, y = -3023.11, z = 542.92, h = 1.67 },
        ["team2"] = { x = -3740.52, y = -2983.17, z = 542.92, h = 180.67 },
        ["eteam1"] = { x = -3740.09, y = -3024.11, z = 542.92, h = 1.67 },
        ["eteam2"] = { x = -3740.52, y = -2982.17, z = 542.92, h = 180.67 },
        ["area"] =
        {
            ["Pos"] = { x = -3740.28, y = -3002.14, z = 530.383 },
            ["Size"] = { x = 80.0, y = 80.0, z = 14.0 },
        },
    }, 
    ["arena2v2"] = {
        ['label'] = 'Arena (3v3)',
        ['img'] = 'arena2v2.png',
        ["team1"] = { x = -4031.89, y = 3969.08, z = 762.27, h = 90.67 },
        ["team2"] = { x = -4089.51, y = 3968.11, z = 762.27, h = 270.67 },
        ["eteam1"] = { x = -4031.89, y = 3969.08, z = 762.27, h = 90.67 },
        ["eteam2"] = { x = -4089.51, y = 3968.11, z = 762.27, h = 270.67 },
        ["area"] =
        {
            ["Pos"] = { x = -4061.79, y = 3968.93, z = 759.00 },
            ["Size"] = { x = 180.0, y = 180.0, z = 14.0 },
        },
    }, 
}
