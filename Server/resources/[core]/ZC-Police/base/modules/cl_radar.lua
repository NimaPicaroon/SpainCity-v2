RadarController = setmetatable({ }, RadarController)
RadarController._variables = {
    active = false
}
RadarController.__index = RadarController

RadarController.toggle = function()
    RadarController._variables.active = not RadarController._variables.active

    local self = {}
    self.playerData = W.GetPlayerData()
    self.active = RadarController._variables.active

    if self.playerData.job and self.playerData.job.name == 'police' and self.playerData.job.duty then
        if self.active then
            SendNUIMessage({
                action = 'show',
            })
        else
            SendNUIMessage({
                action = 'hide',
            })
        end
    end

    self._init = function()
        while self.active do
            local playerPed = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(playerPed)

            if not IsPauseMenuActive() then
                if DoesEntityExist(playerVeh) then
                    local vehicle = exports['Ox-Jobcreator']:shape(playerVeh)
                    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

                    if model == 'CARNOTFOUND' or model == 'NULL' then
                        model = 'Desconocido'
                    end

                    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                        SendNUIMessage({
                            action = 'update',
                            info = {
                                plate = GetVehicleNumberPlateText(vehicle),
                                model = model,
                                speed = math.ceil(GetEntitySpeed(vehicle) * 3.6),
                            }
                        })
                    end
                else
                    self.active = false

                    SendNUIMessage({
                        action = 'hide',
                    })
                end
            else
                SendNUIMessage({
                    action = 'hide',
                })
            end

            Citizen.Wait(500)
        end
    end

    self._init()
end

RegisterCommand('policeradar', RadarController.toggle)
RegisterKeyMapping('policeradar', 'Activar/Desactivar radar policial', 'keyboard', '6')