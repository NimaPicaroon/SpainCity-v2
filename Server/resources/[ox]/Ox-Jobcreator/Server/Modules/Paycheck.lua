PaycheckController = setmetatable({ }, PaycheckController)
PaycheckController.__index = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30 * 60 * 1000) -- 30 minutes

        if not JOB.Jobs['unemployed'] then
            return
        end

        for k, v in pairs(JOB.Jobs['unemployed'].players) do
            local player = W.GetPlayer(v)

            if player and player.job.name == 'unemployed' then
                player.addMoney('bank', 250)
                player.Notify('SALARIO', 'Has cobrado ~g~$100~w~.', 'verify')
            end
        end

        W.Print("INFO", 'Unemployed salary have been sended')
    end
end)