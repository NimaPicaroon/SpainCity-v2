local W = exports.ZCore:get()
local radioMenu = false
local onRadio = false
local RadioChannel = 0
local RadioVolume = 50

--Function
local function LoadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

local function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    exports["pma-voice"]:setRadioChannel(channel)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        W.Notify('Radio', Config.messages['joined_to_radio'] ..channel.. ' MHz', 'verify')
    else
        W.Notify('Radio', Config.messages['joined_to_radio'] ..channel.. '.00 MHz', 'verify')
    end
end

local function closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
end

local function leaveradio()
    closeEvent()
    RadioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    W.Notify('Radio', Config.messages['you_leave'] , 'error')
end

local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
		TriggerEvent("attachItemRadio","radio01")
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        toggleRadioAnimation(true)
        SendNUIMessage({type = "open"})
    else
        toggleRadioAnimation(false)
        SendNUIMessage({type = "close"})
    end
end

local function IsRadioOn()
    return onRadio
end

--Exports
exports("IsRadioOn", IsRadioOn)

--Events
AddEventHandler('ZCore:playerLoaded', function()
    W.TriggerCallback('ZCore:checkItem', function(hasItem)
        if not hasItem then
            if RadioChannel ~= 0 then
                leaveradio()
            end
        end
    end, "radio")
end)

RegisterNetEvent('radio:use', function()
    toggleRadio(not radioMenu)
end)

RegisterCommand('radio', function()
    toggleRadio(not radioMenu)
end)

RegisterNetEvent('radio:onRadioDrop', function()
    if RadioChannel ~= 0 then
        leaveradio()
    end
end)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
    local playerData = W.GetPlayerData()
    local rchannel = tonumber(data.channel)
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if rchannel ~= RadioChannel then
                if Config.RestrictedChannels[rchannel] ~= nil then
                    if Config.RestrictedChannels[rchannel][playerData.job.name] and playerData.job.duty then
                        connecttoradio(rchannel)
                    else
                        W.Notify('Radio', Config.messages['restricted_channel_error'], 'error')
                    end
                else
                    connecttoradio(rchannel)
                end
            else
                W.Notify('Radio', Config.messages['you_on_radio'] , 'error')
            end
        else
            W.Notify('Radio', Config.messages['invalid_radio'] , 'error')
        end
    else
        W.Notify('Radio', Config.messages['invalid_radio'] , 'error')
    end
end)

RegisterNUICallback('leaveRadio', function(data, cb)
    if RadioChannel == 0 then
        W.Notify('Radio', Config.messages['not_on_radio'], 'error')
    else
        leaveradio()
    end
end)

RegisterNUICallback("volumeUp", function()
	if RadioVolume <= 95 then
		RadioVolume = RadioVolume + 5
		W.Notify('Radio', Config.messages["volume_radio"] .. RadioVolume, "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		W.Notify('Radio', Config.messages["decrease_radio_volume"], "error")
	end
end)

RegisterNUICallback("volumeDown", function()
	if RadioVolume >= 10 then
		RadioVolume = RadioVolume - 5
		W.Notify('Radio', Config.messages["volume_radio"] .. RadioVolume, "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		W.Notify('Radio', Config.messages["increase_radio_volume"], "error")
	end
end)

RegisterNUICallback("increaseradiochannel", function(data, cb)
    local newChannel = RadioChannel + 1
    exports["pma-voice"]:setRadioChannel(newChannel)
    W.Notify('Radio', Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
end)

RegisterNUICallback("decreaseradiochannel", function(data, cb)
    if not onRadio then return end
    local newChannel = RadioChannel - 1
    if newChannel >= 1 then
        exports["pma-voice"]:setRadioChannel(newChannel)
        W.Notify('Radio', Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
    end
end)

RegisterNUICallback('poweredOff', function(data, cb)
    leaveradio()
end)

RegisterNUICallback('escape', function(data, cb)
    toggleRadio(false)
end)

--Main Thread
CreateThread(function()
    while true do
        Wait(120000)
        if onRadio then
            W.TriggerCallback('ZCore:checkItem', function(hasItem)
                if not hasItem then
                    if RadioChannel ~= 0 then
                        leaveradio()
                    end
                end
            end, "radio")
        end
    end
end)
