--#region Functions
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local searching = false

---Begins animation depending on data type
---@param data table Animation Data
---@param p string Promise
local function animType(data, p)
    if data then
        if data.disableMovement then
            cfg.animDisableMovement = true
        end
        if data.disableLoop then
            cfg.animDisableLoop = true
        end
        if data.dance then
            Play.Animation(data.dance, data.particle, data.prop, p)
        elseif data.scene then
            Play.Scene(data.scene, p)
        elseif data.expression then
            Play.Expression(data.expression, p)
        elseif data.walk then
            Play.Walk(data.walk, p)
        elseif data.shared then
            Play.Shared(data.shared, p)
        end
    end
end

---Begins cancel key thread
-- local function enableCancel()
--     CreateThread(function()
--         while cfg.animActive or cfg.sceneActive do
--             if IsControlJustPressed(0, cfg.cancelKey) then
--                 Load.Cancel()
--                 break
--             end
--             Wait(10)
--         end
--     end)
-- end

---Finds an emote by command
---@param emoteName table
local function findEmote(emoteName)
    if emoteName then
        local name = emoteName:upper()
        SendNUIMessage({action = 'findEmote', name = name})
    end
end

---Returns the current walking style saved in kvp
---@return string
local function getWalkingStyle(cb)
    local savedWalk = GetResourceKvpString('savedWalk')
    if savedWalk then
        if cb then
            return cb(savedWalk)
        end
        return savedWalk
    end
    if cb then
        return cb(nil)
    end
    return nil
end
--#endregion

--#region NUI callbacks
RegisterNUICallback('changeCfg', function(data, cb)
    if data then
        if data.type == 'movement' then
            cfg.animMovement = not data.state
        elseif data.type == 'loop' then
            cfg.animLoop = not data.state
        elseif data.type == 'settings' then
            cfg.animDuration = tonumber(data.duration) or cfg.animDuration
            cfg.cancelKey = tonumber(data.cancel) or cfg.cancelKey
            cfg.defaultEmote = data.emote or cfg.defaultEmote
            cfg.defaultEmoteKey = tonumber(data.key) or cfg.defaultEmoteKey
        end
    end
    cb({})
end)

RegisterNUICallback('cancelAnimation', function(_, cb)
    Load.Cancel()
    cb({})
end)

RegisterNUICallback('removeProps', function(_, cb)
    Load.PropRemoval('global')
    cb({})
end)

 function quitarraton()
     SetNuiFocus(false)
     SetNuiFocusKeepInput(false)
 end

RegisterNUICallback('exitPanel', function(_, cb)
    if cfg.panelStatus then
        cfg.panelStatus = false
        quitarraton()
        SendNUIMessage({action = 'panelStatus', panelStatus = cfg.panelStatus})
    end
    cb({})
end)

RegisterNUICallback('sendNotification', function(data, cb)
    if data then
        Play.Notification(data.type, data.message)
    end
    cb({})
end)


RegisterNUICallback('initShearch', function(data, cb)
    searching = true
    cb({})
end)


RegisterNUICallback('cancelShearch', function(data, cb)
    searching = false
    cb({})
end)


RegisterNUICallback('fetchStorage', function(data, cb)
    if data then
        for _, v in pairs(data) do
            if v == 'loop' then
                cfg.animLoop = true
            elseif v == 'movement' then
                cfg.animMovement = true
            end
        end
        local savedWalk = GetResourceKvpString('savedWalk')
        if savedWalk then -- If someone has a better implementation which works with multichar please share it.
            local p = promise.new()
            Wait(cfg.waitBeforeWalk)
            Play.Walk({style = savedWalk}, p)
            local result = Citizen.Await(p)
            if result.passed then
                Play.Notification('info', 'Set old walk style back.')
            end
        end
    end
    cb({})
end)

RegisterNUICallback('beginAnimation', function(data, cb)
    --Load.Cancel()
    local animState = promise.new()
    animType(data, animState)
    local result = Citizen.Await(animState)
    if result.passed then
        -- if not result.shared then
        --     enableCancel()
        -- end
        cb({e = true})
        return
    end
    if result.nearby then cb({e = 'nearby'}) return end
    cb({e = false})
end)
--#endregion

--#region Commands
RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatus
    SendNUIMessage({action = 'panelStatus',panelStatus = cfg.panelStatus})
end)

RegisterCommand(cfg.commandNameEmote, function(_, args)
    if args and args[1] then
        return findEmote(args[1])
    end
    Play.Notification('info', 'No emote name set...')
end)

RegisterCommand(cfg.defaultCommand, function()
    if cfg.defaultEmote then
        findEmote(cfg.defaultEmote)
    end
end)

if cfg.defaultEmoteUseKey then
    CreateThread(function()
        while cfg.defaultEmoteKey do
            if IsControlJustPressed(0, cfg.defaultEmoteKey) then
                findEmote(cfg.defaultEmote)
            end
            Wait(5)
        end
    end)
end

if cfg.keyActive then
    RegisterKeyMapping(cfg.commandName, cfg.keySuggestion, 'keyboard', cfg.keyLetter)
end
--#endregion

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() == name then
        Load.Cancel()
    end
end)

---Event for updating cfg from other resource
---@param _cfg table
---@param result any
---@return any
AddEventHandler('anims:updateCfg', function(_cfg, result)
    if GetCurrentResourceName() == GetInvokingResource() then
        CancelEvent()
        return print('Cannot use this event from the same resource!')
    end
    if type(_cfg) ~= "table" then
        print(GetInvokingResource() .. ' tried to update anims cfg but it was not a table')
        CancelEvent()
        return
    end
    local oldCfg = cfg
    for k, v in pairs(_cfg) do
        if cfg[k] and v then
            cfg[k] = v
        end
    end
    print(GetInvokingResource() .. ' updated anims cfg!')
    if result then
        print('Old:' .. json.encode(oldCfg) .. '\nNew: ' .. json.encode(cfg))
    end
end)

exports('PlayEmote', findEmote)
exports('GetWalkingStyle', getWalkingStyle)

CreateThread(function()
    while true do
        if cfg.panelStatus then
            DisableControlAction(1 , 24 , true)
            DisableControlAction(0, 1, true) -- Disable pan
		    DisableControlAction(0, 2, true) -- Disable tilt
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(true)
        end
        
        if searching then
            DisableAllControlActions(true)
            SetNuiFocus(true, false)
            SetNuiFocusKeepInput(false)
        end
        Wait(0)
    end
end)

-- CreateThread(function()
--     while false do
--         if cfg.panelStatus then
--             SetNuiFocus(false)
--             SetNuiFocusKeepInput(false)
--         end
--         Wait(0)
--     end
-- end)