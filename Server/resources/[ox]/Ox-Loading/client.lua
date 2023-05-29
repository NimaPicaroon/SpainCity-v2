CreateThread(function()
    SetManualShutdownLoadingScreenNui(true)
end)

RegisterNetEvent("LoadingScreen:shutdown", function ()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    SetScriptAsNoLongerNeeded("Intro")
    
end)