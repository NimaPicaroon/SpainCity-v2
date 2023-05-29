W = exports['ZCore']:get()

CreateThread(function()
    if Config.Framework ~= "standalone" then
        return
    end

    while not NetworkIsSessionStarted() do
        Wait(500)
    end

    loaded = true

    function HasPhoneItem(number)
        if not Config.Item.Require then
            return true
        end

        if Config.Item.Unique then
            return HasPhoneNumber(number)
        end

        if GetResourceState("ox_inventory") == "started" and Config.Item.Inventory == "ox_inventory" then
            return (exports.ox_inventory:Search("count", Config.Item.Name) or 0) > 0
        end

        return true
    end

    function HasJob(jobs)
        local job = PlayerJob.name
        for i = 1, #jobs do
            if jobs[i] == job then
                return true
            end
        end
        return false
    end

function CreateFrameworkVehicle(vehicleData, coords)
        vehicleData.vehicle = json.decode(vehicleData.vehicle)
        if vehicleData.damages then
            vehicleData.damages = json.decode(vehicleData.damages)
        end

        while not HasModelLoaded(vehicleData.vehicle.model) do
            RequestModel(vehicleData.vehicle.model)
            Wait(500)
        end

        local vehicle = CreateVehicle(vehicleData.vehicle.model, coords.x, coords.y, coords.z, 0.0, true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleNumberPlateText(vehicle, vehicleData.vehicle.plate)

        W.SetVehicleProperties(vehicle, vehicleData.vehicle)

        if vehicleData.damages then
            SetVehicleEngineHealth(vehicle, vehicleData.damages.engineHealth)
            SetVehicleBodyHealth(vehicle, vehicleData.damages.bodyHealth)
        end

        if vehicleData.vehicle.fuel then
            SetVehicleFuelLevel(vehicle, vehicleData.vehicle.fuel)
        end

        SetModelAsNoLongerNeeded(vehicleData.vehicle.model)

        return vehicle
    end

     -- Company app
    function GetCompanyData(cb)
        local jobData = {
            name        = player.job.name,
            rank        = player.job.rank,
            rankname    = player.job.rankname,
            ranklabel   = player.job.ranklabel,
            label       = player.job.label,
            salary      = player.job.salary,
            duty        = player.job.duty,
            assignation = 'none'
        }
        cb (jobData)
    end

    function DepositMoney(amount, cb)
        cb(false)
    end

    function WithdrawMoney(amount, cb)
        cb(false)
    end

    function HireEmployee(source, cb)
        cb(false)
    end

    function FireEmployee(identifier, cb)
        cb(false)
    end

    function SetGrade(identifier, newGrade, cb)
        cb(false)
    end

    -- function ToggleDuty()
    --     return false    
    -- end
end)