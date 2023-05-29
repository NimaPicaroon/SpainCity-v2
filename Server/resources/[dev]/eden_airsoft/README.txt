Hey! Thank's for purchasing Eden Airsoft Script.

You can add maps and weapons in config.lua. Also add your locales in locale.lua.
If you want to change UI style/colors just go to html/assets/css/style.css and change global variables (the ones that starts with --* and are inside root {})

Also you need to edit your death system to detect when player dead because was playing airsoft, for that feel free to open a ticket in: https://discord.gg/development.

Example to disable your death system when in airsoft match:

esx_ambulancejob/client/main.lua

Change
AddEventHandler('esx:onPlayerDeath', function(data)
  OnPlayerDeath()
end)

to

AddEventHandler('esx:onPlayerDeath', function(data)
  if not exports['eden_airsoft']:isPlaying() then
    OnPlayerDeath()
  end
end)