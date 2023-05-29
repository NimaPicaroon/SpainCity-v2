PlantConfig = {

    GrowthObjects = {
        {hash = `bkr_prop_weed_01_small_01b`, zOffset = 0.0},
        {hash = `bkr_prop_weed_med_01a`, zOffset = -2.5},
        {hash = `bkr_prop_weed_med_01b`, zOffset = -2.5},
        {hash = `bkr_prop_weed_lrg_01a`, zOffset = -2.48},
        {hash = `bkr_prop_weed_lrg_01b`, zOffset = -2.48},
    },
    GrowthTime = 55,
    MaleFactor = 0.9,
    SeedsFromMale = {20, 30},
    DopeFromFemale = {20, 30},
    HarvestPercent = 85,
    TimeBetweenHarvest = 0,
    WaterAdd = {16, 25},
    FertilizerItem = 'fertilizer',
    WaterItem = 'water',
    MaleSeedItem = 'maleseed',
    FemaleSeedItem = 'femaleseed',
    GiveDopeItem = 'weed',
    FertilizerFactor = 0.9,
    PWeight = 35,
}


WeedZones = {
--     {vector3(99.61, -1976.88, 20.9), 35.36},              -- Ballas 
--     {vector3(-127.04, -1548.69, 33.82), 30.36},           -- Families 
--     {vector3(1282.48, -1755.25, 54.54), 30.36},           -- hoover
--     {vector3(-485.59, 184.94, 83.7), 35.36},              -- San fierros
--     {vector3(394.8, -1847.05, 4269.42), 35.36},           -- Purple Ice
--     {vector3(481.54, -1523.2, 29.3), 30.36},              -- Bloods
--     {vector3(362.45, -2013.08, 24.49), 45.36},            -- Black snow
--     {vector3(-74.0, -348.94, 42.59), 45.36},              -- CREAM BOYZ
--     {vector3(-67.16, -1521.17, 35.9), 35.36},             -- west side crips 
--     {vector3(-168.28, 46.54, 68.48), 35.36},              -- magrebis
--     {vector3(-1346.28, -917.54, 11.48), 35.36},           -- gypsy
--     {vector3(-1192.49, -230.54, 37.48), 35.36},           -- blue sky boyz       
--     {vector3(-1545.2, -267.29, 46.4), 45.36},             -- TRINITARIOS 

-- ----------------------------------------------------------------------------
     --{vector3(3279.22, 5199.35, 18.64), 35.36},            -- Vento notturno
     --{vector3(2338.56, 2550.25, 47.53), 35.36},            -- ratas blaine    
     {vector3(2098.57, 4833.58, 41.22), 45.36},            -- FOUNDERS GROUND
--     {vector3(85.57, 3758.58, 39.22), 45.36},              -- LOST
--     {vector3(1291.57, 4332.58, 39.22), 45.36},            -- black dragons
--     {vector3(2628.57, 3314.58, 55.22), 45.36},            -- uptown riders
    

    
    
    {vector3(1855.91, 4993.05, 55.28), 235.36},            -- civiles grapeseed 
}

notify = function(msg)
    ESX.ShowNotification(msg)
end