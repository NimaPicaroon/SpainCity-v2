--================================--
--       POLICE TOOLS v1.1.5      --
--            by GIMI             --
--      License: GNU GPL 3.0      --
--================================--

--================================--
--          BLIP MANAGER          --
--================================--

UnitsRadar = {
    serverID = GetPlayerServerId(PlayerId()),
    sentCallsign = false,
    active = {},
    distant = {},
    _panic = {},
	__index = self
}

ReferencesList = {
    { label = 'CNP', value = 'r 38' },
    { label = 'MERY', value = 'r 27' },
    { label = 'GEO', value = 'r 72' },
    { label = 'SMA', value = 'r 43' },
    { label = 'SMP', value = 'r 8' },
    { label = 'TAC', value = 'r 1' },
    { label = 'OPERATIVOS', value = 'r 64' },
    { label = 'REFERENCIA BLANCA', value = 'nr' },
    { label = 'QUITAR REFERENCIA', value = 'removeBlip' },
}

function UnitsRadar:openMenu()
    local pressed = false

    W.OpenMenu("Referencias", "police-refs", ReferencesList, function(data, menu)
        pressed = true
        W.DestroyMenu(menu)

        ExecuteCommand(data.value)
    end, function()
        if not pressed then
            Wait(200)
            ExecuteCommand('interactionmenu')
        end
    end)
end

exports('openMenu', function()
    UnitsRadar:openMenu()
end)

function UnitsRadar:updateAll(activeBlips)
    for k, v in pairs(activeBlips) do
        self:update(v.source, v.coords.x, v.coords.y, v.coords.z, v.heading, v.type, v.number)
    end
end

function UnitsRadar:update(playerID, x, y, z, heading, type, number)
    playerID = tonumber(playerID)

    local color = tonumber(type) or 0
    local player = GetPlayerFromServerId(playerID)
    local wasDistant = self.distant[playerID]
    self.distant[playerID] = (player == -1)

    if (wasDistant and not self.distant[playerID]) or (not wasDistant and self.distant[playerID]) then
        self:remove(playerID, false) -- The player's gotten into your scope / outside your scope -> remove the existing blip, it'll be re-created below with the new parameters
    end
    
    if not DoesBlipExist(self.active[playerID]) then
        self.active[playerID] = self.distant[playerID] and AddBlipForCoord(x, y, z) or AddBlipForEntity(GetPlayerPed(player))
        SetBlipScale(self.active[playerID], 0.9)
        SetBlipSprite(self.active[playerID], 1)
        SetBlipCategory(self.active[playerID], 1)
        SetBlipHiddenOnLegend(self.active[playerID], true)
        SetBlipPriority(self.active[playerID], 10)
        ShowHeightOnBlip(self.active[playerID], false)
        if heading then
            ShowHeadingIndicatorOnBlip(self.active[playerID], true)
            SetBlipRotation(self.active[playerID], heading)
        end
        self.distant[playerID] = true   
    elseif self.distant[playerID] then
        SetBlipCoords(self.active[playerID], x, y, z)
        if heading then
            SetBlipRotation(self.active[playerID], heading)
        end
    end

    if number then
        ShowNumberOnBlip(self.active[playerID], number)
    end

    SetBlipColour(self.active[playerID], color)
end

function UnitsRadar:remove(playerID, removeDistant)
    if self.active[playerID] then
        RemoveBlip(self.active[playerID])
        self.active[playerID] = nil

        if removeDistant then
            self.distant[playerID] = nil
        end
    end
end

function UnitsRadar:removeAll()
    for k, v in pairs(self.active) do
        self:remove(k)
    end
end

--================================--
--            COMMANDS            --
--================================--


--================================--
--             BIGMAP             --
--================================--

local stopBigmap = nil
local map = false
local mapInFalse = false
RegisterCommand(
    'bigmap',
    function()
        map = not map

    end,
    false
)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         if(map)then
--             mapInFalse = false
--             SetBigmapActive(true, false)
--         else
--             if mapInFalse == false then
--                 mapInFalse = true
--                 SetBigmapActive(false, false)
--             end
--         end 
--     end
-- end)

-- RegisterKeyMapping('bigmap', 'Extensión de mapa', 'keyboard', Config.UnitsRadar.bigmapKey)

--================================--
--              SYNC              --
--================================--

RegisterNetEvent('police:removeUnit')
AddEventHandler(
    'police:removeUnit',
    function(playerID, unsubscribe)
        UnitsRadar:remove(playerID)
    end
)

RegisterNetEvent('police:removeBlips')
AddEventHandler(
    'police:removeBlips',
    function()
        UnitsRadar:removeAll()
    end
)

RegisterNetEvent('police:updateBlips')
AddEventHandler(
    'police:updateBlips',
    function(blips)
        UnitsRadar:updateAll(blips)
    end
)