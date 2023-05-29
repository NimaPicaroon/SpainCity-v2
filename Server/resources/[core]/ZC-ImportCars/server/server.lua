ImportController = setmetatable({ }, ImportController)
ImportController.__variables = {
    currentImporters = 0
}
ImportController.runningImporters = {}
ImportController.__index = ImportController

RegisterServerEvent("ZC-ImportCars:registerNewImport", function(data)
    ImportController.runningImporters[data.uniqueId] = data
    ImportController.__variables.currentImporters = ImportController.__variables.currentImporters +1
end)

RegisterServerEvent("ZC-ImportCars:sendTarget", function(target)
    if(target)then
        TriggerClientEvent("ZC-ImportCars:start", target)
    end
end)

RegisterServerEvent("ZC-ImportCars:tickPolice", function(id, coords)
    local jobs = exports["ZCore"]:GetJobTable()
    if(not jobs["police"])then
        return W.Print("ERROR", "Table police doesn't exist, check the core.")
    end
    for k, v in pairs(jobs["police"])do
        if(v.player)then
            TriggerClientEvent("ZC-ImportCars:tickPolice", v.player, id, coords)
        end
    end
end)

RegisterServerEvent("ZC-ImportVehicles:finish", function(data)
    ImportController.runningImporters[data.uniqueId] = nil
    ImportController.__variables.currentImporters = ImportController.__variables.currentImporters -1
    local finalMoney = math.random(Cfg.MoneySections[1], Cfg.MoneySections[2])
    local player = W.GetPlayer(source)
    W.SendToDiscord(
        "https://discord.com/api/webhooks/1062439274265464852/R0hXjWoE3wLeDJPhkltD46ClNPIwfvWiOYzqQVhE7b7lkClN70H5LqpNQ3nCWf7yfndw",
        "Importación terminado",
        "Recompensa: " .. finalMoney .. " (dinero negro)\nVehículo: " .. data.selectedVehicle,
        source
    )
    player.Notify("IMPORTACIÓN", "Has entregado el vehículo correctamente, aquí tienes tu dinero ~g~(" .. finalMoney .. "$)")
    player.addMoney("money", tonumber(finalMoney))
end)

W.CreateCallback("ZC-ImportCars:canStart", function(source, callback)
    local jobs = exports["ZCore"]:GetJobTable()
    local policeVerification = false
    local currentImportVerification = false
    if(jobs["police"] and #jobs["police"] >= Cfg.PoliceNeeded)then
        policeVerification = true
    end
    if(ImportController.__variables.currentImporters < Cfg.CurrentImportersAtTheSameTime)then
        currentImportVerification = true
    end
    if(policeVerification and currentImportVerification)then
        callback(true)
    elseif(policeVerification and not currentImportVerification)then
        callback(false)
    elseif(not policeVerification and currentImportVerification)then
        callback(false)
    elseif(not policeVerification and not currentImportVerification)then
        callback(false)
    end
end)