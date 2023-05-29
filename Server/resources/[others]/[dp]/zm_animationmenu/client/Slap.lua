isWithGuitar = false
local musicId = PlayerPedId()
local playing = false
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(100)
        if exports.xsound:soundExists(musicId) and playing then
            if exports.xsound:isPlaying(musicId) and isWithGuitar then
                local pos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("s2v_music:soundStatus", "position", musicId, { position = pos })
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("s2v_music:soundStatus")
AddEventHandler("s2v_music:soundStatus", function(type, musicId, data)
    if type == "position" then
        if exports.xsound:soundExists(musicId) then
            exports.xsound:Position(musicId, data.position)
        end
    end
    if type == "play" then
        exports.xsound:PlayUrlPos(musicId, data.link, 0.20, data.position)
        exports.xsound:Distance(musicId, 20)
    end
    if type == "destroy" then
      exports.xsound:Destroy(musicId)
  end
end)

AddEventHandler("OnEmotePlay", function(EmoteName)
   if EmoteName[3] == "Slap" then
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'slap', 0.8)
   elseif EmoteName[3] == "Guitar" then
      isWithGuitar = true
      playing = true
      local pos = GetEntityCoords(PlayerPedId())
    --   TriggerServerEvent("s2v_music:soundStatus", "play", musicId, { position = pos, link = "./sounds/guitar.mp3" })
   end
end)

AddEventHandler("OnEmoteCancel", function(EmoteName)
   if isWithGuitar then
      isWithGuitar = false
      playing = false
      TriggerServerEvent("s2v_music:soundStatus", "destroy", musicId, {  })
   end
end)