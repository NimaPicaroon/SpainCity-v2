CreateThread(function()
    if Config.Framework == 3 then
        SendNotification = function(source, text)
            TriggerClientEvent(Config.FrameworkTriggers['notify'], source, text)
        end
        
        PlayerHasMoney = function(serverId, amount)
            print("Checking has money", serverId, amount)
            return true
        end

        PlayerTakeMoney = function(serverId, amount)
            print("Deducting money", serverId, amount)
        end
    end
end)
