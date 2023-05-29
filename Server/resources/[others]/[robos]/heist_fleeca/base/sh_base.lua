Config = {}

--Add gold, diamond item to database or change item names in bottom. (dont need add cash item)
Config['FleecaMain'] = {
    requiredPoliceCount = 4,--change
    requiredItems = {
        'bag' -- Add item to database
    },
    rewardItems = {
        diamondTrolly = { 
            item = 'diamond', --item code
            count = 1, -- reward count
            sellPrice = 12, -- for buyer sell price
            multiGrabCount = 15, -- middle main grab
        },
        goldTrolly = { 
            item = 'gold', 
            count = 1,
            multiGrabCount = 15, -- middle main grab
            sellPrice = 12,
        },
        cashTrolly = { 
            item = nil, -- cash
            count = 5000,
            multiGrabCount = 160000, -- middle main grab
        },
        lockbox = function()
            local items = {Config['FleecaMain']['rewardItems']['diamondTrolly'], Config['FleecaMain']['rewardItems']['goldTrolly']}
            local random = math.random(1, 2)
            local lockboxBag = { -- random diamond or gold for safety box drill reward
                item = items[random].item,
                count = 5
            }
            return lockboxBag
        end,
    },
    grabReward = function() -- dont change this
        return 'cash'
    end,
    trollyReward = function() -- dont change this
        return 'cash'
    end,
    finishHeist = {
        buyerPos = vector3(1291.19, -3143.2, 4.90626)
    }
}

Config['FleecaHeist'] = {
    [1] = {
        scenePed = { model = 'csb_tomcasino', coords = vector3(-2960.8, 483.305, 14.7), heading = 90.25}, -- ped settings
        scenePos = vector3(-2958.695, 478.2697, 14.7), -- start ped pos
        sceneRot = vector3(0.0, 0.0, -92.24812), -- start ped rotation
        scenePedWalkCoords = vector3(-2964.6, 482.968, 15.7068),
        doorHeading = {300.0, 300.0}, -- inside doors rotation
        grab = { -- middle main grab point
            pos = vector3(-2954.2, 484.377, 15.525),
            heading = 270.0,
            loot = false
        },
        trollys = { -- trollys points
            {coords = vector3(-2957.3, 485.690, 14.6753), heading = 178.0, loot = false},
            {coords = vector3(-2958.4, 484.099, 14.6753), heading = 268.0, loot = false},
        },
        nextRob = 1800, -- seconds
    },
    [2] = {
        scenePed = { model = 'csb_tomcasino', coords = vector3(-1211.4, -331.84, 36.78), heading = 27.56},
        scenePos = vector3(-1214.835, -336.3697, 36.78),
        sceneRot = vector3(0.0, 0.0, -152.9346),
        scenePedWalkCoords = vector3(-1213.6, -328.57, 37.7907),
        doorHeading = {240.0, 240.0},
        grab = {
            pos = vector3(-1207.6, -337.40, 37.6093),
            heading = 210.0,
            loot = false
        },
        trollys = {
            {coords = vector3(-1207.6, -333.89, 36.7592), heading = 118.0, loot = false},
            {coords = vector3(-1209.4, -333.79, 36.7592), heading = 208.0, loot = false},
        },
        nextRob = 1800,
    },
    [3] = {
        scenePed = { model = 'csb_tomcasino', coords = vector3(-351.34, -51.356, 48.05), heading = 340.04},
        scenePos = vector3(-356.5303, -52.26782, 48.05),
        sceneRot = vector3(0.0, 0.0, -198.9691),
        scenePedWalkCoords = vector3(-350.10, -47.569, 49.0462),
        doorHeading = {200.0, 200.0},
        grab = {
            pos = vector3(-352.23, -58.215, 48.848),
            heading = 160.0,
            loot = false
        },
        trollys = {
            {coords = vector3(-349.86, -55.756, 48.0148), heading = 70.0, loot = false},
            {coords = vector3(-351.02, -54.136, 48.0148), heading = 162.0, loot = false},
        },
        nextRob = 1800,
    },
    [4] = {
        scenePed = { model = 'csb_tomcasino', coords = vector3(313.973, -280.63, 53.16), heading = 340.04},
        scenePos = vector3(308.598, -281.3508, 53.16),
        sceneRot = vector3(0.0, 0.0, -200.1235),
        scenePedWalkCoords = vector3(315.079, -276.63, 54.1744),
        doorHeading = {200.0, 200.0},
        grab = {
            pos = vector3(312.756, -287.41, 54.0),
            heading = 160.0,
            loot = false
        },
        trollys = {
            {coords = vector3(315.230, -284.93, 53.1430), heading = 70.0, loot = false},
            {coords = vector3(314.184, -283.42, 53.1430), heading = 160.0, loot = false},
        },
        nextRob = 1800,
    },
    [5] = {
        scenePed = { model = 'csb_tomcasino', coords = vector3(1174.88, 2708.24, 37.09), heading = 175.0},
        scenePos = vector3(1179.56, 2710.876, 37.09),
        sceneRot = vector3(0.0, 0.0, 0.2100044),
        scenePedWalkCoords = vector3(1175.13, 2704.27, 38.0977),
        doorHeading = {40.0, 40.0},
        grab = {
            pos = vector3(1173.45, 2715.08, 37.9162),
            heading = 360.0,
            loot = false
        },
        trollys = {
            {coords = vector3(1172.02, 2712.01, 37.0662), heading = 270.0, loot = false},
            {coords = vector3(1173.69, 2710.93, 37.0662), heading = 0.0, loot = false},
        },
        nextRob = 1800,
    },
    [6] = {
        scenePed = { model = 'csb_tomcasino', coords = vector3(149.663, -1042.3, 28.37), heading = 345.0},
        scenePos = vector3(144.2593, -1042.969, 28.37),
        sceneRot = vector3(0.0, 0.0, -200.384),
        scenePedWalkCoords = vector3(150.710, -1038.4, 29.3777),
        doorHeading = {200.0, 200.0},
        grab = {
            pos = vector3(148.431, -1049.1, 29.19),
            heading = 160.0,
            loot = false
        },
        trollys = {
            {coords = vector3(151.036, -1046.6, 28.3462), heading = 70.0, loot = false},
            {coords = vector3(149.887, -1045.1, 28.3462), heading = 160.0, loot = false},
        },
        nextRob = 1800,
    }
}

Strings = {
    ['wait_nextheist'] = 'You have to wait this long to undress again',
    ['minute'] = 'minute.',
    ['need_item'] = 'You need this: ',
    ['police_alert'] = 'Fleeca bank robbery alert! Check your gps.',
    ['grab_trolly'] = 'Press ~INPUT_CONTEXT~ to grab trolly',
    ['grab'] = 'Press ~INPUT_CONTEXT~ to grab',
    ['deliver_to_buyer'] = 'Deliver the loot to the buyer. Check gps.',
    ['buyer_blip'] = 'Buyer',
    ['need_police'] = 'Not enough police in the city.',
    ['total_money'] = 'You got this: '
}

--Dont change cuzz those main and required things.
GrabCash = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'enter', 'enter_bag'},
        {'grab', 'grab_bag', 'grab_cash'},
        {'grab_idle', 'grab_idle_bag'},
        {'exit', 'exit_bag'},
    },
    ['scenes'] = {},
    ['scenesObjects'] = {}
}

Trolly = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'intro', 'bag_intro'},
        {'grab', 'bag_grab', 'cart_cash_dissapear'},
        {'exit', 'bag_exit'}
    },
    ['scenes'] = {}
}