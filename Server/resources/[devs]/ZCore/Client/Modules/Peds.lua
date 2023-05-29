RegisterCommand("canjear", function(source, args)
    if args[1] then
        TriggerServerEvent("ZCore:registerPed", args[1])
    end
end, false)