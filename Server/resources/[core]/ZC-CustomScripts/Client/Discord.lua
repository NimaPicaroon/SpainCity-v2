local Players = 0


RegisterNetEvent("Discord:GetInfinityPlayerList", function(players)
	Players = players
end)

-- Citizen.CreateThread(function()
--     while true do
-- 		SetDiscordAppId(734195558742228994)
-- 		SetDiscordRichPresenceAsset('wave')
--         SetDiscordRichPresenceAssetText('Wave')
--         SetDiscordRichPresenceAssetSmall('dc')
--         SetDiscordRichPresenceAssetSmallText('discord.gg/aWNRa972zB')

--         local playerName = GetPlayerName(PlayerId())
--         Players = nil

--         TriggerServerEvent("Discord:GetInfinityPlayerList") -- shitty fix for bigmode
--         repeat
--         Wait(100)
--         until Players

--         Citizen.Wait(1000)

--         SetRichPresence(string.format("%s - %s jugadores", playerName, tonumber(Players)))
-- 		Citizen.Wait(60000)
--   end
-- end)

function SetTrafficDensity(density)
  SetParkedVehicleDensityMultiplierThisFrame(density)
  SetVehicleDensityMultiplierThisFrame(density)
  SetRandomVehicleDensityMultiplierThisFrame(density)
end

function SetPedDensity(density)
  SetPedDensityMultiplierThisFrame(density)
  SetScenarioPedDensityMultiplierThisFrame(density)
end

CreateThread(function()
  local id = PlayerId()

  for i = 0, 20 do
    EnableDispatchService(i, false)
  end

  ClearPlayerWantedLevel(id)
  SetMaxWantedLevel(0)
  DisablePlayerVehicleRewards(id)	
  RemoveAllPickupsOfType(14)

  while true do
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(4)
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false) 
    SetCreateRandomCopsOnScenarios(false)

    SetTrafficDensity(0.5)
    SetPedDensity(0.8)

    Wait(0)
  end
end)