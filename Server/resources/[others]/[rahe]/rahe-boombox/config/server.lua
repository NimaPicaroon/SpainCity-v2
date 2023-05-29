svConfig = {
    -- Default volume when input is not present. If user sets the input one time, the last input will be used instead ot this
    defaultVolume = 0.3,
    -- Default range when input is not present. If user sets the input one time, the last input will be used instead ot this
    defaultRange = 15.0,

    -- Logging options
    -- Discord webhook where all of the logs will be sent
    webhook = 'https://discordapp.com/api/webhooks/',
    -- Log when boombox is created (item used)
    logCreations = true,
    -- Log when boombox is picked up
    logPickups = true,
    -- Log when boombox is placed back on ground after holding it
    logDrops = true,
    -- Log when boombox song is changed
    logSongChanges = true,
    -- Log when boombox volume is changed
    logVolumeChanges = true,
    -- Log when boombox volume is stored
    logStoring = true,
    -- Log when boombox is destroyed after vehicle has been despawned (drowned, exploded etc)
    logVehicleDespawn = true,
    -- Log when a song is added to a queue
    logSongQueues = true,

    -- Define whether your script will be item based or command based
    -- If this is set to true, players are not allowed to use /music command and they have to create boomboxes by using items on inventory
    inventoryBased = true,

    -- This api key is used to fetch song names after playing/queueing.
    -- This is OPTIONAL. You should know that if you decide not to use it, the song URL will displayed instead of the name.
    -- We highly recommend setting this up since it makes everything much nicer for the user and it only takes a few minutes.

    -- The api key you want has to have service 'Youtube Data API v3' enabled.
    -- You can find a tutorial how to create this yourself or follow step-by-step tutorial provided by us.

    -- Step-by-step tutorial:
    --  1) Register/login to Google Console Cloud at https://console.cloud.google.com/
    --  2) If your account is already setup at GCC, you can skip these steps and go to step 7
    --  3) Select your country, agree to terms of service
    --  4) From the left sidebar - hover 'APIs % Services', select 'Credentials'
    --  5) Click 'Create Project', fill out the data, click 'Create'
    --  6) Wait until the project is set up then click 'Create Credentials'
    --  7) Select 'API key'.
    --  8) Copy the key presented and insert it into this config file, after youtubeApiKey
    --  9) From the left sidebar, Click 'Enabled APIs and Services'
    --  10) On top of the page, click 'Enable APIs and Services'
    --  11) Search for 'youtube data api v3', click on the result
    --  12) Click enable
    --  13) All done! The script will now use youtube API to fetch music related data!
    youtubeApiKey = 'AIzaSyCv1V6OMhBhGCcHVvw2R5-8Wik9mqi82t0',
}

-- Steam hex IDs that have access to the admin panel and can interact with any boombox
svConfig.adminSteamHexIds = {
    'steam:1100001067dd4b1',
}

-- Steam hex IDs that are allowed to mark music entities as permanent
svConfig.permanentIdentifiers = {
    'steam:1100001067dd4b1',
}

-- Here you can define vehicle classes that you CAN'T attach music entity to
svConfig.excludedVehicleClasses = {
    8, -- Motorcycles
    13, -- Cycles
    14, -- Boats
    15, -- Helicopters
    16, -- Planes
    19, -- Military
    20, -- Commercial
    21, -- Trains
}

-- Here you can define new entity types
-- Important information about permissions:
-- 1) If you allow the entity to be picked up
--    you must also define attach coordinates, rotation and bone where the entity will be attached (boombox example)
-- 2) If you allow the entity to be attached to a vehicle
--    you must also allow pickup since entities can be only attached to vehicle when they are picked up
-- 3) If you want the player to play an animation when carrying the entity
--    you must also define animation data (club speaker example)
-- 4) The allowPermanent permissions also requires Steam hex ID in previously
--    defined allowedPermanentSteamHexIds to be present
-- 5) Existing permissions are:
--    allowPickup - allows the entity to be picked up
--    allowSongChanges - allows song changes (this should be always set to true)
--    allowVolumeChanges - allows volume/range changes
--    allowPlayPauses - allows music play/pause
--    allowQueue - allows music queueing
--    allowVehicleAttach - allows entity to be attached to a vehicle
--    allowStorage - allows entity to be stored (recommended when music entities are used as items)
--    allowSettings - allows entity settings menu to be opened (queue management, marking entity as permanent, marking entity as public)

svConfig.speakerTypes = {
    [1] = { -- Boombox
        title = 'Boombox',
        itemId = 'musicbox', -- This only necessary when inventoryBased is set to true (this item is added and removed)
        description = 'Oldschool boombox!',
        maxRange = 30.0,
        model = `prop_boombox_01`,
        permissions = {
            allowPickup = true,
            allowSongChanges = true,
            allowVolumeChanges = true,
            allowPlayPauses = true,
            allowQueue = true,
            allowVehicleAttach = true,
            allowStorage = true,
            allowSettings = true,
        },
        attachData = {
            bone = 28422,
            xCoord = 0.2,
            yCoord = 0.0,
            zCoord = 0.0,
            xRotation = -35.0,
            yRotation = -100.0,
            zRotation = 0.0,

        },
    },
    [2] = { -- Large club speaker
        title = 'Large speaker',
        itemId = 'speakerbox', -- This only necessary when inventoryBased is set to true (this item is added and removed)
        description = 'Large club speaker!',
        maxRange = 80.0,
        model = `h4_prop_battle_club_speaker_med`,
        permissions = {
            allowPickup = true,
            allowSongChanges = true,
            allowVolumeChanges = true,
            allowPlayPauses = true,
            allowQueue = true,
            allowVehicleAttach = false,
            allowStorage = true,
            allowSettings = true,
        },
        attachData = {
            bone = 28422,
            xCoord = -0.01,
            yCoord = -0.0,
            zCoord = -0.25,
            xRotation = -175.0,
            yRotation = -180.0,
            zRotation = 180.0,
        },
        animationData = {
            animationDict = 'anim@heists@box_carry@',
            animationName = 'idle',
            blendInSpeed = 8.0,
            blendOutSpeed = -8,
            duration = -1,
            flag = 49,
            playbackRate = 0,
            lockX = 0,
            lockY = 0,
            lockZ = 0,
        }
    },
}